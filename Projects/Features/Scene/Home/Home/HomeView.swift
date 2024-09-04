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
  /// 카테고리 헤더 스크롤 유무
  @State private var isScrollDetected: Bool = false
  /// 홈 상단 배너 Height
  @State private var bannerHeight: CGFloat = 0
  /// 카테고리 헤더 Height
  @State private var categoryHeaderHeight: CGFloat = 0
  /// 카테고리 버튼 선택 시 top Scroll ID
  @Namespace private var topID
  
  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        HomeNavigationView(store: store)
        
        GeometryReader { proxy in
          ScrollViewReader { scrollProxy in
            ScrollView(showsIndicators: false) {
              VStack(spacing: 0) {
                HomeBanner(store: store)
                  .background(ViewHeightGeometry())
                  .onPreferenceChange(ViewPreferenceKey.self) { height in
                    DispatchQueue.main.async {
                      self.bannerHeight = height
                    }
                  }
                  .id(topID)
                
                Divider()
                  .foregroundStyle(Color.bkColor(.gray400))
                
                LazyVStack(spacing: 4, pinnedViews: [.sectionHeaders]) {
                  Section {
                    HomeCardSection(
                      store: store,
                      emptyHeight: proxy.size.height - bannerHeight - categoryHeaderHeight - UIApplication.topSafeAreaInset
                    )
                    .padding(.init(top: 0, leading: 16, bottom: 16, trailing: 16))
                  } header: {
                    VStack(spacing: 0) {
                      CategoryHeaderView(
                        store: store,
                        scrollAction: {
                          withAnimation {
                            scrollProxy.scrollTo(topID, anchor: .top)
                          }
                        }
                      )
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
                    .background(ViewHeightGeometry())
                    .onPreferenceChange(HeaderHeightPreferenceKey.self) { height in
                      DispatchQueue.main.async {
                        self.categoryHeaderHeight = height
                      }
                    }
                  }
                }
                .padding(.top, 8)
              }
            }
            .refreshable { store.send(.pullToRefresh) }
            .background(Color.bkColor(.gray300))
            .introspect(.scrollView, on: .iOS(.v16, .v17)) { scrollView in
              scrollView.delegate = scrollViewDelegate
            }
          }
        }
      }
    }
    .padding(.bottom, 52)
    .background(Color.bkColor(.white))
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
      SearchView(store: store)
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
    .navigationDestination(
      item: $store.scope(
        state: \.storageBoxFeedList,
        action: \.storageBoxFeedList
      )
    ) { store in
      StorageBoxContentListView(store: store)
    }
    .fullScreenCover(
      item: $store.scope(
        state: \.editLink,
        action: \.editLink)
    ) { store in
      EditLinkView(store: store)
    }
    .animation(.easeIn(duration: 0.2), value: isScrollDetected)
    .onReceive(scrollViewDelegate.$isScrollDetected.receive(on: DispatchQueue.main)) {
      self.isScrollDetected = $0
    }
    .onAppear {
      store.send(.onAppear)
      UIScrollView.appearance().bounces = true
    }
  }
}

private extension HomeView {
  struct HeaderHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
      value = max(value, nextValue())
    }
  }
}

private struct HomeNavigationView: View {
  @Perception.Bindable private var store: StoreOf<HomeFeature>
  
  init(store: StoreOf<HomeFeature>) {
    self.store = store
  }
  
  var body: some View {
    WithPerceptionTracking {
      makeBKNavigationView(
        leadingType: .home,
        trailingType: .oneIcon(action: { store.send(.settingButtonTapped) },
                               icon: CommonFeature.Images.icoSettings),
        tintColor: .bkColor(.gray900)
      )
      .padding(.horizontal, 16)
    }
  }
}

private struct HomeBanner: View {
  @Perception.Bindable private var store: StoreOf<HomeFeature>
  
  init(store: StoreOf<HomeFeature>) {
    self.store = store
  }
  
  var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 12) {
        BKInstructionBanner()
          .contentShape(Rectangle())
          .onTapGesture { store.send(.instructionBannerTapped) }
        
        BKSearchBanner(
          searchAction: { store.send(.searchBannerSearchBarTapped) },
          calendarAction: { store.send(.searchBannerCalendarTapped) }
        )
      }
      .homeBannerBackgroundView()
    }
  }
}

private struct CategoryHeaderView: View {
  @Perception.Bindable private var store: StoreOf<HomeFeature>
  private let scrollAction: () -> Void
  
  init(
    store: StoreOf<HomeFeature>,
    scrollAction: @escaping () -> Void
  ) {
    self.store = store
    self.scrollAction = scrollAction
  }
  
  var body: some View {
    WithPerceptionTracking {
      HStack(spacing: 8) {
        ForEach(CategoryType.allCases, id: \.self) { type in
          BKCategoryButton(
            title: type.title,
            isSelected: store.category == type,
            action: {
              scrollAction()
              store.send(.categoryButtonTapped(type))
            }
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

private extension View {
  func homeBannerBackgroundView() -> some View {
    ZStack {
      Color.bkColor(.white)
      self
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16))
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
