//
//  BKTabFeature.swift
//  Blink
//
//  Created by kyuchul on 6/6/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct BKTabFeature {
  public init() {}
  
  @Reducer(state: .equatable)
  public enum Path {
    case SaveLink(SaveLinkFeature)
    case SummaryStatus(SummaryStatusFeature)
    case Link(LinkFeature)
  }
    
  @ObservableState
  public struct State: Equatable {
    var currentItem: BKTabViewType = .home
    var path = StackState<Path.State>()
    var isSaveContentPresented = false
    
    var home: HomeFeature.State = .init()
    var storageBox: StorageBoxFeature.State = .init()
    
    public init() {}
  }
    
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    // MARK: User Action
    case roundedTabIconTapped
    case saveLinkButtonTapped
    case routeSummaryStatusButtonTapped
    
    case path(StackAction<Path.State, Path.Action>)
    case storageBox(StorageBoxFeature.Action)
    case home(HomeFeature.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.storageBox, action: \.storageBox) { StorageBoxFeature() }
    Scope(state: \.home, action: \.home) { HomeFeature() }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .roundedTabIconTapped:
        state.isSaveContentPresented.toggle()
        return .none

      case .saveLinkButtonTapped:
        state.isSaveContentPresented.toggle()
        state.path.append(.SaveLink(SaveLinkFeature.State()))
        return .none
        
      case .routeSummaryStatusButtonTapped:
        state.path.append(.SummaryStatus(SummaryStatusFeature.State()))
        return .none
        
      // 링크요약 리스트 화면 Delegate
      case let .path(.element(id: _, action: .SummaryStatus(.delegate(.summaryStatusItemTapped(feedId))))):
        state.path.append(.Link(LinkFeature.State(linkType: .summaryCompleted(feedId: feedId))))
        return .none
                
      // 요약완료 화면 Delegate
      case let .path(.element(id: _, action: .Link(.delegate(.summaryCompletedSaveButtonTapped(feedId))))):
        state.path.append(.Link(LinkFeature.State(linkType: .summarySave(feedId: feedId))))
        return .none
                
      case .path(.element(id: _, action: .Link(.delegate(.summaryCompletedCloseButtonTapped)))):
        state.path.removeAll()
        /// 모달 띄우기
        return .none
        
      // 요약완료 -> 요약완료 확인화면 Delegate
      case .path(.element(id: _, action: .Link(.delegate(.summarySaveCloseButtonTapped)))):
        state.path.removeAll()
        /// homeView 리로드
        return .none
        
      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}
