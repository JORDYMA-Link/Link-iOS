//
//  SearchResultTitle.swift
//  Features
//
//  Created by kyuchul on 7/28/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

struct SearchResultTitle: View {
  private let keyword: String
  private let title: String
  private let isEmpty: Bool
  
  init(
    keyword: String,
    title: String,
    isEmpty: Bool = false
  ) {
    self.keyword = keyword
    self.title = title
    self.isEmpty = isEmpty
  }
  
  var body: some View {
    Text("\(keywordString)\(title)")
      .font(.semiBold(size: ._16))
      .fontWithLineHeight(font: .regular(size: ._16), lineHeight: 22)
      .foregroundStyle(Color.bkColor(.gray900))
  }
}

extension SearchResultTitle {
  private var keywordString: AttributedString {
    let string = "\"\(keyword)\""
    var attributedString = AttributedString(string)
    attributedString.foregroundColor = .bkColor(isEmpty ? .red : .main300)
    attributedString.font = .semiBold(size: ._16)
    return attributedString
  }
}
