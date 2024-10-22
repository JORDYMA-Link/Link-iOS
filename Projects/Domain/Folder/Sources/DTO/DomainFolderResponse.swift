//
//  DomainFolderResponse.swift
//  DomainFolderInterface
//
//  Created by kyuchul on 10/22/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import DomainFolderInterface

struct DomainFolderListResponse: Decodable {
  let folderList: [DomainFolderResponse]
}

struct DomainFolderResponse: Decodable {
  let id: Int
  let name: String
  let feedCount: Int
}

extension DomainFolderListResponse {
  public func toDomain() -> [DomainFolder] {
    return folderList.map {
      $0.toDomain()
    }
  }
}

extension DomainFolderResponse {
  public func toDomain() -> DomainFolder {
    return DomainFolder(
      id: id,
      name: name,
      feedCount: feedCount
    )
  }
}
