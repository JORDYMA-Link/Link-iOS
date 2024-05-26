//
//  SaveLinkView.swift
//  Blink
//
//  Created by 문정호 on 4/29/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI
import CommonFeature

struct SaveLinkView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var viewModel = SaveLinkViewModel()
    
    var body: some View {
        VStack(alignment: .leading, content: {
            if #available(iOS 17.0, *) {
                (
                    Text("링크")
                        .foregroundStyle(Color.bkColor(.main300))
                    + Text("를 입력해주세요")
                        .foregroundStyle(Color.bkColor(.gray900))
                )
                .font(.semiBold(size: BKFont.HeadlineSize.Headline3))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                
            } else {

            }
            
            Text("블링크가 무엇이든 요약해줍니다")
                .frame(alignment: .leading)
                .font(.regular(size: BKFont.BodySize.Body2))
                .foregroundStyle(Color.bkColor(.gray700))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0))
            
            HStack(alignment: .top){
                switch viewModel.state {
                case .notValidationURL:
                    VStack(alignment: .leading){
                        TextField(text: Binding(get: {viewModel.urlText}, set: {viewModel.urlText = $0 })) {
                            Text("링크를 붙여주세요")
                                .font(.regular(size: BKFont.BodySize.Body2))
                                .foregroundStyle(Color.bkColor(.gray800))
                        }
                        .frame(height: 46)
                        .padding(.leading, 10)
                        .background(Color.bkColor(.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.bkColor(.red), lineWidth: 1)
                        )
                        Text("URL 형식이 올바르지 않아요. 다시 입력해주세요.")
                            .font(.regular(size: BKFont.BodySize.Body4))
                            .foregroundStyle(Color.bkColor(.red))
                    }
                    
                    
                default:
                    ClearableTextField(text: Binding(get: {viewModel.urlText}, set: {viewModel.urlText = $0 }), placeholder: "링크를 붙여주세요")
                }
                
                
                if case let .buttonActivate(value) = viewModel.state, value {
                    abledButton
                } else {
                    unabledButton
                }
            }
            
        })
        .padding(EdgeInsets(top: 28, leading: 16, bottom: 0, trailing: 16))
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    viewModel.action(.onTapBackButton)
                }, label: {
                    HStack{
                        CommonFeatureAsset.Images.icoChevronLeft.swiftUIImage
                        Text("링크 저장")
                            .font(.semiBold(size: BKFont.TitileSize.Titile4))
                            .foregroundStyle(Color.bkColor(.gray800))
                    }
                })
                
            }
        }
        .fullScreenCover(
            isPresented: Binding(get: {viewModel.presentLoading}, set: {viewModel.presentLoading = $0}),
            content: {
                    BKModal(modalType: .linkLoading(checkAction: {}, cancelAction: {
                        self.viewModel.presentLoading.toggle()
                    }))
                    .transition(.opacity)
        })
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
        
        Spacer()
    }
    
    @ViewBuilder
    private var unabledButton: some View {
        Button {
            viewModel.action(.onTapNextButton)
        } label: {
            CommonFeatureAsset.Images.icoChevronRight.swiftUIImage
                .renderingMode(.template)
                .foregroundStyle(Color.bkColor(.gray800))
        }
        .frame(width: 46, height: 46)
        .background(Color.bkColor(.gray300))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    @ViewBuilder
    private var abledButton: some View {
        Button {
            viewModel.action(.onTapNextButton)
        } label: {
            CommonFeatureAsset.Images.icoChevronRight.swiftUIImage
                .renderingMode(.template)
                .foregroundStyle(Color.bkColor(.white))
        }
        .frame(width: 46, height: 46)
        .background(Color.bkColor(.main300))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack(root: {SaveLinkView()})
}
