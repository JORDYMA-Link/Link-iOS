//
//  LinkEndpoint.swift
//  Models
//
//  Created by kyuchul on 8/19/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Moya

enum LinkEndpoint {
  case postLinkSummary(link: String, content: String)
  case postLinkImage(feedId: Int, thumbnailImage: Data)
  case patchLink(feedId: Int, folderName: String, title: String, summary: String, keywords: [String], memo: String)
  case getLinkSummary(feedId: Int)
  case getLinkProcessing
  case deleteLinkDenySummary(feedId: Int)
}

extension LinkEndpoint: BaseTargetType {
  var path: String {
    let baseLinkRoutePath: String = "/api/feeds"
    
    switch self {
    case .postLinkSummary:
      return baseLinkRoutePath + "/summary"
    case let .postLinkImage(feedId, _):
      return baseLinkRoutePath + "/image/\(feedId)"
    case let .patchLink(feedId, _, _, _, _, _):
      return baseLinkRoutePath + "/\(feedId)"
    case let .getLinkSummary(feedId):
      return baseLinkRoutePath + "/summary\(feedId)"
    case .getLinkProcessing:
      return baseLinkRoutePath + "/processing"
    case let .deleteLinkDenySummary(feedId):
      return baseLinkRoutePath + "/processing/\(feedId)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .postLinkSummary, .postLinkImage:
      return .post
    case .patchLink:
      return .patch
    case .getLinkSummary, .getLinkProcessing:
      return .get
    case .deleteLinkDenySummary:
      return .delete
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .postLinkSummary(link, content):
      return .requestParameters(parameters: [
        "link": link,
        "content": content
      ], encoding: JSONEncoding.default)
      
    case let .postLinkImage(feedId, thumbnailImage):
      let thumbnailImageFormData = MultipartFormData(provider: .data(thumbnailImage), name: "thumbnailImage", fileName: "\(feedId).jpg")
      return .uploadMultipart([thumbnailImageFormData])
      
    case let .patchLink(_, folderName, title, summary, keywords, memo):
      let patchLinkBody = PatchLinkRequest(folderName: folderName, title: title, summary: summary, keywords: keywords, memo: memo)
      return .requestJSONEncodable(patchLinkBody)
      
    case .getLinkSummary, .getLinkProcessing, .deleteLinkDenySummary:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .postLinkImage:
      return ["Content-type":"multipart/form-data"]
      
    default:
      return ["Content-type":"application/json"]
    }
  }
}
