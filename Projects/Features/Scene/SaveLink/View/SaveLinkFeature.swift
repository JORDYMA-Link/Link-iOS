//
//  SaveLinkFeature.swift
//  Features
//
//  Created by 문정호 on 8/11/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct SaveLinkFeature {
  @ObservableState
  public struct State: Equatable {
    var urlText = ""
    var saveButtonActive = false
    var isValidationURL = true
    var validationReasonText = "URL 형식이 올바르지 않아요. 다시 입력해주세요."
    
    @Presents var link: LinkFeature.State?
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    //MARK: UserAction
    case onTapNextButton
    case onTapBackButton
    
    // MARK: Inner Business Action
    case postLinkSummary
    
    // MARK: Child Action
    case link(PresentationAction<LinkFeature.Action>)
    
    // MARK: Present Action
    case linkSummaryLoadingAlertPresented
    
    // MARK: Navigation Action
    case routeSummaryCompleted(feedId: Int)
  }
  
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.alertClient) private var alertClient
  @Dependency(\.linkClient) private var linkClient
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.urlText):
        state.saveButtonActive = !state.urlText.isEmpty && state.urlText.containsHTTPorHTTPS
        state.isValidationURL = state.urlText.count != 1 && state.urlText.containsHTTPorHTTPS
        return .none
        
      case .onTapBackButton:
        return .run { _ in await self.dismiss() }
        
      case .onTapNextButton:
        return .run { send in
          await send(.linkSummaryLoadingAlertPresented)
          await send(.postLinkSummary)
        }
        
      case .postLinkSummary:
        return .run(
          operation: { [state] send in
            _ = try await linkClient.postLinkSummary(state.urlText, "Dummy")
            
            // 요약 성공 시 LodingAlert 닫힌 후 요약 상세 페이지로 이동
            await alertClient.dismiss()
            await send(.routeSummaryCompleted(feedId: 2))
          },
          catch: { error, send in
            print(error)
          }
        )
        
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
        
      case let .routeSummaryCompleted(feedId):
        state.link = .init(linkType: .summaryCompleted(feedId: feedId))
        return .none
        
      default:
        return .none
      }
    }
  }
}
