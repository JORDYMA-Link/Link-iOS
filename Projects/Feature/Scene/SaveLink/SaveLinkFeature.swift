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
    var urlText = ""
    var saveButtonActive = false
    var isValidationURL = true
    var validationReasonText = "URL 형식이 올바르지 않아요. 다시 입력해주세요."
    var isLoading: Bool = false
    
    var ad: GoogleAd?
    var isAdPresented: Bool = false
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    //MARK: UserAction
    case onAppear
    case onTapNextButton
    case adDismissButtonTapped
    case onTapBackButton
    
    // MARK: Inner Business Action
    case postLinkSummary
    case loadAd
    case sendAnalyticsLog
    
    // MARK: Inner SetState Action
    case setAd(GoogleAd)
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
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.urlText):
        if !state.urlText.isEmpty {
          let valid = state.urlText.containsHTTPorHTTPS
          
          state.isValidationURL = valid
          state.saveButtonActive = valid
        } else {
          state.isValidationURL = true
          state.saveButtonActive = false
        }
        
        return .none
        
      case .onAppear:
        return .send(.loadAd)
                
      case .onTapBackButton:
        return .run { _ in await self.dismiss() }
        
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
        
      case .sendAnalyticsLog:
        feedSummaryButtonTappedLog()
        return .none
        
      case let .setAd(ad):
        state.ad = ad
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
  private func feedSummaryButtonTappedLog() {
    analyticsClient.logEvent(.init(name: .feedSummaryClicked, screen: .feed_summary))
  }
}
