//
//  SummaryStatusItem.swift
//  Features
//
//  Created by kyuchul on 8/23/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import BKDesignSystem
import BKModel

struct SummaryStatusItem: View {
  private let title: String
  private let status: ProcessingStatusType
  private let url: String
  private let deleteAction: () -> Void
  
  init(
    title: String,
    status: ProcessingStatusType,
    url: String,
    deleteAction: @escaping () -> Void
  ) {
    self.title = title
    self.status = status
    self.url = url
    self.deleteAction = deleteAction
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Spacer()
      
      HStack(spacing: 4) {
        titleView
        
        if status == .failed {
          deleteButton
        }
      }
      .padding(24)
      
      Spacer()
    }
    .frame(minHeight: 112, maxHeight: 112)
    .background(statusBackgroundColor)
    .divider()
  }
  
  @ViewBuilder
  var titleView: some View {
    VStack(alignment: .leading, spacing: 4) {
      BKText(
        text: status.title,
        font: .semiBold,
        size: ._14,
        lineHeight: 20,
        color: statusTintColor
      )
      .if(status == .completed) { view in
        view.completedTitle()
      }
      
      VStack(spacing: 0) {
        if status != .completed {
          BKText(
            text: url,
            font: .semiBold,
            size: ._14,
            lineHeight: 20,
            color: .bkColor(.gray900)
          )
          .frame(maxWidth: .infinity, alignment: .leading)
          .lineLimit(1)
        }
        
        BKText(
          text: title,
          font: .semiBold,
          size: ._14,
          lineHeight: 20,
          color: .bkColor(.gray900)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(2)
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
      }
    }
  }
  
  @ViewBuilder
  var deleteButton: some View {
    Button(action: deleteAction) {
      BKText(
        text: "삭제하기",
        font: .regular,
        size: ._13,
        lineHeight: 18,
        color: .bkColor(.gray900)
      )
      .padding(.vertical, 7)
      .padding(.horizontal, 11)
      .background(Color.bkColor(.gray300))
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(Color.bkColor(.gray500), lineWidth: 1)
          .padding(1)
      )
    }
  }
}

private extension SummaryStatusItem {
  var statusTintColor: Color {
    switch status {
    case .requested, .processing:
      return .bkColor(.gray600)
    case .completed:
      return .bkColor(.main300)
    case .failed:
      return .bkColor(.red)
    }
  }
  
  var statusBackgroundColor: Color {
    switch status {
    case .requested, .processing:
      return .bkColor(.white)
    case .completed:
      return .bkColor(.main50)
    case .failed:
      return .bkColor(.lightRed)
    }
  }
}

private extension View {
  func completedTitle() -> some View {
    HStack(alignment: .top, spacing: 0) {
      self
      
      Circle()
        .fill(Color.bkColor(.yellow))
        .frame(width: 6, height: 6)
    }
  }
  
  func divider() -> some View {
    VStack(spacing: 0) {
      self
      
      Divider()
        .foregroundStyle(Color.bkColor(.gray500))
        .frame(height: 1)
    }
  }
}
