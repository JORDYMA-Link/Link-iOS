//
//  BKContainerWebView.swift
//  Features
//
//  Created by kyuchul on 9/10/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import BKDesignSystem

struct BKContainerWebView: View {
  @StateObject private var viewModel = BKWebViewModel()
  @Environment(\.dismiss) private var dismiss
  private let url: URL
  
  init(url: URL) {
    self.url = url
  }
  
  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(
        viewModel: viewModel,
        dismissAction: { dismiss() }
      )
      
      BKWebView(
        viewModel: viewModel,
        url: url
      )
      .overlay{
        if viewModel.isLoading {
          ProgressView()
        }
      }
      
      BottomToolBar(
        viewModel: viewModel
      )
    }
    .sheet(isPresented: $viewModel.isActivityViewPresented) {
      BKActivityView(
        isPresented: $viewModel.isActivityViewPresented,
        activityItmes: [URL(string: viewModel.title) ?? ""]
      )
      .presentationDetents([.medium])
    }
  }
}

private struct NavigationBar: View {
  @ObservedObject private var viewModel: BKWebViewModel
  private let dismissAction: () -> Void
  
  init(
    viewModel: BKWebViewModel,
    dismissAction: @escaping () -> Void
  ) {
    self.viewModel = viewModel
    self.dismissAction = dismissAction
  }
  
  var body: some View {
    HStack(spacing: 12) {
      BKIcon(
        image: BKDesignSystem.Images.icoClose,
        color: .bkColor(.gray900),
        size: .init(width: 24, height: 24)
      )
      .onTapGesture { dismissAction() }
      
      BKText(
        text: viewModel.title,
        font: .semiBold,
        size: ._18,
        lineHeight: 26,
        color: .bkColor(.gray900)
      )
      .frame(maxWidth: .infinity, alignment: .center)
      .lineLimit(1)
      
      Spacer()
    }
    .padding(.horizontal, 16)
    .frame(minHeight: 58, maxHeight: 58)
  }
}

private struct BottomToolBar: View {
  @ObservedObject private var viewModel: BKWebViewModel
  
  init(viewModel: BKWebViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    HStack {
      BKIcon(
        image: BKDesignSystem.Images.icoChevronLeft,
        color: .bkColor(viewModel.canGoBack ? .gray900 : .gray700),
        size: .init(width: 24, height: 24)
      )
      .onTapGesture {
        withAnimation {
          viewModel.goBack()
        }
      }
      
      Spacer()
      
      BKIcon(
        image: BKDesignSystem.Images.icoChevronRight,
        color: .bkColor(viewModel.canGoForward ? .gray900 : .gray700),
        size: .init(width: 24, height: 24)
      )
      .onTapGesture {
        withAnimation {
          viewModel.goForward()
        }
      }
      
      Spacer()
      
      BKIcon(
        image: BKDesignSystem.Images.icoShare,
        color: .bkColor(.gray900),
        size: .init(width: 24, height: 24)
      )
      .onTapGesture {
        viewModel.isActivityViewPresented = true
      }
      
      Spacer()
      
      BKIcon(
        image: BKDesignSystem.Images.icoRotateRight,
        color: .bkColor(.gray900),
        size: .init(width: 24, height: 24)
      )
      .onTapGesture {
        withAnimation {
          viewModel.reload()
        }
      }
    }
    .padding(.horizontal, 16)
    .frame(minHeight: 50, maxHeight: 50)
    .background(Color.bkColor(.gray300))
  }
}
