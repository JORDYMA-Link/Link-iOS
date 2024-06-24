//
//  SettingView.swift
//  Blink
//
//  Created by kyuchul on 4/29/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature
import Common

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewmodel = SettingViewModel(state: .none, nickname: "블링크", userEmail: "blink@naver.com")
    
    var body: some View {
        
        
        ZStack(content: {
            
            settingView
            
            Spacer()
            
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        LeadingItem(type: .dismiss("설정", {
                            dismiss()
                        }))
                    }
                }
            
            if viewmodel.showWithdrawModal {
                withdrawModal
            }
        })
        
        .bottomSheet(isPresented: $viewmodel.showEditNicknameSheet, detents: .init(arrayLiteral: .height(200)), leadingTitle: "닉네임 변경하기") {
            VStack(alignment: .center, content: {
                if viewmodel.targetNickname.containsOnlyKorean {
                    nicknameTextField
                } else {
                    nicknameNoticeTextField
                }

                Spacer()
                
                Button(action: {
                    viewmodel.action(.tappedCompletedEditingNickname)
                }, label: {
                    Text("완료")
                        .foregroundStyle(Color.bkColor(.white))
                })
                .frame(maxWidth: .infinity, maxHeight: 52)
                .background(Color.bkColor(.main300))
            })
        }

        .fullScreenCover(isPresented: $viewmodel.showLogoutConfirmModal, content: {
            BKModal(modalType: .logout(checkAction: {
                
            }, cancelAction: {
                viewmodel.showLogoutConfirmModal = false
            }))
        })
    }
    
}

extension SettingView {
    @ViewBuilder
    private var settingView: some View {
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
                        BKIcon(image: CommonFeature.Images.icoEdit, color: Color.bkColor(.gray900), size: CGSize(width: 18, height: 18))
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
                
                Button(action: {}, label: {
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
                
                Button(action: {
                    viewmodel.action(.tappedLogout)
                }, label: {
                    Text("로그아웃")
                        .font(.regular(size: ._15))
                })
                .tint(.bkColor(.gray900))
                .padding(.top, 32)
                
                Button(action: {
                    viewmodel.action(.tappedWithdrawCell)
                }, label: {
                    Text("회원탈퇴")
                        .font(.regular(size: ._12))
                        .underline()
                })
                .tint(.bkColor(.gray700))
                .padding(.top, 32)
            })
            .padding(EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16))
            
        }
    }
    
    @ViewBuilder
    private var nicknameTextField: some View {
        TextField(text: $viewmodel.targetNickname) {
            Text("변경할 닉네임을 입력해주세요.")
                .font(.regular(size: ._14))
                .foregroundStyle(Color.bkColor(.gray800))
        }
        .frame(height: 46)
        .padding(.leading, 10)
        .background(Color.bkColor(.gray300))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
    }
    
    @ViewBuilder
    private var nicknameNoticeTextField: some View {
        VStack(alignment: .leading, content: {
            TextField(text: $viewmodel.targetNickname) {
                Text("변경할 닉네임을 입력해주세요.")
                    .font(.regular(size: ._14))
                    .foregroundStyle(Color.bkColor(.gray800))
            }
            .frame(height: 46)
            .padding(.leading, 10)
            .background(Color.bkColor(.white))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.bkColor(.red), lineWidth: 1)
            )
            
            Text("특수문자는 허용되지 않습니다.")
                .foregroundStyle(Color.bkColor(.red))
                .font(.regular(size: ._12))
        })
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        
    }
    
    @ViewBuilder
    private var withdrawModal: some View {
        ZStack(content: {
            Color(.black.withAlphaComponent(0.6)).ignoresSafeArea()
            GeometryReader { geometry in
                VStack {
                    modalView
                        .frame(width: geometry.size.width - 24) // 너비에서 24만큼 줄임
                        .padding(.top, geometry.safeAreaInsets.top) // 상단 safe area만큼 패딩 추가
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center) // 전체 화면
            }
        })

    }
    
    //MARK: - modalView
    @ViewBuilder
    public var modalView: some View {
        VStack{
            HStack{
                Spacer()
                
                Button {
                    viewmodel.showWithdrawModal.toggle()
                } label: {
                    BKIcon(image: CommonFeature.Images.icoClose, color: .bkColor(.gray900), size: CGSize(width: 18, height: 18))
                }
            }

            Text(BKModalType.withdrawNotice.modalTitle)
                .font(.semiBold(size: ._14))
                .padding(.bottom, 8)
            
            Text(BKModalType.withdrawNotice.modalDescription)
                .font(.regular(size: ._14))
                .multilineTextAlignment(.leading)
                .foregroundStyle(BKColor.gray700.swiftUIColor)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
            
            Button(action: {
                viewmodel.action(.tappedConfirmWithdrawNotice)
            }, label: {
                HStack {
                    if viewmodel.state != .confirmedWithdrawNotice {
                        Image(systemName: "square" )
                            .foregroundStyle(Color.bkColor(.gray700))
                    } else {
                      CommonFeature.Images.icoCheckBox
                    }
                    
                    Text("안내사항을 확인하였으며, 이에 동의합니다")
                        .font(.regular(size: ._13))
                        .foregroundStyle(Color.bkColor(.gray900))
                }
                
            })
            
            Button(action: {
                
            }, label: {
                Text(BKModalType.withdrawNotice.okText)
                    .foregroundStyle(viewmodel.state != .confirmedWithdrawNotice ? BKColor.gray600.swiftUIColor : BKColor.white.swiftUIColor)
                    .frame(maxWidth: 140, maxHeight: 48)
            })
            .disabled(viewmodel.state != .confirmedWithdrawNotice)
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(viewmodel.state != .confirmedWithdrawNotice ? BKColor.gray400.swiftUIColor : BKColor.gray900.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(EdgeInsets(top: 28, leading: 20, bottom: 28, trailing: 20))
        .background(RoundedRectangle(cornerRadius: 10).fill(BKColor.white.swiftUIColor))
    }
}



#Preview {
    SettingView()
}
