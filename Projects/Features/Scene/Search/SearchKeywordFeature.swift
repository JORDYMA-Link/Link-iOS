//
//  SearchKeywordFeature.swift
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
public struct SearchKeywordFeature {
  @ObservableState
  public struct State: Equatable {
    var text = ""
    var keyword = ""
    var section: [SearchKeywordSection] = []
    var recentSearches: [String] = []
    
    public init() { }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case onTask
    case closeButtonTapped
    case removeAllRecentSearchesButtonTapeed
    case removeRecentSearchesCellTapeed(String)
    case searchButtonTapped(String)
    case seeMoreButtonTapped(SearchKeywordSection)
    
    // MARK: Inner Business Action
    
    // MARK: Inner SetState Action
    case _setSearchList(SearchKeywordSection)
  }
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.userDefaultsClient) private var userDefault
  
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
        
      case .removeAllRecentSearchesButtonTapeed:
        guard !userDefault.stringArray(.recentSearches, []).isEmpty else { return .none }
        
        userDefault.set([], .recentSearches)
        state.recentSearches = userDefault.stringArray(.recentSearches, [])
        return .none
        
      case let .removeRecentSearchesCellTapeed(keyword):
        var recentSearches = userDefault.stringArray(.recentSearches, [])
        
        if let index = recentSearches.firstIndex(where: { $0 == keyword }) {
          recentSearches.remove(at: index)
        }
        
        userDefault.set(recentSearches, .recentSearches)
        state.recentSearches = userDefault.stringArray(.recentSearches, [])
        return .none
        
      case let .searchButtonTapped(keyword):
        guard !keyword.isEmpty else { return .none }
        
        state.text = keyword
        state.section = []
        state.keyword = keyword
        saveRecentSearches(keyword: keyword)
        return requestSearchKeyword(keyword: keyword)
        
      case let .seeMoreButtonTapped(section):
        if let index = state.section.firstIndex(where: { $0.id.uuidString == section.id.uuidString }) {
          state.section[index].isSeeMoreButtonHidden = true
        }
        
        return requestSearchKeyword(keyword: state.keyword)
        
      case let ._setSearchList(searchList):
        state.section.append(searchList)
        return .none
        
      default:
        return .none
      }
    }
  }
}

extension SearchKeywordFeature {
  private func requestSearchKeyword(keyword: String) -> Effect<Action> {
    return .run { send in
      do {
        // API 연결 이전 테스트
        let dummySearchList = [
          SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 99, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
          SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 98, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"]),
          SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 97, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"])
        ]
        await send(._setSearchList(SearchKeywordSection(searchList: dummySearchList)))
      } catch {
        print(error)
      }
    }
  }
  
  private func saveRecentSearches(keyword: String) {
    var recentSearches = userDefault.stringArray(.recentSearches, [])

    if let index = recentSearches.firstIndex(where: { $0 == keyword }) {
      recentSearches.remove(at: index)
    }
    
    recentSearches.insert(keyword, at: 0)
    let prefixRecentSearches = recentSearches.prefix(6).map { $0 }
    userDefault.set(prefixRecentSearches, .recentSearches)
  }
}
