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
    var selectedDateArticle: [CalendarFeed] = []
    var filteredArticle: [CalendarFeed] = []
    
    init(
      categorySelectedIndex: Int = 0,
      folderList: [Int: FolderInfo] = [0: FolderInfo()],
      article: [CalendarFeed] = []
    ) {
      self.categorySelectedIndex = categorySelectedIndex
      self.folderList = folderList
      self.selectedDateArticle = article
      self.filteredArticle = self.selectedDateArticle
    }
  }
  
  public enum Action {
    //MARK: Business Action
    case filteringFolder
    case allFolderCountUp
    case changedFeedCardFolder(CalendarFeed, Folder)
    case deleteFeedCard(Int)
    case deleteSelectedFeedCard(Int)
    case deleteFilteredFeedCard(Int)
    case categoryStateModified(Int)
    case feedCardUpdate(Feed)
    case allOfSelectedDateFeedCardUpdate(Feed)
    case filteredFeedCardUpdate(Feed)
    
    //MARK: User Action
    case changeCategorySelectedIndex(targetIndex: Int)
    case cardItemSaveButtonTapped(Int, Bool)
    case cardItemMenuButtonTapped(CalendarFeed)
    case cardItemTapped(Int)
    
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
    case willBookmarkFeedCard(Int, Bool)
    case feedCardTapped(Int)
    case willChangeFolderOfParent(CalendarFeed)
    case willRemoveFeedOfParent(Int)
    case reloadSelectedDateFeedCard
  }
  
  public var body: some ReducerOf<Self> {
    Reduce {
      state,
      action in
      switch action {
        //MARK: Business Action
      case .filteringFolder:
        for element in state.selectedDateArticle {
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
        let contentsCount = state.selectedDateArticle.count
        state.folderList[0]?.feedCount = contentsCount
        return .none
        
      case let .changeCategorySelectedIndex(folderId):
        guard state.folderList[folderId] != nil else { return .none }
        
        state.categorySelectedIndex = folderId
        if folderId == 0 {
          state.filteredArticle = state.selectedDateArticle
        } else {
          state.filteredArticle = state.selectedDateArticle.filter({ $0.folderID == folderId})
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
        
        guard let indexOfAll = state.selectedDateArticle.firstIndex(of: selectedFeed),
              let indexOfDisplay = state.filteredArticle.firstIndex(of: selectedFeed) else { return .none } //FIXME: 에러 대응 수정 필요
        
        state.selectedDateArticle[indexOfAll].folderID = folder.id
        state.selectedDateArticle[indexOfAll].folderName = folder.name
        state.filteredArticle[indexOfDisplay].folderID = folder.id
        state.filteredArticle[indexOfDisplay].folderName = folder.name
        
        return .run { [feed = state.selectedDateArticle[indexOfAll]] send in
          await send(.changeCategorySelectedIndex(targetIndex: folder.id))
          await send(.delegate(.willChangeFolderOfParent(feed)))
        }
        
      case let .deleteFeedCard(targetFeedID):
        return .run { send in
          await send(.categoryStateModified(targetFeedID))
          await send(.deleteSelectedFeedCard(targetFeedID))
          await send(.deleteFilteredFeedCard(targetFeedID))
          await send(.delegate(.willRemoveFeedOfParent(targetFeedID)))
        }
  

        
      case let .categoryStateModified(targetFeedID):
        guard let indexOfCurrentFeedCard = state.filteredArticle.firstIndex(where: { $0.feedID == targetFeedID }) else { return .none }
        let folderID = state.filteredArticle[indexOfCurrentFeedCard].folderID
        
        var needChangeFolder = false
        
        if state.folderList[folderID]?.feedCount == 1 {
          state.folderList.removeValue(forKey: state.filteredArticle[indexOfCurrentFeedCard].folderID)
          needChangeFolder = true
        } else {
          state.folderList[state.filteredArticle[indexOfCurrentFeedCard].folderID]?.feedCount -= 1
        }
        
        guard let totalFolder = state.folderList[0], totalFolder.feedCount > 1 else { return .send(.delegate(.reloadSelectedDateFeedCard)) }
        
        return needChangeFolder ? .send(.changeCategorySelectedIndex(targetIndex: 0)) : .none
        
      case let .deleteSelectedFeedCard(targetFeedID):
        if let indexOfAll = state.selectedDateArticle.firstIndex(where: { $0.feedID == targetFeedID }) {
          state.selectedDateArticle.remove(at: indexOfAll)
        }
        
        return .none
        
      case let .deleteFilteredFeedCard(targetFeedID):
        if let indexOfDisplay = state.filteredArticle.firstIndex(where: { $0.feedID == targetFeedID }) {
          state.filteredArticle.remove(at: indexOfDisplay)
        }
        
        return .none
        
      case let .feedCardUpdate(modifiedFeed):
        return .run { send in
          await send(.filteredFeedCardUpdate(modifiedFeed))
          await send(.allOfSelectedDateFeedCardUpdate(modifiedFeed))
          await send(.filteringFolder)
        }
        
      case let .filteredFeedCardUpdate(modifiedFeed):
        guard let targetFeedIndex = state.filteredArticle.firstIndex(where: { $0.feedID == modifiedFeed.feedId }) else { return .none }
        let originData = state.filteredArticle[targetFeedIndex]
        
        state.filteredArticle[targetFeedIndex] = CalendarFeed(
          folderID: originData.folderID,
          folderName: modifiedFeed.folderName,
          feedID: modifiedFeed.feedId,
          title: modifiedFeed.title,
          summary: modifiedFeed.summary,
          platform: originData.platform,
          platformImage: modifiedFeed.thumbnailImage,
          isMarked: modifiedFeed.isMarked,
          keywords: modifiedFeed.keywords
        )
        
        return .none
        
      case let .allOfSelectedDateFeedCardUpdate(modifiedFeed):
        guard let targetFeedIndex = state.selectedDateArticle.firstIndex(where: { $0.feedID == modifiedFeed.feedId }) else { return .none }
        let originData = state.selectedDateArticle[targetFeedIndex]
        
        state.selectedDateArticle[targetFeedIndex] = CalendarFeed(
          folderID: originData.folderID,
          folderName: modifiedFeed.folderName,
          feedID: modifiedFeed.feedId,
          title: modifiedFeed.title,
          summary: modifiedFeed.summary,
          platform: originData.platform,
          platformImage: modifiedFeed.thumbnailImage,
          isMarked: modifiedFeed.isMarked,
          keywords: modifiedFeed.keywords
        )
        
        return .none
        
        //MARK: User Action
      case let .cardItemSaveButtonTapped(feedID, isMarked):
        guard let indexOfAllArticle = state.selectedDateArticle.firstIndex(where: { $0.feedID == feedID }),
              let indexOfDisplayArticle = state.filteredArticle.firstIndex(where: { $0.feedID == feedID }) else { return .none }
        
        state.selectedDateArticle[indexOfAllArticle].isMarked = isMarked
        state.filteredArticle[indexOfDisplayArticle].isMarked = isMarked
        
        return .send(.patchBookmark(feedID, isMarked))
          .throttle(id: ThrottleId.saveButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case let.cardItemMenuButtonTapped(selectedFeed):
        return .send(.delegate(.shouldPresentsBottomSheet(selectedFeed)))
        
      case let .cardItemTapped(feedID):
        return .send(.delegate(.feedCardTapped(feedID)))
        
        //MARK: Inner Business Logic - Network
      case let .patchBookmark(feedId, isMarked):
        return .run(
          operation: { send in
            let feedBookmark = try await feedClient.patchBookmark(feedId, isMarked)
            
            print(feedBookmark)
            await send(.delegate(.willBookmarkFeedCard(feedId, isMarked)))
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

