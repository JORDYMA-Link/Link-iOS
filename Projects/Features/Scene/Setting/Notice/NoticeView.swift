//
//  NoticeView.swift
//  Features
//
//  Created by 문정호 on 8/26/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture


public struct NoticeView: View {
  @Environment(\.dismiss) private var dismiss
  
  public let store: StoreOf<NoticeFeature>
  
  public var body: some View {
    ScrollView(.vertical) {
      LazyVStack {
        ForEach(store.noticeList) { notice in
          DisclosureGroup(
            isExpanded: Binding<Bool>(
              get: { store.expandedNoticeID == notice.id },
              set: { isExpanded in
                store.send(.expanding(target: isExpanded ? notice.id : nil))
              }
          ),
            content: {
              VStack(alignment: .leading) {
                Text(notice.content)
                  .font(.regular(size: ._14))
                  .multilineTextAlignment(.leading)
                  .foregroundStyle(Color.bkColor(.gray800))
                  .padding(EdgeInsets(top: 13, leading: 16, bottom: 16, trailing: 13))
                  .frame(maxWidth: .infinity, alignment: .leading)
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
              store.send(.fetchNotice)
            }
          })
        } //Foreach
      }// LazyVStack
    } //ScrollView
    .onAppear(perform: {
      store.send(.fetchNotice)
    }) //onAppear
    
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        LeadingItem(type: .dismiss("공지사항", {
          dismiss()
        })) // LeadingItem
      } //ToolbarItem
    } // toolBar
  }// body
}



#Preview {
  NoticeView(store: Store(initialState: NoticeFeature.State(), reducer: {
    NoticeFeature()
  }))
}

