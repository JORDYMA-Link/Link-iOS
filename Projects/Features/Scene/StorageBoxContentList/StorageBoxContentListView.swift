//
//  StorageBoxContentListView.swift
//  Blink
//
//  Created by 김규철 on 5/5/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models

import ComposableArchitecture
import SwiftUIIntrospect

struct StorageBoxContentListView: View {
  @Bindable var store: StoreOf<StorageBoxContentListFeature>
  
  @StateObject var scrollViewDelegate = StorageBoxContentListScrollViewDelegate()
  @State private var isScroll = false
  
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        makeNavigationView()
        
        ZStack {
          Color.bkColor(.white)
          
          makeCalendarBanner()
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16))
        }
        .frame(height: 78)
        
        Divider()
          .foregroundStyle(Color.bkColor(.gray400))
        
        ScrollView(showsIndicators: false) {
          LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
            Section {
              ForEach(LinkCard.mock(), id: \.id) { item in
                BKCardCell(width: geometry.size.width - 32, sourceTitle: item.sourceTitle, sourceImage: CommonFeature.Images.graphicBell, saveAction: {}, menuAction: {}, title: item.title, description: item.description, keyword: item.keyword)
                  .padding(.horizontal, 16)
              }
            } header: {
              makeContentListHeaderView(title: store.folderInput.title)
                .padding(EdgeInsets(top: 20, leading: 16, bottom: isScroll ? 4 : -4, trailing: 16))
                .background(Color.bkColor(isScroll ? .white : .gray300))
              
            }
          }
        }
        .padding(.bottom, 20)
        .background(Color.bkColor(.gray300))
        .introspect(.scrollView, on: .iOS(.v17)) { scrollView in
          scrollView.delegate = scrollViewDelegate
        }
      }
    }
    .animation(.spring, value: isScroll)
    .ignoresSafeArea(edges: .bottom)
    .toolbar(.hidden, for: .navigationBar)
    .onReceive(scrollViewDelegate.$isScroll.receive(on: DispatchQueue.main)) {
      isScroll = $0
    }
    .bottomSheet(
      isPresented: $store.sortFolderBottomSheet.isSortFolderBottomSheetPresented,
      detents: [.height(193)],
      leadingTitle: "정렬") {
        SortFolderBottomSheet(store: store.scope(state: \.sortFolderBottomSheet, action: \.sortFolderBottomSheet))
          .padding(.horizontal, 16)
      }
  }
}


extension StorageBoxContentListView {
  @ViewBuilder
  private func makeNavigationView() -> some View {
    makeBKNavigationView(leadingType: .tab("보관함"), trailingType: .none)
      .padding(.horizontal, 16)
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
  private func makeContentListHeaderView(title: String) -> some View {
    HStack(spacing: 8) {
      Button {
        
      }
    label: {
      BKIcon(image: CommonFeature.Images.icoChevronLeft, color: .bkColor(.gray900), size: CGSize(width: 24, height: 24))
    }
      
      Text(title)
        .font(.semiBold(size: ._16))
        .foregroundStyle(Color.bkColor(.gray900))
        .lineLimit(1)
      
      Spacer(minLength: 0)
      
      Button {
        store.send(.sortFolderBottomSheet(.sortFolderTapped(store.sortType)))
      } label: {
        makeCategoryView(categoryTitle: store.sortType.rawValue)
      }
    }
  }
  
  @ViewBuilder
  private func makeCategoryView(categoryTitle: String) -> some View {
    HStack(spacing: 0) {
      Text(categoryTitle)
        .font(.regular(size: ._13))
        .foregroundStyle(Color.bkColor(.gray700))
      BKIcon(image: CommonFeature.Images.icoChevronDown, color: .bkColor(.gray700), size: CGSize(width: 16, height: 16))
    }
  }
}

extension StorageBoxContentListView {
  @MainActor
  final class StorageBoxContentListScrollViewDelegate: NSObject, UIScrollViewDelegate, ObservableObject {
    @Published var isScroll = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      DispatchQueue.main.async {
        self.isScroll = scrollView.contentOffset.y > 0
      }
    }
  }
}

