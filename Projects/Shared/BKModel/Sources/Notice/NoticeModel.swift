//
//  Notice.swift
//  Models
//
//  Created by 문정호 on 8/26/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct NoticeModel: Identifiable, Equatable {
  public let id: UUID = UUID()
  public let date: String
  public let title: String
  public let content: String
  
  public init(
    date: String,
    title: String,
    content: String
  ) {
    self.date = date
    self.title = title
    self.content = content
  }
}
