//
//  StorageBoxView.swift
//  Blink
//
//  Created by kyuchul on 4/27/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models

import ComposableArchitecture
import SwiftUIIntrospect

struct StorageBoxView: View {
  @StateObject var scrollViewDelegate = StorageBoxScrollViewDelegate()
  @Bindable var store: StoreOf<StorageBoxFeature>
  
  @State private var contentText: String = ""
  @State private var pushToContentList = false
  @State private var isHiddenDivider = false
  
  var body: some View {
    VStack(spacing: 0) {
      makeNavigationView()
      ScrollView(showsIndicators: false) {
        VStack(spacing: 0) {
          ZStack {
            Color.bkColor(.white)
            
            makeCalendarBanner()
              .padding(EdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16))
          }
          
          Divider()
            .foregroundStyle(Color.bkColor(.gray400))
          
          LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible())], spacing: 16) {
            makeAddStorageBoxCell()
              .onTapGesture {
                store.send(.addFolderBottomSheet(.addFolderTapped))
              }
            
            ForEach(Folder.makeFolderMock()) { item in
              makeStorageBoxCell(
                count: item.count,
                name: item.title,
                menuAction: {
                  store.send(.menuBottomSheet(.storageBoxMenuTapped(item)))
                }
              )
              .onTapGesture {
                pushToContentList.toggle()
              }
            }
          }
          .padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16))
          .background(Color.bkColor(.gray300))
        }
      }
      .introspect(.scrollView, on: .iOS(.v16, .v17)) { scrollView in
        scrollView.delegate = scrollViewDelegate
      }
    }
    .background(Color.bkColor(.white))
    .toolbar(.hidden, for: .navigationBar)
    .onReceive(scrollViewDelegate.$contentOffset.receive(on: DispatchQueue.main)) { isHidden in
      isHiddenDivider = isHidden
      
    }
    .navigationDestination(isPresented: $pushToContentList) {
      StorageBoxContentListView()
    }
    .bottomSheet(isPresented: $store.addFolderBottomSheet.isAddFolderBottomSheetPresented, detents: [.height(202)], leadingTitle: "폴더 추가", closeButtonAction: { store.send(.addFolderBottomSheet(.closeButtonTapped)) } ) {
      AddFolderBottomSheet(store: store.scope(state: \.addFolderBottomSheet, action: \.addFolderBottomSheet))
        .interactiveDismissDisabled()
    }
    .bottomSheet(isPresented: $store.menuBottomSheet.isMenuBottomSheetPresented, detents: [.height(154)], leadingTitle: "폴더 설정", closeButtonAction: { store.send(.menuBottomSheet(.closeButtonTapped)) } ) {
      StorageBoxMenuBottomSheet(store: store.scope(state: \.menuBottomSheet, action: \.menuBottomSheet))
        .padding(.horizontal, 16)
    }
    .bottomSheet(isPresented: $store.editFolderNameBottomSheet.isEditFolderBottomSheetPresented, detents: [.height(202)], leadingTitle: "폴더 수정", closeButtonAction: { store.send(.editFolderNameBottomSheet(.closeButtonTapped)) }) {
      EditFolderNameBottomSheet(store: store.scope(state: \.editFolderNameBottomSheet, action: \.editFolderNameBottomSheet))
        .interactiveDismissDisabled()
    }
    .fullScreenCover(isPresented: $store.isDeleteFolderPresented) {
      BKModal(modalType: .deleteFolder(checkAction: {
        store.send(.deleteFolderModalConfirmTapped)
      }, cancelAction: {
        store.send(.deleteFolderModalCancelTapped)
      })
      )
    }
  }
}

extension StorageBoxView {
  @ViewBuilder
  private func makeNavigationView() -> some View {
    VStack(spacing: 0) {
      makeBKNavigationView(leadingType: .tab("보관함"), trailingType: .none)
        .padding(.horizontal, 16)
      
      Divider()
        .foregroundStyle(Color.bkColor(.gray400))
        .opacity(isHiddenDivider ? 1 : 0)
    }
  }
  
  @ViewBuilder
  private func makeCalendarBanner() -> some View {
    ZStack {
      Color.bkColor(.gray300)
      
      HStack(spacing: 16) {
        HStack(spacing: 6) {
          CommonFeature.Images.icoSearch
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
          
          Text("콘텐츠를 찾아드립니다")
            .lineLimit(1)
            .font(.regular(size: ._14))
            .foregroundStyle(Color.bkColor(.gray800))
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Rectangle()
            .fill(Color.bkColor(.gray500))
            .frame(width: 1)
            .padding(.leading, 6)
        }
        
        CommonFeature.Images.icoCalendar
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 20, height: 20)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 13)
    }
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
  
  @ViewBuilder
  private func makeAddStorageBoxCell() -> some View {
    ZStack {
      Color(.bkColor(.white))
      
      VStack(alignment: .center, spacing: 4) {
        CommonFeature.Images.icoPlus
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundStyle(Color.bkColor(.gray700))
        
        Text("추가하기")
          .font(.regular(size: ._14))
          .foregroundStyle(Color.bkColor(.gray700))
      }
      .padding(EdgeInsets(top: 16, leading: 14, bottom: 18, trailing: 14))
    }
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .frame(height: 80)
    .shadow(color: .bkColor(.gray900).opacity(0.08), radius: 5, x: 0, y: 4)
  }
  
  @ViewBuilder
  private func makeStorageBoxCell(count: Int, name: String, menuAction: @escaping () -> Void) -> some View {
    ZStack {
      Color(.bkColor(.white))
      
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text("\(count)개")
            .font(.regular(size: ._12))
            .foregroundStyle(Color.bkColor(.gray800))
            .lineLimit(1)
          
          Spacer(minLength: 4)
          
          Button(action: {
            menuAction()
          }, label: {
            CommonFeature.Images.icoMoreVertical
              .resizable()
              .frame(width: 20, height: 20)
              .foregroundStyle(Color.bkColor(.gray600))
          })
        }
        
        Text(name)
          .font(.semiBold(size: ._14))
          .foregroundStyle(Color.bkColor(.gray900))
          .lineLimit(1)
      }
      .padding(EdgeInsets(top: 16, leading: 14, bottom: 18, trailing: 14))
    }
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .frame(height: 80)
    .shadow(color: .bkColor(.gray900).opacity(0.08), radius: 5, x: 0, y: 4)
  }
}

@MainActor
final class StorageBoxScrollViewDelegate: NSObject, UIScrollViewDelegate, ObservableObject {
  @Published var contentOffset = false
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    DispatchQueue.main.async {
      self.contentOffset = scrollView.contentOffset.y > 80
    }
  }
}


