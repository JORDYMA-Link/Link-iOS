//
//  SummaryStatusView.swift
//  Features
//
//  Created by kyuchul on 8/22/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import Models
import Services
import CommonFeature

import ComposableArchitecture

struct SummaryStatusView: View {
  @Perception.Bindable var store: StoreOf<SummaryStatusFeature>
  private let timer = Timer.publish(every: 5, tolerance: 0.5, on: .main, in: .common).autoconnect()
  
  var body: some View {
    WithPerceptionTracking {
      ScrollView(showsIndicators: false) {
        LazyVStack(spacing: 0) {
          ForEach(store.processingList, id: \.feedId) { item in
            SummaryStatusItem(
              title: item.title,
              status: item.status,
              deleteAction: { store.send(.deleteButtonTapped(item.feedId)) }
            )
            .onTapGesture {
              if item.status == .completed {
                store.send(.summaryStatusItemTapped(item.feedId))
              }
            }
          }
        }
      }
      .navigationBarBackButtonHidden()
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          LeadingItem(
            type: .dismiss(
              "요약 중인 링크", 
              { store.send(.closeButtonTapped) }
            )
          )
        }
      }
      .onReceive(timer) { time in
        /// 5초에 한번 API 재통신
        store.send(.onAppear)
      }
      .onAppear { store.send(.onAppear) }
      .onDisappear { timer.upstream.connect().cancel() }
    }
  }
}
