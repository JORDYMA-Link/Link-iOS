//
//  RecentSearchView.swift
//  Features
//
//  Created by kyuchul on 7/25/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

struct RecentSearchView: View {
  private let resentSearches: [String]
  private let removeAllAction: () -> Void
  private let removeAction: (String) -> Void
  
  init(
    resentSearches: [String],
    removeAllAction: @escaping () -> Void,
    removeAction: @escaping (String) -> Void
  ) {
    self.resentSearches = resentSearches
    self.removeAllAction = removeAllAction
    self.removeAction = removeAction
  }
  
  var body: some View {
    VStack(spacing: 0) {
      SearchRecentHeaderView(removeAction: removeAllAction)
      
      ScrollView(showsIndicators: false) {
        ForEach(resentSearches, id: \.self) { searches in
          VStack(spacing: 0) {
            HStack {
              BKText(
                text: searches,
                font: .regular,
                size: ._14,
                lineHeight: 20,
                color: .bkColor(.gray900)
              )
              
              Spacer()
              
              BKIcon(
                image: CommonFeature.Images.icoClose,
                color: .bkColor(.gray700),
                size: .init(width: 16, height: 16)
              )
            }
            .padding(16)
            
            Divider()
              .foregroundStyle(Color.bkColor(.gray400))
          }
          .onTapGesture { removeAction(searches) }
        }
      }
    }
  }
}

extension RecentSearchView {
  private struct SearchRecentHeaderView: View {
    private let removeAction: () -> Void
    
    init(removeAction: @escaping () -> Void) {
      self.removeAction = removeAction
    }
    
    var body: some View {
      HStack {
        BKText(
          text: "최근 검색어",
          font: .semiBold,
          size: ._18,
          lineHeight: 26,
          color: .bkColor(.gray900)
        )
        
        Spacer()
        
        BKText(
          text: "모두 지우기",
          font: .regular,
          size: ._13,
          lineHeight: 18,
          color: .bkColor(.gray700)
        )
        .underline(color: .bkColor(.gray700))
        .onTapGesture { removeAction() }
      }
      .padding(16)
    }
  }
}
