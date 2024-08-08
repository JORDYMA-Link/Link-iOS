//
//  FolderEndpoint.swift
//  CoreKit
//
//  Created by kyuchul on 8/8/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Moya

enum FolderEndpoint {
  case getFolders
  case getFolderFeeds(folderId: String)
  case postFolder(name: String)
  case postOnboardingFolder(topics: [String])
  case deleteFolder(folderId: String)
  case fetchFolder(folderId: String, name: String)
}

extension FolderEndpoint: BaseTargetType {
  var path: String {
    switch self {
    case .getFolders, .postFolder:
      return "/api/folders"
    case let .getFolderFeeds(folderId):
      return "/api/folders/\(folderId)/feeds"
    case .postOnboardingFolder:
      return "/api/folders/onboarding"
    case let .deleteFolder(folderId), let .fetchFolder(folderId, _):
      return "/api/folders/\(folderId)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getFolders, .getFolderFeeds:
      return .get
    case .postFolder, .postOnboardingFolder:
      return .post
    case .deleteFolder:
      return .delete
    case .fetchFolder:
      return .patch
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .getFolders, .getFolderFeeds, .deleteFolder:
      return .requestPlain
      
    case let .postFolder(name):
      return .requestParameters(parameters: [
        "name" : name
      ], encoding: JSONEncoding.default)
      
    case let .postOnboardingFolder(topics):
      return .requestParameters(parameters: [
        "topics" : topics
      ], encoding: JSONEncoding.default)
      
    case let .fetchFolder(_, name):
      return .requestParameters(parameters: [
        "name" : name
      ], encoding: JSONEncoding.default)
    }
  }
}
