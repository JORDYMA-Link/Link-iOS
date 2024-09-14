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
    //MARK: - Business Action
    case filteringFolder
    case allFolderCountUp
    //MARK: - User Action
    case changeCategorySelectedIndex(targetIndex: Int)
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
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .filteringFolder:
        for element in state.allArticle {
          if let _ = state.folderList[element.folderID] {
            state.folderList[element.folderID]?.feedCount += 1
          } else {
            state.folderList[element.folderID] = FolderInfo(folderName: element.folderName, feedCount: 1)
          }
        }
        return .none
        
      case .allFolderCountUp:
        state.folderList[0]?.feedCount += 1
        return .none
        
      case let .changeCategorySelectedIndex(folderId):
        state.categorySelectedIndex = folderId
        state.displayArticle = state.allArticle.filter({ $0.folderID == folderId })
        return .none
      }
    }
  }
}


