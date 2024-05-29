//
//  SettingView.swift
//  Blink
//
//  Created by kyuchul on 4/29/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewmodel = SettingViewModel(state: .none, nickname: "블링크", userEmail: "blink@naver.com")
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Text(viewmodel.nickname)
                            .font(.semiBold(size: ._18))
                            .padding(.trailing, -10)
                        Text("님")
                            .font(.regular(size: ._18))
                    }
                    Spacer()
                    Button(action: {
                        viewmodel.action(.tappedNicknameEdit)
                    }, label: {
                        BKIcon(image: CommonFeatureAsset.Images.icoEdit.swiftUIImage, color: Color.bkColor(.gray900), size: CGSize(width: 18, height: 18))
                    })
                }
                Text(viewmodel.userEmail)
                    .font(.light(size: ._12))
                    .tint(Color.bkColor(.gray900)) //E-mail은 tint로 색 변경
            }
            .padding(EdgeInsets(top: 24, leading: 16, bottom: 25, trailing: 16))
            
            Color.bkColor(.gray400)
                .frame(height: 8)
            
            VStack(alignment: .leading, content: {
                Text("공지")
                    .font(.regular(size: ._12))
                    .foregroundStyle(Color.bkColor(.gray700))
                Button(action: {
                    print("공지사항")
                }, label: {
                    Text("공지사항")
                        .font(.regular(size: ._15))
                        .foregroundStyle(Color.bkColor(.gray900))
                })
                .padding(.top, 16)
            })
            .padding(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
            
            Color.bkColor(.gray400)
                .frame(height: 4)
            
            VStack(alignment: .leading, content: {
                Text("서비스 정보")
                    .font(.regular(size: ._12))
                    .foregroundStyle(Color.bkColor(.gray700))
                
                Button(action: {
                }, label: {
                    Text("개인정보 처리 방침")
                        .font(.regular(size: ._15))
                })
                .tint(.bkColor(.gray900))
                .padding(.top, 16)
                
                Button(action: {}, label: {
                    Text("서비스 이용약관")
                        .font(.regular(size: ._15))
                })
                .tint(.bkColor(.gray900))
                .padding(.top, 32)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    HStack {
                        Text("버전 정보")
                            .font(.regular(size: ._15))
                        Spacer()
                        Text("최신 1.0.9")
                            .font(.regular(size: ._12))
                            .foregroundStyle(Color.bkColor(.gray700))
                        Text("현재 1.0.9")
                            .font(.semiBold(size: ._12))
                            .foregroundStyle(Color.bkColor(.gray700))
                    }
                })
                .tint(.bkColor(.gray900))
                .padding(.top, 32)
                
                
            })
            .padding(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
            
            Color.bkColor(.gray400)
                .frame(height: 4)
            
            VStack(alignment: .leading, content: {
                Text("도움말")
                    .font(.regular(size: ._12))
                    .foregroundStyle(Color.bkColor(.gray700))
                Button(action: {}, label: {
                    Text("서비스 이용방법")
                        .font(.regular(size: ._15))
                })
                .tint(.bkColor(.gray900))
                .padding(.top, 16)
                
                Button(action: {}, label: {
                    Text("로그아웃")
                        .font(.regular(size: ._15))
                })
                .tint(.bkColor(.gray900))
                .padding(.top, 32)
                
                Button(action: {}, label: {
                    Text("회원탈퇴")
                        .font(.regular(size: ._12))
                        .underline()
                })
                .tint(.bkColor(.gray700))
                .padding(.top, 32)
            })
            .padding(EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16))
            
        }
        Spacer()
        
        
        
//        List {
//            Section {
//                VStack(alignment: .leading) {
//                    HStack {
//                        HStack {
//                            Text("블링크")
//                                .font(.semiBold(size: ._18))
//                                .padding(.trailing, -9)
//                            Text("님")
//                                .font(.regular(size: ._18))
//                        }
//                        Spacer()
//                        Button(action: {
//                            print("클릭")
//                        }, label: {
//                            BKIcon(image: CommonFeatureAsset.Images.icoEdit.swiftUIImage, color: Color.bkColor(.gray900), size: CGSize(width: 18, height: 18))
//                        })
//                    }
//                    Text("blink@naver.com")
//                        .font(.light(size: ._12))
//                        .tint(Color.bkColor(.gray900)) //E-mail은 tint로 색 변경
//                }
//            }
//            
//            Section {
//                Text("공지사항")
//                    .font(.regular(size: ._15))
//            } header: {
//                HStack{
//                    Text("공지")
//                        .foregroundStyle(Color.bkColor(.gray700))
//                        .padding(EdgeInsets(top: 24, leading: 16, bottom: 16, trailing: 16))
//                    Spacer()
//                }
//                .background(Color.bkColor(.white))
//                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//            }
//            .listRowSeparator(.hidden, edges: .all)
//            
//            Section {
//                Text("개인정보 처리 방침")
//                    .font(.regular(size: ._15))
//                Text("서비스 이용약관")
//                    .font(.regular(size: ._15))
//                HStack {
//                    Text("버전 정보")
//                        .font(.regular(size: ._15))
//                        .foregroundStyle(Color.bkColor(.gray900))
//                    Spacer()
//                    Text("최신 1.0.9")
//                        .font(.regular(size: ._12))
//                        .foregroundStyle(Color.bkColor(.gray700))
//                    Text("현재 1.0.9")
//                        .font(.semiBold(size: ._12))
//                        .foregroundStyle(Color.bkColor(.gray700))
//                }
//            } header: {
//                HStack{
//                    Text("서비스 정보")
//                        .foregroundStyle(Color.bkColor(.gray700))
//                        .padding(EdgeInsets(top: 24, leading: 16, bottom: 16, trailing: 0))
//                    Spacer()
//                }
//                .background(Color.bkColor(.white))
//                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//            }
//            .listRowSeparator(.hidden, edges: .all)
//            
//            Section {
//                Text("문의하기")
//                    .font(.regular(size: ._15))
//                    .foregroundStyle(Color.bkColor(.gray900))
//                Text("고객 지원")
//                    .font(.regular(size: ._15))
//                    .foregroundStyle(Color.bkColor(.gray900))
//                Text("계정 탈퇴")
//                    .font(.regular(size: ._15))
//                    .foregroundStyle(Color.bkColor(.gray900))
//                Spacer(minLength: 200)
//            } header: {
//                HStack{
//                    Text("도움말")
//                        .foregroundStyle(Color.bkColor(.gray700))
//                        .padding()
//                }
//                .background(Color.bkColor(.white))
//                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//            }
//            .listRowSeparator(.hidden, edges: .all)
//        }
//        .listStyle(.grouped)
//        .padding(.top, -35)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                LeadingItem(type: .dismiss("설정", {
                    dismiss()
                }))
            }
        }
        .bottomSheet(isPresented: $viewmodel.showEditNicknameSheet, detents: .init(arrayLiteral: .height(200)), leadingTitle: "닉네임 변경하기") {
            VStack(alignment: .center, content: {
                ClearableTextField(text: $viewmodel.nickname, placeholder: viewmodel.nickname)
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 46, trailing: 20))
                Button(action: {
                    viewmodel.showEditNicknameSheet.toggle()
                }, label: {
                    Text("완료")
                })
                .backgroundStyle(Color.bkColor(.main300))
                .frame(width: .infinity)
                
            })
        }
    }
}

#Preview {
    SettingView()
}
