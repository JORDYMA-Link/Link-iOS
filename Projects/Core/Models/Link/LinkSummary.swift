//
//  LinkSummary.swift
//  Services
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct LinkSummary: Equatable {
  let feedId: Int
  let content: LinkSummaryContent
  let sourceURL: String
  let recommendFolder: String
  let recommendFolders: [String]
  
  public init(
    feedId: Int,
    content: LinkSummaryContent,
    sourceURL: String,
    recommendFolder: String,
    recommendFolders: [String]
  ) {
    self.feedId = feedId
    self.content = content
    self.sourceURL = sourceURL
    self.recommendFolder = recommendFolder
    self.recommendFolders = recommendFolders
  }
  
  public struct LinkSummaryContent: Equatable {
    let subject: String
    let summary: String
    let keywords: [String]
    let folders: [String]
  }
}
