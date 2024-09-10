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
  case getFolderFeeds(folderId: Int, cursor: Int, pageSize: Int = 10)
  case postFolder(name: String)
  case postOnboardingFolder(topics: [String])
  case deleteFolder(folderId: Int)
  case patchFolder(folderId: Int, name: String)
  case patchFeedFolder(feedId: Int, name: String)
}

extension FolderEndpoint: BaseTargetType {
  var path: String {
    let baseFolderRoutePath: String = "/api/folders"
    
    switch self {
    case .getFolders, .postFolder:
      return baseFolderRoutePath
    case let .getFolderFeeds(folderId, _, _):
      return baseFolderRoutePath + "/\(folderId)/feeds"
    case .postOnboardingFolder:
      return baseFolderRoutePath + "/onboarding"
    case let .deleteFolder(folderId), let .patchFolder(folderId, _):
      return baseFolderRoutePath + "/\(folderId)"
    case .patchFeedFolder:
      return baseFolderRoutePath + "/feed"
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
    case .patchFolder, .patchFeedFolder:
      return .patch
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .getFolders, .deleteFolder:
      return .requestPlain
      
    case let .getFolderFeeds(_, cursor, pageSize):
      var parameters: [String: Any] = ["pageSize": pageSize]
      
      // cursor가 0이 아닐 때만 추가
      if cursor != 0 {
        parameters["cursor"] = cursor
      }
      
      return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
      
    case let .postFolder(name):
      return .requestParameters(parameters: [
        "name" : name
      ], encoding: JSONEncoding.default)
      
    case let .postOnboardingFolder(topics):
      return .requestParameters(parameters: [
        "topics" : topics
      ], encoding: JSONEncoding.default)
      
    case let .patchFolder(_, name):
      return .requestParameters(parameters: [
        "name" : name
      ], encoding: JSONEncoding.default)
      
    case let .patchFeedFolder(feedId, name):
      return .requestParameters(parameters: [
        "feedId" : feedId,
        "name" : name
      ], encoding: JSONEncoding.default)
    }
  }
}
