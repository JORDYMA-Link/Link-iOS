//
//  FolderFeedListResponse.swift
//  Services
//
//  Created by kyuchul on 9/7/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

struct FolderFeedListResponse: Decodable {
  let folderId: Int
  let folderName: String
  let feedList: [FeedCardResponse]
}
