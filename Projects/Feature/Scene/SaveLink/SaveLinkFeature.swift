//
//  SaveLinkFeature.swift
//  Features
//
//  Created by 문정호 on 8/11/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Services
import Analytics

import ComposableArchitecture

@Reducer
public struct SaveLinkFeature {
  @ObservableState
  public struct State: Equatable {
    var urlText: String = ""
    
    var isDisableSaveLinkButton: Bool = true
    var isValidationURL: Bool = true
    var urlValidation: URLValidationError = .invalidScheme
    
    var ad: GoogleAd?
    var isAdPresented: Bool = false
    
    var pastoboardURL: String = ""
    var isPastoboardButtonPresented: Bool = false
    
    var isLoading: Bool = false
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    //MARK: UserAction
    case onAppear
    case pastoboardButtonTapped
    case onTapNextButton
    case adDismissButtonTapped
    case onTapBackButton
    
    // MARK: Inner Business Action
    case postLinkSummary
    case loadAd
    case checkPasteboard
    case vaildatePastoboardURL
    case sendAnalyticsLog
    
    // MARK: Inner SetState Action
    case setURLValidation(isURL: Bool, isDisable: Bool)
    case setAd(GoogleAd)
    case setPasteboardURL(String?)
    case setAdPresented(Bool)
    case setLoading(Bool)
    
    // MARK: Present Action
    case linkSummaryLoadingAlertPresented
    case linkSummaryFailAlertPresented
  }
  
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.alertClient) private var alertClient
  @Dependency(\.linkClient) private var linkClient
  @Dependency(AnalyticsClient.self) private var analyticsClient
  @Dependency(GoogleMobileAdsClient.self) private var googleMobileAdsClient
  @Dependency(PasteboardClient.self) private var pasteboardClient
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.urlText), .vaildatePastoboardURL:
        if state.urlText.isEmpty {
          return .send(.setURLValidation(isURL: true, isDisable: true))
        }
        
        if !state.urlText.isHTTPURL {
          state.urlValidation = .invalidScheme
          return .send(.setURLValidation(isURL: false, isDisable: true))
        }
        
        if state.urlText.isYouTubeOrInstagramURL {
          state.urlValidation = .unsupportedYouTubeOrInstagramURL
          return .send(.setURLValidation(isURL: false, isDisable: true))
        }
        
        return .send(.setURLValidation(isURL: true, isDisable: false))
        
      case .onAppear:
        return .run { send in
          await send(.loadAd)
          await send(.checkPasteboard)
        }
        
      case .onTapBackButton:
        return .run { _ in await self.dismiss() }
        
      case .pastoboardButtonTapped:
        state.urlText = state.pastoboardURL
        return .send(.vaildatePastoboardURL)
        
      case .onTapNextButton:
        return .run { send in
          await send(.postLinkSummary)
          await send(.sendAnalyticsLog)
        }
        
      case .adDismissButtonTapped:
        return .run { send in
          await send(.setLoading(false))
          await send(.linkSummaryLoadingAlertPresented)
          
          // 요약 성공 시 LodingAlert 닫힌 후 2초 뒤 메인으로 이동
          try? await Task.sleep(for: .seconds(2))
          
          await alertClient.dismiss()
          await send(.onTapBackButton)
        }
        
      case .postLinkSummary:
        return .run(
          operation: { [state] send in
            await send(.setLoading(true))
            
            _ = try await linkClient.postLinkSummary(state.urlText.trimmingCharacters(in: .whitespaces))
            
            await send(.setAdPresented(true))
          },
          catch: { error, send in
            await send(.setLoading(false))
            await send(.linkSummaryFailAlertPresented)
          }
        )
        
      case .loadAd:
        return .run { send in
          let ad = try await googleMobileAdsClient.load()
          await send(.setAd(ad))
        }
        
      case .checkPasteboard:
        return .run { send in
          for await _ in pasteboardClient.hasString() {
            let url = await pasteboardClient.pasteboardURL()
            await send(.setPasteboardURL(url))
          }
        }
        
      case .sendAnalyticsLog:
        feedSummaryButtonTappedLog()
        return .none
        
      case let .setURLValidation(isURL, isDisable):
        state.isValidationURL = isURL
        state.isDisableSaveLinkButton = isDisable
        return .none
        
      case let .setAd(ad):
        state.ad = ad
        return .none
        
      case let .setPasteboardURL(url):
        guard let url else {
          state.isPastoboardButtonPresented = false
          return .none
        }
        
        state.pastoboardURL = url
        state.isPastoboardButtonPresented = true
        return .none
        
      case let .setAdPresented(isPresented):
        state.isAdPresented = isPresented
        return .none
        
      case let .setLoading(isLoading):
        state.isLoading = isLoading
        return .none
        
      case .linkSummaryLoadingAlertPresented:
        return .run { send in
          await alertClient.present(.init(
            isLoadingType: true,
            title: "잠시만 기다려주세요",
            description: "블링크가 눈 깜짝할 새에 요약할게요",
            buttonType: .singleButton("메인으로"),
            rightButtonAction: { await send(.onTapBackButton) }
          ))
        }
        
      case .linkSummaryFailAlertPresented:
        return .run { send in
          await alertClient.present(.init(
            title: "요약 불가",
            imageType: .link,
            description: "링크 요약에 실패했습니다",
            buttonType: .singleButton("메인으로"),
            rightButtonAction: { await send(.onTapBackButton) }
          ))
        }
        
      default:
        return .none
      }
    }
  }
}

extension SaveLinkFeature {
  enum URLValidationError: Equatable, Sendable {
    /// http 또는 https가 아닌 경우
    case invalidScheme
    /// YouTube && Instagram URL 형식
    case unsupportedYouTubeOrInstagramURL
    
    var title: String {
      switch self {
      case .invalidScheme:
        return "URL 형식이 올바르지 않아요. 다시 입력해주세요."
      case .unsupportedYouTubeOrInstagramURL:
        return "현재 해당 플랫폼의 저장 기능을 지원하지 않습니다.\n빠른 시일 내에 저장 할 수 있도록 준비하고 있습니다."
      }
    }
  }
}

extension SaveLinkFeature {
  private func feedSummaryButtonTappedLog() {
    analyticsClient.logEvent(.init(name: .feedSummaryClicked, screen: .feed_summary))
  }
}
