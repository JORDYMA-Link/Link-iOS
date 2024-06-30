//
//  SearchKeywordFeature.swift
//  Blink
//
//  Created by kyuchul on 6/10/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

@Reducer
public struct SearchKeywordFeature {
  @ObservableState
  public struct State: Equatable {
    var text = ""
    var keyword = ""
    var section: [SearchKeywordSection] = []
    
    public init() { }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case closeButtonTapped
    case searchButtonTapped(String)
    case seeMoreButtonTapped(SearchKeywordSection)
    
    // MARK: Inner Business Action
    
    // MARK: Inner SetState Action
    case _setSearchList(SearchKeywordSection)
  }
  
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .closeButtonTapped:
         return .run { _ in await self.dismiss() }
        
      case let .searchButtonTapped(keyword):
        state.keyword = keyword
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
}
