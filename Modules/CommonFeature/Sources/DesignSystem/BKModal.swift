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
    private var cancleAction: (() -> Void)?
    private var checkAction: (() -> Void)?
    
    
    //MARK: - Initialization
    public init(cancleAction: (() -> Void)? = nil, checkAction: ( () -> Void)? = nil) {
        self.cancleAction = cancleAction
        self.checkAction = checkAction
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
        ZStack{
            Rectangle()
                .frame(maxWidth: 327, maxHeight: 307)
                .clipShape(.rect(cornerRadius: 10))
                .foregroundStyle(.white)
            
            VStack{
                LottieView(animation: .named("lodingAnimation", bundle: CommonFeatureResources.bundle))
                    .playing(loopMode: .loop)
                    .frame(width: 90, height: 59)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                
                Text("기본 모달 케이스")
                    .font(.title3)
                    .padding(.bottom, 8)
                
                Text("여기에 텍스트를 적습니다.\n한줄 두줄 모두 가능")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(BKColor.gray700.swiftUIColor)
                
                if let checkAction {
                    HStack(content: {
                        if let cancleAction {
                            Button(action: cancleAction, label: {
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
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
                }
            }
        }
    }
}
