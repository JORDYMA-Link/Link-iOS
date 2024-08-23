//
//  HomeView.swift
//  Features
//
//  Created by 김규철 on 2024/04/01.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models

import ComposableArchitecture
import SwiftUIIntrospect

public struct HomeView: View {
  @Perception.Bindable var store: StoreOf<HomeFeature>
  @StateObject private var scrollViewDelegate = ScrollViewDelegate()
  @State private var isScrollDetected: Bool = false
  
  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        makeNavigationView()
        
        ScrollView(showsIndicators: false) {
          VStack(spacing: 0) {
            VStack(spacing: 12) {
              makeUseBlinkBanner()
              makeSearchBarBanner()
            }
            .padding(.init(top: 8, leading: 16, bottom: 24, trailing: 16))
            
            Divider()
              .foregroundStyle(Color.bkColor(.gray400))
            
            makeArticleListView()
            
          }
        }
        .introspect(.scrollView, on: .iOS(.v16, .v17)) { scrollView in
          scrollView.delegate = scrollViewDelegate
        }
      }
      .padding(.bottom, 52)
      .background(Color.bkColor(.white))
      .animation(.easeIn(duration: 0.2), value: isScrollDetected)
      .onAppear {
        store.send(.onAppear)
        UIScrollView.appearance().bounces = true
      }
      .onReceive(scrollViewDelegate.$isScrollDetected.receive(on: DispatchQueue.main)) {
        self.isScrollDetected = $0
      }
      .navigationDestination(
        item: $store.scope(
          state: \.settingContent,
          action: \.settingContent
        )
      ) { store in
        SettingView(store: store)
      }
      .navigationDestination(
        item: $store.scope(
          state: \.searchKeyword,
          action: \.searchKeyword
        )
      ) { store in
        SearchKeywordView(store: store)
      }
      .navigationDestination(
        item: $store.scope(
          state: \.link,
          action: \.link
        )
      ) { store in
        LinkView(store: store)
      }
      .navigationDestination(
        item: $store.scope(
          state: \.calendarContent,
          action: \.calendarContent
        )
      ) { store in
        CalendarView(store: store)
      }
      .fullScreenCover(
        item: $store.scope(
          state: \.editLink,
          action: \.editLink)
      ) { store in
        EditLinkView(store: store)
      }
    }
  }
}

extension HomeView {
  @ViewBuilder
  private func makeNavigationView() -> some View {
    makeBKNavigationView(leadingType: .home, trailingType: .oneIcon(action: {
      store.send(.settingTapped)
    }, icon: CommonFeature.Images.icoSettings), tintColor: .bkColor(.gray900))
    .padding(.horizontal, 16)
  }
  
  @ViewBuilder
  private func makeUseBlinkBanner() -> some View {
    HStack(spacing: 0) {
      ZStack {
        Circle()
          .fill(Color.bkColor(.white))
          .frame(width: 50, height: 50)
        
        CommonFeature.Images.graphicLogo
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 32, height: 32)
      }
      
      VStack(alignment: .leading, spacing: 2) {
        Text("알면 알수록 똑똑한 앱, 블링크")
          .lineLimit(1)
          .font(.regular(size: ._12))
          .foregroundStyle(Color.bkColor(.gray800))
        
        Text("100% 활용하는 방법 확인하기")
          .lineLimit(1)
          .font(.semiBold(size: ._14))
          .foregroundStyle(Color.bkColor(.main300))
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 8)
      .padding(.trailing, 12)
      
      CommonFeature.Images.icoChevronRight
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 20, height: 20)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(Color.bkColor(.gray300))
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
  
  @ViewBuilder
  private func makeSearchBarBanner() -> some View {
    ZStack {
      Color.bkColor(.gray300)
      
      HStack(spacing: 16) {
        HStack(spacing: 6) {
          CommonFeature.Images.icoSearch
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
          
          Text("날짜별로 콘텐츠를 찾아드립니다")
            .lineLimit(1)
            .font(.regular(size: ._14))
            .foregroundStyle(Color.bkColor(.gray800))
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Rectangle()
            .fill(Color.bkColor(.gray500))
            .frame(width: 1)
            .padding(.leading, 6)
        }
        .onTapGesture {
          store.send(.calendarSearchTapped)
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
  private func makeArticleListView() -> some View {
    LazyVStack(spacing: 4, pinnedViews: [.sectionHeaders]) {
      Section {
        ForEach(LinkCard.mock(), id: \.id) { item in
          WithPerceptionTracking {
            BKCardCell(
              width: 0,
              sourceTitle:
                item.sourceTitle,
              sourceImage: CommonFeature.Images.graphicBell,
              isMarked: true,
              saveAction: {},
              menuAction: { store.send(.cellMenuButtonTapped(item)) },
              title: item.title,
              description: item.description,
              keyword: item.keyword,
              isUncategorized: true,
              recommendedFolders: ["추천폴더1", "추천폴더2", "추천폴더3"],
              recommendedFolderAction: {},
              addFolderAction: {}
            )
            .padding(.init(top: 0, leading: 16, bottom: 16, trailing: 16))
            .onTapGesture {
              store.send(.cellTapped)
            }
          }
        }
      } header: {
        VStack(spacing: 0) {
          CategoryHeaderView(store: store)
            .background(ViewMaxYGeometry())
            .onPreferenceChange(ViewPreferenceKey.self) { maxY in
              // 섹션 헤더의 최대 Y 위치 업데이트
              let navigationBarMaxY = (UIApplication.topSafeAreaInset - 20)
              let headerMaxY = maxY + navigationBarMaxY
              
              DispatchQueue.main.async {
                scrollViewDelegate.headerMaxY = headerMaxY
              }
            }
            .background(isScrollDetected ? Color.white : Color.bkColor(.gray300))
          
          Divider()
            .foregroundStyle(Color.bkColor(.gray400))
            .opacity(isScrollDetected ? 1 : 0)
        }
      }
    }
    .padding(.top, 8)
    .background(Color.bkColor(.gray300))
  }
}

private struct CategoryHeaderView: View {
  @Perception.Bindable var store: StoreOf<HomeFeature>
  
  var body: some View {
    WithPerceptionTracking {
      HStack(spacing: 8) {
        ForEach(CategoryType.allCases, id: \.self) { type in
          BKCategoryButton(
            title: type.rawValue,
            isSelected: store.category == type,
            action: { store.send(.categoryButtonTapped(type), animation: .spring) }
          )
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 8)
      .padding(.leading, 16)
      .padding(.bottom, 12)
    }
  }
}

@MainActor
final class ScrollViewDelegate: NSObject, UIScrollViewDelegate, ObservableObject {
  @Published var headerMaxY: CGFloat = .zero
  @Published var isScrollDetected: Bool = false
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    DispatchQueue.main.async {
      self.isScrollDetected = scrollView.contentOffset.y >  self.headerMaxY
    }
  }
}
