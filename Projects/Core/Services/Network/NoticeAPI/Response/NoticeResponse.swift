//
//  NoticeResponse.swift
//  Models
//
//  Created by 문정호 on 8/27/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

struct NoticeListResponse: Decodable {
  let noticeList: [NoticeResponse]
}

struct NoticeResponse: Decodable {
  let date: String
  let title: String
  let content: String
}

extension NoticeListResponse {
  public func toDomain() -> [NoticeModel] {
    return noticeList.map {
      $0.toDomain()
    }
  }
}

extension NoticeResponse {
  public func toDomain() -> NoticeModel {
    return NoticeModel(
      date: date,
      title: title,
      content: content
    )
  }
}

