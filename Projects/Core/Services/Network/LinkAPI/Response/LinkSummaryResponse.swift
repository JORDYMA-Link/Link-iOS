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
  let subject: String
  let summary: String
  let keywords: [String]
  let folders: [String]
  let platformImage: String
  let recommendFolder: String
  let recommendFolders: [String]
}

extension LinkSummaryResponse {
  public func toDomain() -> Feed {
    return Feed(
      feedId: feedId,
      thumnailImage: "",
      platformImage: platformImage,
      title: subject,
      date: "",
      summary: summary,
      keywords: keywords,
      folderName: recommendFolder,
      recommendFolders: recommendFolders,
      memo: "",
      isMarked: false,
      originUrl: ""
    )
  }
}
