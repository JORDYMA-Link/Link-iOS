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

import ComposableArchitecture

public struct SettingView: View {
  @Environment(\.dismiss) private var dismiss
  
  @Perception.Bindable var store: StoreOf<SettingFeature>
  
  public var body: some View {
    WithPerceptionTracking {
      makeBKNavigationView(
        leadingType: .dismiss("설정", { store.send(.tappedNaviBackButton) }),
        trailingType: .none
      )
      
      ScrollView {
        ZStack {
          settingView
          
          Spacer()
            .navigationBarBackButtonHidden(true)
        }
      }
      .bottomSheet(isPresented: $store.showEditNicknameSheet, detents: .init(arrayLiteral: .height(200)), leadingTitle: "닉네임 변경하기") {
        VStack(alignment: .center) {
          VStack(alignment: .leading) {
            TextField(text: $store.targetNickname) {
              Text("변경할 닉네임을 입력해주세요.")
                .font(.regular(size: ._14))
                .foregroundStyle(Color.bkColor(.gray800))
            }
            .frame(height: 46)
            .padding(.leading, 10)
            .background(Color.bkColor(store.targetNicknameValidation ? .gray300 : .white))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(Color.bkColor(.red), lineWidth: 1)
                .opacity(store.targetNicknameValidation ? 0 : 1)
            )
            
            HStack(alignment: .center) {
              if !store.targetNicknameValidation {
                Text(store.validationNoticeMessage)
                  .foregroundStyle(Color.bkColor(.red))
                  .font(.regular(size: ._12))
              }
              
              Spacer()
              
              Text("\(store.targetNickname.count)/10")
                .font(.regular(size: ._13))
                .foregroundStyle(Color.bkColor(.gray600))
            }
            
          }
          .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
          
          Spacer()
          
          Button(action: {
            store.send(.tappedCompletedEditingNickname)
          }, label: {
            Text("완료")
              .foregroundStyle(Color.bkColor(.white))
          })
          .frame(maxWidth: .infinity, maxHeight: 52)
          .background(Color.bkColor(.main300))
        }
      }
      .navigationDestination(item: $store.scope(
        state: \.noticeContent,
        action: \.noticeContent
      ), destination: { store in
        NoticeView(store: store)
      })
      .signoutAlert(isPresented: $store.showWithdrawModal, buttonAction:  { store.send(.signoutButtonTapped) })
      .onAppear(perform: {
        store.send(.requestSettingInfo)
      })
    }
  }
}

