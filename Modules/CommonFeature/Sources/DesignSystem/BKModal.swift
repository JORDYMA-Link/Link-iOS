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
    
    //MARK: - Initialization
    public init(modalType: BKModalType) {
        self.modalType = modalType
    }
    
    //MARK: - body
    public var body: some View {
        ZStack(content: {
            Color(.black.withAlphaComponent(0.6)).ignoresSafeArea()
            modalView
        })
    }
    
    //MARK: - modalView
    @ViewBuilder
    public var modalView: some View {
        VStack{
            if case .linkLoading(_, _) = modalType {
                LottieView(animation: .named("lodingAnimation", bundle: CommonFeatureResources.bundle))
                    .playing(loopMode: .loop)
                    .frame(width: 90, height: 59)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
            }

            Text(modalType.modalTitle)
                .font(.semiBold(size: ._16))
                .padding(.bottom, 8)
            
            Text(modalType.modalDescription)
                .font(.regular(size: ._14))
                .multilineTextAlignment(.center)
                .foregroundStyle(BKColor.gray700.swiftUIColor)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
            
            
            switch modalType {
            case .linkLoading(let checkAction, let cancelAction), .cancelConfirm(checkAction: let checkAction, cancelAction: let cancelAction), .deleteFolder(let checkAction, let cancelAction), .deleteContent(let checkAction, let cancelAction):
                
                configureButton(checkAction: checkAction, cancelAction: cancelAction)
                
            case .custom(_, _, let checkAction, let cancelAction):
                configureButton(checkAction: checkAction, cancelAction: cancelAction)
            }
        }
        .padding(EdgeInsets(top: 28, leading: 20, bottom: 28, trailing: 20))
        .background(RoundedRectangle(cornerRadius: 10).fill(BKColor.white.swiftUIColor))
    }
    
    //MARK: - makeButton
    @ViewBuilder
    private func configureButton(checkAction: @escaping ()->Void, cancelAction: (()->Void)?) -> some View {
        HStack(content: {
            if let cancelAction{
                Button(action: cancelAction, label: {
                    Text("취소")
                        .foregroundStyle(BKColor.gray700.swiftUIColor)
                })
                .frame(maxWidth: 140, maxHeight: 48)
                .background(BKColor.white.swiftUIColor)
                .border(BKColor.gray500.swiftUIColor, width: 1)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Button(action: checkAction, label: {
                Text("확인")
                    .foregroundStyle(BKColor.white.swiftUIColor)
            })
            .frame(maxWidth: 140, maxHeight: 48)
            .background(BKColor.gray900.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        })
    }
}

