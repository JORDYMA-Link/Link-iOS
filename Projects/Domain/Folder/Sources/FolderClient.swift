//
//  FolderClient.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 10/18/24.
//

import Foundation

import DomainFolderInterface
import Models
import Services

import Dependencies

extension DomainFolderClient: DependencyKey {
  public static var liveValue: DomainFolderClient = .live()
  private static func live() -> DomainFolderClient {
    let folderProvider = Provider<DomainFolderEndpoint>()
    
    return DomainFolderClient(
      getFolders: {
        let responseDTO: DomainFolderListResponse = try await folderProvider.request(.getFolders, modelType: DomainFolderListResponse.self)
        return responseDTO.toDomain()
        
      }, deleteFolder: { folderId in
        return try await folderProvider.requestPlain(.deleteFolder(folderId: folderId))
      }
    )
  }
}
