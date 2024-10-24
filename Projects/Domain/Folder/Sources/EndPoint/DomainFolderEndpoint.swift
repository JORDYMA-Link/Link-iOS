//
//  DomainFolderEndpoint.swift
//  DomainFolderInterface
//
//  Created by kyuchul on 10/22/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Services

import Moya

enum DomainFolderEndpoint {
  case getFolders
  case deleteFolder(folderId: Int)
}

extension DomainFolderEndpoint: BaseTargetType {
  var path: String {
    let baseFolderRoutePath: String = "/api/folders"
    
    switch self {
    case .getFolders:
      return baseFolderRoutePath
      
    case let .deleteFolder(folderId):
      return baseFolderRoutePath + "/\(folderId)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getFolders:
      return .get
      
    case .deleteFolder:
      return .delete
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .getFolders, .deleteFolder:
      return .requestPlain
    }
  }
}
