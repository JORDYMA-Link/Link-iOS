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
    var folderList: [FolderInfo] = [FolderInfo()]
    var selectedDateArticle: [FeedCard] = []
    var filteredArticle: [FeedCard] = []
    var existedNotClassifiedFolder: Bool = false
    
    init(
      categorySelectedIndex: Int = 0,
      folderList: [FolderInfo] = [FolderInfo()],
      article: [FeedCard] = [],
      existedNotClassifiedFolder: Bool = false
    ) {
      self.categorySelectedIndex = categorySelectedIndex
      self.folderList = folderList
      self.selectedDateArticle = article
      self.filteredArticle = article
      self.existedNotClassifiedFolder = existedNotClassifiedFolder
    }
  }
  
  public enum Action {
    //MARK: Business Action
    case classifyFolder
    case reClassifyFolder
    case folderOfAllCountUp
    case changedFeedCardFolder(FeedCard, Folder)
    case deleteFeedCard(Int)
    case deleteSelectedFeedCard(Int)
    case deleteFilteredFeedCard(Int)
    case categoryStateModified(Int)
    case feedCardUpdate(FeedCard)
    case allOfSelectedDateFeedCardUpdate(FeedCard)
    case filteredFeedCardUpdate(FeedCard)
    
    //MARK: User Action
    case changeCategorySelectedIndex(targetIndex: Int)
    case cardItemSaveButtonTapped(Int, Bool)
    case cardItemMenuButtonTapped(FeedCard)
    case cardItemTapped(Int)
    
    //MARK: Network
    case patchBookmark(Int, Bool)
    
    //MARK: Delegate
    case delegate(CalendarArticleFeature.Delegate)
  }
  
  struct FolderInfo: Hashable {
    let folderName: String
    var feedCount = 0
    let folderId: Int
    
    init(
      folderName: String = "전체",
      feedCount: Int = 0,
      folderId: Int = 0
    ) {
      self.folderName = folderName
      self.feedCount = feedCount
      self.folderId = folderId
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
    case shouldPresentsBottomSheet(FeedCard)
    case willBookmarkFeedCard(Int, Bool)
    case feedCardTapped(Int)
    case willChangeFolderOfParent(FeedCard)
    case willRemoveFeedOfParent(Int)
    case reloadSelectedDateFeedCard
  }
  
  public var body: some ReducerOf<Self> {
    Reduce {
      state,
      action in
      switch action {
        //MARK: Business Action
      case .classifyFolder:
        var ownedFolder: [FolderInfo] = []
        
        let groupedByFolderId = Dictionary(grouping: state.selectedDateArticle, by: { $0.folderId }) // FolderId 기준으로 그룹핑 (코딩핑)
        
        for (_, feedCards) in groupedByFolderId {
          guard let firstFeed = feedCards.first else { continue }
          
          if firstFeed.folderName == "미분류" { //미분류 폴더가 있다면?
            let unClassifiedFolder = FolderInfo(folderName: firstFeed.folderName, feedCount: feedCards.count, folderId: firstFeed.folderId)
            state.folderList.append(unClassifiedFolder)
            state.existedNotClassifiedFolder = true
          } else {
            ownedFolder.append(FolderInfo(folderName: firstFeed.folderName, feedCount: feedCards.count, folderId: firstFeed.folderId))
          }
        }
        
        ownedFolder.sort { $0.folderId > $1.folderId } // 전체와 미분류를 제외한 나머지 폴더들 FolderId 기준 내림차순
        
        state.folderList += ownedFolder
        
        return .run { send in
          await send(.folderOfAllCountUp)
        }
        
      case .reClassifyFolder:
        state.folderList = [FolderInfo()] //폴더 초기화
        state.existedNotClassifiedFolder = false
        return .send(.classifyFolder)
        
      case .folderOfAllCountUp:
        let contentsCount = state.selectedDateArticle.count
        state.folderList[0].feedCount = contentsCount
        return .none
        
      case let .changeCategorySelectedIndex(folderId):
        state.categorySelectedIndex = folderId
        if folderId == 0 {
          state.filteredArticle = state.selectedDateArticle
        } else {
          state.filteredArticle = state.selectedDateArticle.filter({ $0.folderId == folderId })
        }
        return .none
        
      case let .changedFeedCardFolder(selectedFeed, folder):
        let previousFolderID = selectedFeed.folderId
        
        if let targetIndex = state.folderList.firstIndex(where: { $0.folderId == previousFolderID }) {
          state.folderList[targetIndex].feedCount -= 1
          
          if state.folderList[targetIndex].feedCount == 0 {
            if state.folderList[targetIndex].folderName == "미분류" {
              state.existedNotClassifiedFolder = false
            }
            state.folderList.remove(at: targetIndex)
          }
        }
        
        if let targetIndex = state.folderList.firstIndex(where: { $0.folderId == folder.id }) {
          state.folderList[targetIndex].feedCount += 1
        } else {
          state.folderList.append(FolderInfo(folderName: folder.name, feedCount: 1, folderId: folder.id))
          let orderedStartIndex = state.existedNotClassifiedFolder ? 2 : 1
          if orderedStartIndex < state.folderList.endIndex {
            state.folderList[orderedStartIndex...].sort{ $0.folderId > $1.folderId }
          }
        }
        
        guard let indexOfAll = state.selectedDateArticle.firstIndex(of: selectedFeed),
              let indexOfDisplay = state.filteredArticle.firstIndex(of: selectedFeed) else { return .none } //FIXME: 에러 대응 수정 필요
        
        state.selectedDateArticle[indexOfAll].folderId = folder.id
        state.selectedDateArticle[indexOfAll].folderName = folder.name
        state.filteredArticle[indexOfDisplay].folderId = folder.id
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
          await send(.folderOfAllCountUp)
          await send(.delegate(.willRemoveFeedOfParent(targetFeedID)))
        }
  

        
      case let .categoryStateModified(targetFeedID):
        guard let indexOfCurrentFeedCard = state.filteredArticle.firstIndex(where: { $0.feedId == targetFeedID }) else { return .none }
        let folderID = state.filteredArticle[indexOfCurrentFeedCard].folderId
        let folderName = state.filteredArticle[indexOfCurrentFeedCard].folderName
        
        var needChangeFolder = false
        
        if state.folderList.first(where: { $0.folderId == folderID })?.feedCount == 1 {
          state.folderList.removeAll(where: { $0.folderId == folderID })
          needChangeFolder = true
          
          if folderName == "미분류" {
            state.existedNotClassifiedFolder = false
          }
        } else {
          if let targetIndex = state.folderList.firstIndex(where: { $0.folderId == state.filteredArticle[indexOfCurrentFeedCard].folderId }) {
            state.folderList[targetIndex].feedCount -= 1
          }
        }
        
        let totalFolder = state.folderList[0]
        guard totalFolder.feedCount > 1 else { return .send(.delegate(.reloadSelectedDateFeedCard)) }
        
        return needChangeFolder ? .send(.changeCategorySelectedIndex(targetIndex: 0)) : .none
        
      case let .deleteSelectedFeedCard(targetFeedID):
        if let indexOfAll = state.selectedDateArticle.firstIndex(where: { $0.feedId == targetFeedID }) {
          state.selectedDateArticle.remove(at: indexOfAll)
        }
        
        return .none
        
      case let .deleteFilteredFeedCard(targetFeedID):
        if let indexOfDisplay = state.filteredArticle.firstIndex(where: { $0.feedId == targetFeedID }) {
          state.filteredArticle.remove(at: indexOfDisplay)
        }
        
        return .none
        
      case let .feedCardUpdate(modifiedFeed):
        return .run { send in
          await send(.filteredFeedCardUpdate(modifiedFeed))
          await send(.allOfSelectedDateFeedCardUpdate(modifiedFeed))
          await send(.reClassifyFolder)
        }
        
      case let .filteredFeedCardUpdate(modifiedFeed):
        guard let targetFeedIndex = state.filteredArticle.firstIndex(where: { $0.feedId == modifiedFeed.feedId }) else { return .none }
        
        state.filteredArticle[targetFeedIndex] = modifiedFeed
        
        return .none
        
      case let .allOfSelectedDateFeedCardUpdate(modifiedFeed):
        guard let targetFeedIndex = state.selectedDateArticle.firstIndex(where: { $0.feedId == modifiedFeed.feedId }) else { return .none }
        
        state.selectedDateArticle[targetFeedIndex] = modifiedFeed
        
        return .none
        
        //MARK: User Action
      case let .cardItemSaveButtonTapped(feedID, isMarked):
        guard let indexOfAllArticle = state.selectedDateArticle.firstIndex(where: { $0.feedId == feedID }),
              let indexOfDisplayArticle = state.filteredArticle.firstIndex(where: { $0.feedId == feedID }) else { return .none }
        
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
