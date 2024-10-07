//
//  FolderResponse.swift
//  Services
//
//  Created by kyuchul on 8/8/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

struct FolderListResponse: Decodable {
  let folderList: [FolderResponse]
}

struct FolderResponse: Decodable {
  let id: Int
  let name: String
  let feedCount: Int
}

extension FolderListResponse {
  public func toDomain() -> [Folder] {
    return folderList.map {
      $0.toDomain()
    }
  }
}

extension FolderResponse {
  public func toDomain() -> Folder {
    return Folder(
      id: id,
      name: name,
      feedCount: feedCount
    )
  }
}
