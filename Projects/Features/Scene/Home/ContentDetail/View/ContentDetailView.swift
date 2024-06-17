//
//  ContentDetailView.swift
//  Blink
//
//  Created by 김규철 on 2024/04/09.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import Common
import CommonFeature

struct ContentDetailView: View {
    @ObservedObject private var viewModel = ContentDetailViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                      CommonFeature.Images.contentDetailBackground
                            .resizable()
                            .frame(height: 272)
                        
                        VStack(spacing: 0) {
                            cotentDetailNavigationBar
                              .ignoresSafeArea(edges: .top)
                            topContentView
                            topButtonView
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 24)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("요약 내용")
                            .font(.semiBold(size: ._18))
                            .foregroundColor(Color.bkColor(.black))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ContentDetailTextView(text: viewModel.dummyText1)
                        
                        BKChipView(keyword: ["Design", "Design", "Design"], textColor: .bkColor(.gray700), strokeColor: .bkColor(.gray500), font: .semiBold(size: ._11))
                       
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 6) {
                            Text("폴더")
                                .font(.semiBold(size: ._18))
                                .foregroundColor(Color.bkColor(.black))
                            Text("수정")
                                .font(.regular(size: ._12))
                                .foregroundColor(Color.bkColor(.gray600))
                            Spacer()
                        }
                        FolderItemView(text: "기획")
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 6) {
                            Text("메모")
                                .font(.semiBold(size: ._18))
                                .foregroundColor(Color.bkColor(.black))
                            Text("수정")
                                .font(.regular(size: ._12))
                                .foregroundColor(Color.bkColor(.gray600))
                            Spacer()
                        }
                        ContentDetailTextView(text: viewModel.dummyText2)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity)
            .toolbar(.hidden, for: .navigationBar)
            .edgesIgnoringSafeArea(.top)
            
            Button {
                print("원문보기")
            } label: {
                Text("원문보기")
                    .font(.semiBold(size: ._16))
                    .foregroundColor(.bkColor(.white))
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.bkColor(.main300))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(.white)
        }
    }
    
    private var cotentDetailNavigationBar: some View {
        HStack(spacing: 0) {
            Button {
                print("icoChevronLeft")
            } label: {
              CommonFeature.Images.icoChevronLeft
                    .renderingMode(.template)
                    .foregroundColor(Color.bkColor(.white))
            }
            
            Spacer()
            
            Button {
                print("icoMoreVertical")
            } label: {
              CommonFeature.Images.icoMoreVertical
                    .renderingMode(.template)
                    .foregroundColor(Color.bkColor(.white))
            }
        }
        .frame(height: 56)
    }
    
    private var topContentView: some View {
        VStack(alignment: .leading, spacing: 0) {
          CommonFeature.Images.icoBellClick
                .padding(.bottom , 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("방문자 상위 50위 생성형 AI 웹 서비스 분석")
                .font(.regular(size: ._28))
                .foregroundColor(Color.bkColor(.white))
                .lineLimit(2)
            
            Text("2024.02.123")
                .font(.regular(size: ._16))
                .foregroundColor(Color.bkColor(.white))
        }
    }

    private var topButtonView: some View {
        HStack(spacing: 20) {
            Button {
                print("icoBell")
            } label: {
              CommonFeature.Images.icoBell
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.bkColor(.white))
            }
            
            Button {
                print("icoSave")
            } label: {
              CommonFeature.Images.icoSave
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.bkColor(.white))
            }
            
            Button {
                print("icoShare")
            } label: {
              CommonFeature.Images.icoShare
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.bkColor(.white))
            }
        }
        .frame(maxWidth:.infinity, alignment: .trailing)
        .padding(.bottom, 24)
    }
}
