//
//  LinkSummaryResponse.swift
//  Services
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

struct LinkSummaryResponse: Decodable {
  let feedId: Int
  let content: LinkSummaryContentResponse
  let sourceURL: String
  let recommendFolder: String
  let recommendFolders: [String]
  
  struct LinkSummaryContentResponse: Decodable {
    let subject: String
    let summary: String
    let keywords: [String]
    let folders: [String]
  }
}

extension LinkSummaryResponse {
  func toDomain() -> LinkSummary {
    return LinkSummary(
      feedId: feedId,
      content: LinkSummary.LinkSummaryContent(
        subject: content.subject,
        summary: content.summary,
        keywords: content.keywords,
        folders: content.folders
      ),
      sourceURL: sourceURL,
      recommendFolder: recommendFolder,
      recommendFolders: recommendFolders
    )
  }
}
