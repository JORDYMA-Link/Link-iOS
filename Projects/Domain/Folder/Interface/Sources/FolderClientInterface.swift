//
//  FolderClientInterface.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 10/18/24.
//

import Foundation

import Models

import Dependencies
import DependenciesMacros

protocol FolderClientInterface {
  /// 보관함 폴더 리스트 조회
  var getFolders: () async throws -> [DomainFolder] { get }
  /// 폴더 삭제
  var deleteFolder: (_ folderId: Int) async throws -> Void { get }
}

// Client는 비록 프로토콜이 아니라 struct로 정의되어 있지만, 이 자체는 구현이 아닌 인터페이스 역할을 한다. 즉, Client 내부에서 특정 구현체에 직접 의존하지 않고, 기능만 정의 되어 있다.
// 오직 함수 인터페이스만 정의
// 실제 구현부는 implements에 정의
@DependencyClient
public struct DomainFolderClient: FolderClientInterface {
  public var getFolders: () async throws -> [DomainFolder]
  public var deleteFolder: (_ folderId: Int) async throws -> Void
}

extension DomainFolderClient: TestDependencyKey {
  public static let previewValue = Self()
  public static let testValue = Self()
}
