//
//  LinkContentView.swift
//  Features
//
//  Created by kyuchul on 7/6/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models
import Common

import ComposableArchitecture
import SwiftUIIntrospect

struct LinkContentView: View {
  @Bindable var store: StoreOf<LinkContentFeature>
  @StateObject var scrollViewDelegate = ScrollViewDelegate()
  @State private var isScrolled: Bool = false
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 0) {
        LinkContentHeaderView(
          link: LinkDetail.mock(),
          saveAction: {
            print("save")
          }, shareAction: {
            print("share")
          })
        .background(ViewHeightGeometry())
        .onPreferenceChange(SectionHeaderPreferenceKey.self) { maxY in
          let headerMaxY = maxY + UIApplication.topSafeAreaInset
          
          DispatchQueue.main.async {
            scrollViewDelegate.headerMaxY = headerMaxY
          }
        }
        
        Text("test")
          .frame(height: 400)
        Text("test")
          .frame(height: 400)
        Text("test")
          .frame(height: 400)
        Text("test")
          .frame(height: 400)
      }
      .overlay(alignment: .top) {
        GeometryReader { proxy in
          let minY = proxy.frame(in: .global).minY
          LinkContentNavigationBar(
            isScrolled: $isScrolled,
            title: LinkDetail.mock().title,
            leftAction: {
              store.send(.closeButtonTapped)
            },
            rightAction: {}
          )
          .offset(y: -minY)
        }
      }
    }
    .introspect(.scrollView, on: .iOS(.v17)) { scrollView in
      scrollView.delegate = scrollViewDelegate
    }
    .toolbar(.hidden, for: .navigationBar)
    .ignoresSafeArea()
    .animation(.easeInOut, value: isScrolled)
    .onReceive(scrollViewDelegate.$topToHeader.receive(on: DispatchQueue.main)) {
      self.isScrolled = $0
    }
  }
}

#Preview {
  NavigationStack {
    LinkContentView(store: .init(initialState: LinkContentFeature.State()) {
      LinkContentFeature()
    })
  }
}
