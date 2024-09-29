//
//  BKSearchBanner.swift
//  CommonFeature
//
//  Created by kyuchul on 8/9/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public struct BKSearchBanner: View {
  private let title: String
  private let searchAction: () -> Void
  private let calendarAction: () -> Void
  
  public init(
    title: String = "콘텐츠를 찾아드립니다",
    searchAction: @escaping () -> Void,
    calendarAction: @escaping () -> Void
  ) {
    self.title = title
    self.searchAction = searchAction
    self.calendarAction = calendarAction
  }
  
  public var body: some View {
    HStack(spacing: 0) {
      searchBar
      
      Divider()
        .foregroundStyle(Color.bkColor(.gray500))
        .frame(width: 1)
        .padding(.trailing, 16)
      
      CommonFeature.Images.icoCalendar
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 20, height: 20)
        .onTapGesture { calendarAction() }
    }
    .padding(.vertical, 13)
    .padding(.horizontal, 16)
    .frame(minWidth: 46, maxHeight: 46)
    .background(Color.bkColor(.gray300))
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .contentShape(Rectangle())
    .onTapGesture { searchAction() }
  }
  
  private var searchBar: some View {
    HStack(spacing: 6) {
      CommonFeature.Images.icoSearch
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 20, height: 20)
      
      BKText(
        text: title,
        font: .regular,
        size: ._14,
        lineHeight: 20,
        color: .bkColor(.gray800)
      )
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.trailing, 12)
  }
}
