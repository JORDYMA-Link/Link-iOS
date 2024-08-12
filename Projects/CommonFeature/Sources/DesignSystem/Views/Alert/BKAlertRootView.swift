//
//  BKAlertRootView.swift
//  CommonFeature
//
//  Created by kyuchul on 8/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

struct BKAlertRootView: View {
  @ObservedObject var manager = BkModalManager.shared
  
  var body: some View {
    ZStack {
      Color.bkColor(.black)
        .ignoresSafeArea()
        .opacity(manager.isPresented ? 0.6 : 0.0)
        .zIndex(0)
      
      BKAlert(
        title: manager.property.title,
        description: manager.property.description,
        buttonType: manager.property.buttonType,
        leftAction: {
          manager.dismiss()
          manager.property.leftButtonAction?()
        },
        rightAction: {
          manager.dismiss()
          await manager.property.rightButtonAction()
        }
      )
      .padding(.horizontal, 24)
      .opacity(manager.isPresented ? 1.0 : 0.0)
      .zIndex(1)
    }
    .animation(.default, value: manager.isPresented)
  }
}
