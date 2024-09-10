//
//  SaveLinkFeature.swift
//  Features
//
//  Created by 문정호 on 8/11/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Services

import ComposableArchitecture

@Reducer
public struct SaveLinkFeature {
  @ObservableState
  public struct State: Equatable {
    var urlText = ""
    var saveButtonActive = false
    var isValidationURL = true
    var validationReasonText = "URL 형식이 올바르지 않아요. 다시 입력해주세요."
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    //MARK: UserAction
    case onTapNextButton
    case onTapBackButton
    
    // MARK: Inner Business Action
    case postLinkSummary
            
    // MARK: Present Action
    case linkSummaryLoadingAlertPresented
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
            let feedId: Int = try await linkClient.postLinkSummary(state.urlText, "안드로이드에서의 빌드는 아앙아아 안드로이드에서의 빌드를 이해하기 위해서는 먼저 컴파일 과정부터 다시 살펴보는 것이 좋습니다. 리눅스 컴파일과의 차이점은 안드로이드에는 리소스(Resource)라는 개념이 있다는 점입니다. 안드로이드는 2단계로 컴파일을 나눌 수 있습니다.1단계는 바이트코드 단계입니다. 다음 그림과 같이 소스 코드와 리소스(이미지 파일, 음악 파일 등), 라이브러리까지 한 번에 컴파일해줍니다. 이때 생성된 파일은 안드로이드 플랫폼에서 인식할 수 있는 바이트코드로 컴파일됩니다. 이 파일은 스마트폰에서 바로 실행할 수 없습니다.")
            
            // 요약 성공 시 LodingAlert 닫힌 후 2초 뒤 메인으로 이동
            try? await Task.sleep(for: .seconds(2))
            
            await alertClient.dismiss()
            await send(.onTapBackButton)
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
                
      default:
        return .none
      }
    }
  }
}
