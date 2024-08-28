//
//  NoticeView.swift
//  Features
//
//  Created by 문정호 on 8/26/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

public struct NoticeView: View {
  public let store: StoreOf<NoticeFeature>
  
  public var body: some View {
    ScrollView(.vertical) {
      LazyVStack(alignment: .leading) {
        ForEach(store.noticeList) { notice in
          DisclosureGroup(
            content: {
              VStack {
                Text(notice.content)
                  .font(.regular(size: ._14))
                  .foregroundStyle(Color.bkColor(.gray800))
                  .padding(EdgeInsets(top: 13, leading: 16, bottom: 16, trailing: 13))
              }
              .background(Color.bkColor(.gray300), in: .rect(cornerRadius: 10))
              .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
            },
            label: {
              VStack(alignment: .leading) {
                Text(notice.date)
                  .font(.semiBold(size: ._12))
                  .foregroundStyle(Color.bkColor(.gray600))
                
                Text(notice.title)
                  .font(.semiBold(size: ._15))
                  .foregroundStyle(Color.bkColor(.gray900))
                  .multilineTextAlignment(.leading)
                  .lineLimit(2)
              }
            }
          ) // DisclosureGroup
          .padding(.all, 16)
          .onAppear(perform: {
            guard let lastItem = store.noticeList.last else { return }
            if lastItem.id == notice.id {
              debugPrint("paging")
            }
          })
        } //Foreach
      }// LazyVStack
    } //ScrollView
  }
}



#Preview {
  NoticeView(store: Store(initialState: NoticeFeature.State(), reducer: {
    NoticeFeature()
  }))
}