extension SettingView {
  @ViewBuilder
  private var settingView: some View {
    WithPerceptionTracking{
      VStack(alignment: .leading) {
        HStack {
          HStack {
            Text(store.nickname)
              .font(.semiBold(size: ._18))
              .padding(.trailing, -10)
            Text("님")
              .font(.regular(size: ._18))
          }
          Spacer()
          Button(action: {
            store.send(.tappedNicknameEdit)
          }, label: {
            BKIcon(image: CommonFeature.Images.icoEdit, color: Color.bkColor(.gray900), size: CGSize(width: 18, height: 18))
          })
        }
        .padding(EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16))
        
        Color.bkColor(.gray400)
          .frame(height: 8)
        
        VStack(alignment: .leading, content: {
          Text("공지")
            .font(.regular(size: ._12))
            .foregroundStyle(Color.bkColor(.gray700))
          Button(action: {
            store.send(.tappedNotice)
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
          
          
          Link(destination: SettingFeature.PolicyType.privacy.url!) {
            Text("개인정보 처리 방침")
              .font(.regular(size: ._15))
          }
          .tint(.bkColor(.gray900))
          .padding(.top, 16)
          
          Link(destination: SettingFeature.PolicyType.termOfUse.url!) {
            Text("서비스 이용약관")
              .font(.regular(size: ._15))
          }
          .tint(.bkColor(.gray900))
          .padding(.top, 32)
          
          Button(action: {}, label: {
            HStack {
              Text("버전 정보")
                .font(.regular(size: ._15))
              Spacer()
              Text("최신 \(store.currentAppVersion)")
                .font(.regular(size: ._12))
                .foregroundStyle(Color.bkColor(.gray700))
              Text("현재 \(store.currentAppVersion)")
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
        
        VStack(alignment: .leading) {
          Text("도움말")
            .font(.regular(size: ._12))
            .foregroundStyle(Color.bkColor(.gray700))
          
          Link(destination: SettingFeature.PolicyType.introduceService.url!) {
            Text("서비스 이용방법")
          }
          .font(.regular(size: ._15))
          .tint(.bkColor(.gray900))
          .padding(.top, 16)
          
          Button(action: {
            store.send(.tappedLogOut)
          }, label: {
            Text("로그아웃")
              .font(.regular(size: ._15))
          })
          .tint(.bkColor(.gray900))
          .padding(.top, 32)
          
          Button(action: {
            store.send(.tappedWithdrawCell)
          }, label: {
            Text("회원탈퇴")
              .font(.regular(size: ._12))
              .underline()
          })
          .tint(.bkColor(.gray700))
          .padding(.top, 32)
        }
        .padding(EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16))
      }
    }
  }
  
  @ViewBuilder
  private var withdrawModal: some View {
    ZStack {
      Color(.black.withAlphaComponent(0.6)).ignoresSafeArea()
      
      GeometryReader { geometry in
        VStack {
          modalView
            .frame(width: geometry.size.width - 24) // 너비에서 24만큼 줄임
        }
        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center) // 전체 화면
      }
    }
  }
  
  //MARK: - modalView
  @ViewBuilder
  public var modalView: some View {
    WithPerceptionTracking{
      VStack {
        HStack {
          Spacer()
          
          Button {
            store.send(.changeConfirmWithdrawModal)
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
        
        Button {
          store.send(.confirmedWithdrawWarning)
        } label: {
          HStack {
            if store.isConfirmedWithdrawWarning {
              Image(systemName: "square" )
                .foregroundStyle(Color.bkColor(.gray700))
            } else {
              CommonFeature.Images.icoCheckBox
            }
            
            Text("안내사항을 확인하였으며, 이에 동의합니다")
              .font(.regular(size: ._13))
              .foregroundStyle(Color.bkColor(.gray900))
          }
          
        }
        
        Button {
          
        } label: {
          Text(BKModalType.withdrawNotice.okText)
            .foregroundStyle(store.isConfirmedWithdrawWarning ? BKColor.gray600.swiftUIColor : BKColor.white.swiftUIColor)
            .frame(maxWidth: 140, maxHeight: 48)
        }
        .disabled(store.isConfirmedWithdrawWarning)
        .frame(maxWidth: .infinity, maxHeight: 48)
        .background(store.isConfirmedWithdrawWarning ? BKColor.gray400.swiftUIColor : BKColor.gray900.swiftUIColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .padding(EdgeInsets(top: 28, leading: 20, bottom: 28, trailing: 20))
      .ignoresSafeArea()
      .background(RoundedRectangle(cornerRadius: 10).fill(BKColor.white.swiftUIColor))
    }
    
  }
}

fileprivate struct SignoutAlert: View {
  @State private var isAnimating = false
  @State private var opacity = 0.6
  @State private var isCheck: Bool = false
  @Binding private var isPresented: Bool
  private let buttonAction: () -> Void
  
  init(
    isPresented: Binding<Bool>,
    buttonAction: @escaping () -> Void
  ) {
    self._isPresented = isPresented
    self.buttonAction = buttonAction
  }
  
  func show() {
    withAnimation(.easeInOut(duration: 0.3)) {
      isAnimating = true
    }
  }
  
  func dismiss() {
    withAnimation(.easeInOut(duration: 0.3)) {
      opacity = 0
      isAnimating = false
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      isPresented = false
    }
  }
  
  var body: some View {
    ZStack {
      Color.black
        .ignoresSafeArea()
        .opacity(opacity)
        .zIndex(0)
      
      if isAnimating {
        VStack(alignment: .center, spacing: 0) {
          dismissButton
          
          content
          
          checkContent
          
          BKRoundedButton(
            buttonType: .black,
            title: "탈퇴하기",
            isDisabled: !isCheck,
            isCornerRadius: true,
            confirmAction: {
              dismiss()
              
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                buttonAction()
              }
            }
          )
        }
        .padding(EdgeInsets(top: 28, leading: 20, bottom: 28, trailing: 20))
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 24)
        .animation(.default, value: isCheck)
      }
    }
    .onAppear {
      show()
    }
  }
  
  @ViewBuilder
  var dismissButton: some View {
    HStack {
      Spacer()
      
      BKIcon(
        image: CommonFeature.Images.icoClose,
        color: .bkColor(.gray900),
        size: .init(width: 18, height: 18)
      )
      .onTapGesture { dismiss() }
    }
  }
  
  @ViewBuilder
  var content: some View {
    VStack(spacing: 8) {
      BKText(
        text: "유의사항",
        font: .semiBold,
        size: ._16,
        lineHeight: 24,
        color: .bkColor(.gray900)
      )
      .frame(maxWidth: .infinity, alignment: .center)
      
      BKText(
        text: """
              탈퇴시 블링크에 저장한 콘텐츠 / 저장된 링크 / 폴더와 추천 키워드 / 계정 정보가 모두 삭제됩니다
              
              탈퇴 후 재가입의 경우에도 해당 데이터는 복원되지 않습니다
              """,
        font: .regular,
        size: ._13,
        lineHeight: 18,
        color: .bkColor(.gray700)
      )
      .frame(maxWidth: .infinity, alignment: .leading)
      .multilineTextAlignment(.leading)
    }
  }
  
  @ViewBuilder
  var checkContent: some View {
    HStack(spacing: 8) {
      checkBox
      
      BKText(
        text: "안내사항을 확인하였으며, 이에 동의합니다",
        font: .regular,
        size: ._13,
        lineHeight: 18,
        color: .bkColor(.gray900)
      )
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.vertical, 16)
  }
  
  @ViewBuilder
  var checkBox: some View {
    Group {
      if isCheck {
        CommonFeature.Images.icoCheckBox
          .resizable()
          .frame(width: 18, height: 18)
      } else {
        Rectangle()
          .fill(.white)
          .frame(width: 18, height: 18)
          .clipShape(RoundedRectangle(cornerRadius: 2))
          .overlay {
            RoundedRectangle(cornerRadius: 2)
              .inset(by: 1)
              .stroke(Color.bkColor(.gray700), lineWidth: 1)
          }
      }
    }
    .onTapGesture {  isCheck.toggle() }
  }
}

private extension View {
  func signoutAlert(
    isPresented: Binding<Bool>,
    buttonAction: @escaping () -> Void
  ) -> some View {
    return fullScreenCover(isPresented: isPresented) {
      SignoutAlert(isPresented: isPresented, buttonAction: buttonAction)
        .presentationClearBackground()
    }
    .transaction { transaction in
      if isPresented.wrappedValue {
        transaction.disablesAnimations = true
        transaction.animation = .linear(duration: 0.1)
      }
    }
  }
}
