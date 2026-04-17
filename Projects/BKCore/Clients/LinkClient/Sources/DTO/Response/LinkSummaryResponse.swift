//
//  LinkSummaryResponse.swift
//  Services
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKModel

struct LinkSummaryResponse: Decodable {
  let feedId: Int
  let subject: String
  let summary: String
  let keywords: [String]
  let folders: [String]
  let platformImage: String
  let thumbnailImage: String?
  let recommendFolder: String
  let recommendFolders: [String]
  let date: String
}

extension LinkSummaryResponse {
  public func toDomain() -> Feed {
    return Feed(
      feedId: feedId,
      thumbnailImage: thumbnailImage ?? "",
      platformImage: platformImage,
      title: subject,
      date: date.replacingOccurrences(of: "-", with: "."),
      summary: summary,
      keywords: keywords,
      folderName: recommendFolder,
      folders: folders.filter { $0 != recommendFolder },
      memo: "",
      isMarked: false,
      originUrl: ""
    )
  }
}
