//
//  BKModal.swift
//  CommonFeature
//
//  Created by 문정호 on 4/8/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI
import Lottie

///공통으로 사용되는 Modal
public struct BKModal: View {
    //MARK: - Properties
    private let modalType: BKModalType
    @Environment(\.dismiss) var dismiss
    
    //MARK: - Initialization
    public init(modalType: BKModalType) {
        self.modalType = modalType
    }
    
    //MARK: - body
    public var body: some View {
        ZStack(content: {
            Color(.black)
                .ignoresSafeArea()
                .opacity(0.6)
                .zIndex(0)
            
          modalView
            .zIndex(1)
            .frame(
              alignment: .center
            )
        })

    }
    
    //MARK: - modalView
    @ViewBuilder
    public var modalView: some View {
      VStack{
        if case .linkLoading(_) = modalType {
          LottieView(animation: .named("lodingAnimation", bundle: CommonFeatureResources.bundle))
            .playing(loopMode: .loop)
            .frame(width: 90, height: 59)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
        }
        
        Text(modalType.modalTitle)
          .font(.semiBold(size: ._14))
          .padding(.bottom, 8)
        
        Text(modalType.modalDescription)
          .font(.regular(size: ._14))
          .multilineTextAlignment(.center)
          .foregroundStyle(BKColor.gray700.swiftUIColor)
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
        
        
        
        switch modalType {
        case .cancelConfirm(checkAction: let checkAction, cancelAction: let cancelAction), .deleteFolder(let checkAction, let cancelAction), .deleteContent(let checkAction, let cancelAction), .photoTypeError(checkAction: let checkAction, cancelAction: let cancelAction), .photoSizeError(checkAction: let checkAction, cancelAction: let cancelAction):
          
          configureButton(checkAction: checkAction, cancelAction: cancelAction)
          
        case let .linkLoading(checkAction):
          configureButton(checkAction: checkAction, cancelAction: nil)
          
        case .custom(_, _, let checkAction, let cancelAction):
          configureButton(checkAction: checkAction, cancelAction: cancelAction)
          
        case .logout(let checkAction, let cancelAction):
          configureButton(checkAction: checkAction, cancelAction: cancelAction)
        default:
          EmptyView()
        }
      }
      .padding(EdgeInsets(top: 28, leading: 20, bottom: 28, trailing: 20)) // 내부 컨텐츠에 패딩 적용
      .frame(maxWidth: .infinity)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(BKColor.white.swiftUIColor)
      )
      .padding(.horizontal, 20)
    }
    
    //MARK: - makeButton
    @ViewBuilder
    private func configureButton(checkAction: @escaping ()->Void, cancelAction: (()->Void)?) -> some View {
        HStack(content: {
            if let cancelAction{
                Button(action: cancelAction, label: {
                    Text(modalType.cancelText)
                        .foregroundStyle(BKColor.gray700.swiftUIColor)
                })
                .frame(maxWidth: 140, maxHeight: 48)
                .background(BKColor.white.swiftUIColor)
                .border(BKColor.gray500.swiftUIColor, width: 1)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Button(action: checkAction, label: {
                Text(modalType.okText)
                    .foregroundStyle(BKColor.white.swiftUIColor)
            })
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(BKColor.gray900.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        })
    }
}

#Preview {
  Text("hello world")
    .modal(isPresented: .constant(true), type: .linkLoading(checkAction: {
      print("hello")
    }))
}

