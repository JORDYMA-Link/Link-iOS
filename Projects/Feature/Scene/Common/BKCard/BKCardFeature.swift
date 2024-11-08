//
//  BKCardFeature.swift
//  Feature
//
//  Created by kyuchul on 10/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import CommonFeature
import Common
import Services
import Models

import ComposableArchitecture

@Reducer
public struct BKCardFeature {
  @ObservableState
  public struct State: Equatable {
    var category: CategoryType = .bookmarked
    
    var feedList: [FeedCard] = []
    
    var page: Int
    var fetchedAllFeedCards: Bool = false
    
    public init(feedList: [FeedCard]) {
      page = 0
      self.feedList = feedList
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case pagination
    case cardItemTapped(Int)
    case cardItemSaveButtonTapped(Int, Bool)
    case cardItemMenuButtonTapped(FeedCard)
    case cardItemRecommendedFolderTapped(Int, String)
    case cardItemAddFolderTapped(FeedCard)
    case feedDetailWillDisappear(Feed)
    
    // MARK: Inner Business Action
    case resetPage
    case updatePage
    case fetchFeedList(Int)
    case patchBookmark(Int, Bool)
    
    // MARK: Inner SetState Action
    case setCategory(CategoryType)
    case setAddFeeds([FeedCard])
    case setFetchedAllCardsStatus(Bool)
    case setFeedFolder(Int, Folder)
    case setDeleteFeed(Int)
  }
  
  @Dependency(\.feedClient) private var feedClient
  
  private enum ThrottleId {
    case saveButton
  }
  
  private enum DebounceId {
    case pagination
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .pagination:
        return .send(.updatePage)
          .debounce(id: DebounceId.pagination, for: .seconds(0.3), scheduler: DispatchQueue.main)
        
      case let .cardItemSaveButtonTapped(index, isMarked):
        guard var item = state.feedList[safe: index] else { return .none }
        
        item.isMarked = isMarked
        state.feedList[index] = item
        return .send(.patchBookmark(item.feedId, isMarked))
          .throttle(id: ThrottleId.saveButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case let .feedDetailWillDisappear(feed):
        guard let index = state.feedList.firstIndex(where: { $0.feedId == feed.feedId }) else {
          return .none
        }
        
        let feedCard = state.feedList[index]
        let updateFeedCard = feed.toFeedCard(feedCard)
        
        if feedCard != updateFeedCard {
          state.feedList[index] = updateFeedCard
        }
        return .none
        
      case .resetPage:
        state.fetchedAllFeedCards = false
        state.page = 0
        return .send(.fetchFeedList(state.page))
        
      case .updatePage:
        state.page += 1
        return .send(.fetchFeedList(state.page))
        
      case .fetchFeedList:
        return .none
        
      case let .patchBookmark(feedId, isMarked):
        return .run(
          operation: { send in
            let feedBookmark = try await feedClient.patchBookmark(feedId, isMarked)
            
            print(feedBookmark)
          },
          catch: { error, send in
            print(error)
          }
        )
      case let .setCategory(category):
        state.category = category
        return .none
        
      case let .setAddFeeds(feedList):
        if state.page == 0 {
          state.feedList = feedList
        } else {
          state.feedList.append(contentsOf: feedList)
        }
        return .none
        
      case let .setFetchedAllCardsStatus(isPaging):
        state.fetchedAllFeedCards = isPaging
        return .none
        
      case let .setFeedFolder(feedId, folder):
        guard let index = state.feedList.firstIndex(where: { $0.feedId == feedId }) else {
          return .none
        }
        
        state.feedList[index].folderName = folder.name
        state.feedList[index].folderId = folder.id
        return .none
        
      case let .setDeleteFeed(feedId):
        state.feedList.removeAll { $0.feedId == feedId }
        return .none
        
      default:
        return .none
      }
    }
  }
}
