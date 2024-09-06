//
//  SearchFeature.swift
//  Blink
//
//  Created by kyuchul on 6/10/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import Models
import Services

import ComposableArchitecture

@Reducer
public struct SearchFeature {
  @ObservableState
  public struct State: Equatable {
    var query = ""
    var keyword = ""
    
    var page: Int = 0
    
    var feedSection: [SearchFeed] = []
    var recentSearches: [String] = []
    
    @Presents var link: LinkFeature.State?
    
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case onTask
    case closeButtonTapped
    case searchButtonTapped(String)
    case removeAllRecentSearchButtonTapped
    case removeRecentSearchButtonTapped(String)
    case recentSearchItemTapped(String)
    case keywordSearchItemTapped(Int)
    case footerPaginationButtonTapped(Int)
    
    // MARK: Inner Business Action
    case resetPage
    case updatePage
    case fetchSearchFeedSection(query: String, page: Int)
    
    // MARK: Inner SetState Action
    case setSearchFeedSection(SearchFeed)
    case setRecentSearches(String)
    case setRemoveAllRecentSearches
    case setRemoveRecentSearches(String)
    
    // MARK: Child Action
    case link(PresentationAction<LinkFeature.Action>)
    
    // MARK: Navigation Action
    case routeFeedDetail(Int)
  }
  
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.userDefaultsClient) private var userDefault
  @Dependency(\.feedClient) private var feedClient
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .onTask:
        state.recentSearches = userDefault.stringArray(.recentSearches, [])
        return .none
        
      case .closeButtonTapped:
        return .run { _ in await self.dismiss() }
        
      case let .searchButtonTapped(query):
        guard !query.isEmpty else { return .none }
        
        return .run { send in
          await send(.setRecentSearches(query))
          await send(.resetPage)
        }
        
      case .removeAllRecentSearchButtonTapped:
        guard !state.recentSearches.isEmpty else { return .none }
        
        return .send(.setRemoveAllRecentSearches)
        
      case let .removeRecentSearchButtonTapped(keyword):
        return .send(.setRemoveRecentSearches(keyword))
        
      case let .recentSearchItemTapped(keyword):
        state.query = keyword
        
        return .run { send in
          await send(.setRecentSearches(keyword))
          await send(.resetPage)
        }
        
      case let .keywordSearchItemTapped(feedId):
        return .send(.routeFeedDetail(feedId))
        
      case let .footerPaginationButtonTapped(index):
        state.feedSection[index].isPagination = false
        return .send(.updatePage)
        
      case .resetPage:
        state.page = 0
        return .send(.fetchSearchFeedSection(query: state.query, page: state.page))
        
      case .updatePage:
        state.page += 1
        return .send(.fetchSearchFeedSection(query: state.keyword, page: state.page))
        
      case let .fetchSearchFeedSection(query, page):
        return .run(
          operation: { send in
            async let feedSectionResponse = try feedClient.getFeedSearch(query, page)
            
            var feedSection = try await feedSectionResponse
            
            if feedSection.result.count < 10 {
              feedSection.isLast = true
            }
            
            await send(.setSearchFeedSection(feedSection), animation: .default)
          },
          catch: { send, error in
            print(error)
          }
        )
        
      case let .setSearchFeedSection(feedSection):
        state.keyword = feedSection.query
        
        if state.page == 0 && feedSection.result.isEmpty {
          state.feedSection = []
        } else if state.page == 0 {
          state.feedSection = [feedSection]
        } else {
          state.feedSection.append(feedSection)
        }
        return .none
        
      case let .setRecentSearches(query):
        var recentSearches = userDefault.stringArray(.recentSearches, [])
        
        if let index = recentSearches.firstIndex(where: { $0 == query }) {
          recentSearches.remove(at: index)
        }
        
        recentSearches.insert(query, at: 0)
        let prefixRecentSearches = recentSearches.prefix(6).map { $0 }
        userDefault.set(prefixRecentSearches, .recentSearches)
        return .none
        
      case .setRemoveAllRecentSearches:
        let emptyValue: [String] = []
        userDefault.set(emptyValue, .recentSearches)
        
        state.recentSearches = emptyValue
        return .none
        
      case let .setRemoveRecentSearches(keyword):
        var recentSearches = userDefault.stringArray(.recentSearches, [])
        recentSearches.removeAll(where: { $0 == keyword })
        
        userDefault.set(recentSearches, .recentSearches)
        
        state.recentSearches = recentSearches
        return .none
        
      case let .routeFeedDetail(feedId):
        state.link = .init(linkType: .feedDetail(feedId: feedId))
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.$link, action: \.link) {
      LinkFeature()
    }
  }
}
