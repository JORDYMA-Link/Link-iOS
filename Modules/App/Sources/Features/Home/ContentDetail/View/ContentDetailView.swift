//
//  ContentDetailView.swift
//  Blink
//
//  Created by 김규철 on 2024/04/09.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

struct ContentDetailView: View {
    @State private var showEdit = false
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                CommonFeatureAsset.Images.contentDetailBackground.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 304)
                
                VStack {
                    cotentDetailNavigationBar
                    cotentDetailTopView
                        .padding(.top, 32)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .toolbar(.hidden, for: .navigationBar)
        .edgesIgnoringSafeArea(.top)
    }
    
    private var cotentDetailNavigationBar: some View {
        HStack {
            Button {
                print("icoChevronLeft")
            } label: {
                CommonFeatureAsset.Images.icoChevronLeft.swiftUIImage
                    .renderingMode(.template)
                    .foregroundColor(Color.bkColor(.white))
            }
            .padding(.leading, 16)
            
            Spacer()
            
            Button {
                print("icoMoreVertical")
            } label: {
                CommonFeatureAsset.Images.icoMoreVertical.swiftUIImage
                    .renderingMode(.template)
                    .foregroundColor(Color.bkColor(.white))
            }
            .padding(.trailing, 16)
        }
        .frame(height: 56)
        .padding(.top, UIApplication.topSafeAreaInset)
    }
    
    private var cotentDetailTopView: some View {
        VStack(alignment: .leading, spacing: 0) {
            CommonFeatureAsset.Images.icoBellClick.swiftUIImage
                .padding(.bottom , 4)
            
            Text("방문자 상위 50위 생성형 AI 웹 서비스 분석")
                .foregroundColor(Color.bkColor(.white))
                .font(.regular(size: BKFont.DisplaySize.Display6))
                .lineLimit(2)
            
            Text("2024.02.12")
                .foregroundColor(Color.bkColor(.white))
                .font(.regular(size: BKFont.BtntxtSize.Btntxt1))
            
        }
    }
    
    @ViewBuilder
    private var editView: some View {
        Button {
            showEdit.toggle()
        } label: {
            CommonFeatureAsset.Images.icoImg.swiftUIImage
        }
    }
}
