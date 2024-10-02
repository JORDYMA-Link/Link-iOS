//
//  CalendarArticleFeature.swift
//  Features
//
//  Created by 문정호 on 7/15/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

@Reducer
public struct CalendarArticleFeature {
  @ObservableState
  public struct State: Equatable {
    var categorySelectedIndex: Int = 0
    var folderList: [Int: FolderInfo] = [0: FolderInfo()]
    var allArticle: [CalendarFeed] = []
    var displayArticle: [CalendarFeed] = []
    
    init(
      categorySelectedIndex: Int = 0,
      folerList: [Int: FolderInfo] = [0: FolderInfo()],
      article: [CalendarFeed] = []
    ) {
      self.categorySelectedIndex = categorySelectedIndex
      self.folderList = folerList
      self.allArticle = article
      self.displayArticle = self.allArticle
    }
  }
  
  public enum Action {
    //MARK: Business Action
    case filteringFolder
    case allFolderCountUp
    case changedFeedCardFolder(CalendarFeed, Folder)
    case deleteFeedCard(Int)
    
    //MARK: User Action
    case changeCategorySelectedIndex(targetIndex: Int)
    case tappedCardItemSaveButton(Int, Bool)
    case tappedCardItemMenuButton(CalendarFeed)
    case tappedCardItem(Int)
    
    //MARK: Inner Business Logic
    case patchBookmark(Int, Bool)
    
    //MARK: Delegate
    case delegate(CalendarArticleFeature.Delegate)
  }
  
  struct FolderInfo: Hashable {
    let folderName: String
    var feedCount = 0
    
    init(
      folderName: String = "전체",
      feedCount: Int = 0
    ) {
      self.folderName = folderName
      self.feedCount = feedCount
    }
  }
  
  //MARK: - Dependency
  @Dependency(\.feedClient) private var feedClient
  
  //MARK: - ThrottleId
  private enum ThrottleId {
    case categoryButton
    case saveButton
  }
  
  public enum Delegate {
    case shouldPresentsBottomSheet(CalendarFeed)
    case tappedFeedCard(Int)
    case changeFolderOfParent(CalendarFeed)
    case removeFeedOfParent(Int)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce {
      state,
      action in
      switch action {
        //MARK: Business Action
      case .filteringFolder:
        for element in state.allArticle {
          if let _ = state.folderList[element.folderID] {
            state.folderList[element.folderID]?.feedCount += 1
          } else {
            state.folderList[element.folderID] = FolderInfo(folderName: element.folderName, feedCount: 1)
          }
        }
        
        return .run { send in
          await send(.allFolderCountUp)
        }
        
      case .allFolderCountUp:
        let contentsCount = state.allArticle.count
        state.folderList[0]?.feedCount = contentsCount
        return .none
        
      case let .changeCategorySelectedIndex(folderId):
        guard state.folderList[folderId] != nil else { return .none }
        
        state.categorySelectedIndex = folderId
        if folderId == 0 {
          state.displayArticle = state.allArticle
        } else {
          state.displayArticle = state.allArticle.filter({ $0.folderID == folderId})
        }
        return .none
        
      case let .changedFeedCardFolder(selectedFeed, folder):
        let previousFolderID = selectedFeed.folderID
        
        state.folderList[previousFolderID]?.feedCount -= 1
        
        if state.folderList[previousFolderID]?.feedCount == 0 {
          state.folderList.removeValue(forKey: previousFolderID)
        }
        
        if let _ = state.folderList[folder.id] {
          state.folderList[folder.id]?.feedCount += 1
        } else {
          state.folderList[folder.id] = FolderInfo(folderName: folder.name, feedCount: 1)
        }
        
        guard let indexOfAll = state.allArticle.firstIndex(of: selectedFeed),
              let indexOfDisplay = state.displayArticle.firstIndex(of: selectedFeed) else { return .none } //FIXME: 에러 대응 수정 필요
        
        state.allArticle[indexOfAll].folderID = folder.id
        state.allArticle[indexOfAll].folderName = folder.name
        state.displayArticle[indexOfDisplay].folderID = folder.id
        state.displayArticle[indexOfDisplay].folderName = folder.name
        
        return .run { [feed = state.allArticle[indexOfAll]] send in
          await send(.changeCategorySelectedIndex(targetIndex: folder.id))
          await send(.delegate(.changeFolderOfParent(feed)))
        }
        
      case let .deleteFeedCard(feedID):
        guard let indexOfAll = state.allArticle.firstIndex(where: { feed in
          return feed.feedID == feedID
        }),
              let indexOfDisplay = state.displayArticle.firstIndex(where: { feed in
                return feed.feedID == feedID
              }) else { return .none }
        
        var needChangeFolder = false
        if state.folderList[state.displayArticle[indexOfDisplay].folderID]?.feedCount == 1 {
          state.folderList.removeValue(forKey: state.displayArticle[indexOfDisplay].folderID)
          needChangeFolder = true
        } else {
          state.folderList[state.displayArticle[indexOfDisplay].folderID]?.feedCount -= 1
        }
        
        state.allArticle.remove(at: indexOfAll)
        state.displayArticle.remove(at: indexOfDisplay)
        
        guard needChangeFolder else { return .none }
        return .send(.changeCategorySelectedIndex(targetIndex: 0))
        
        
        //MARK: User Action
      case let .tappedCardItemSaveButton(feedID, isMarked):
        guard let indexOfAllArticle = state.allArticle.firstIndex(where: { $0.feedID == feedID }),
              let indexOfDisplayArticle = state.displayArticle.firstIndex(where: { $0.feedID == feedID }) else { return .none }
        
        state.allArticle[indexOfAllArticle].isMarked = isMarked
        state.displayArticle[indexOfDisplayArticle].isMarked = isMarked
        
        return .send(.patchBookmark(feedID, isMarked))
          .throttle(id: ThrottleId.saveButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case let.tappedCardItemMenuButton(selectedFeed):
        return .send(.delegate(.shouldPresentsBottomSheet(selectedFeed)))
        
      case let .tappedCardItem(feedID):
        return .send(.delegate(.tappedFeedCard(feedID)))
        
        //MARK: Inner Business Logic - Network
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
        
      default:
        return .none
      }
    }
  }
}


