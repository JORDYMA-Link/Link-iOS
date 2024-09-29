//
//  BKAlertRootView.swift
//  CommonFeature
//
//  Created by kyuchul on 8/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

struct BKAlertRootView: View {
  @ObservedObject var manager = BkAlertManager.shared
  
  var body: some View {
    ZStack {
      Color.bkColor(.black)
        .ignoresSafeArea()
        .opacity(manager.isPresented ? 0.6 : 0.0)
        .zIndex(0)
      
      ForEach(manager.property) { property in
        BKAlert(
          isLoadingType: property.isLoadingType,
          title: property.title,
          description: property.description,
          buttonType: property.buttonType,
          leftAction: {
            await property.leftButtonAction?()
            manager.dismiss()
          },
          rightAction: {
            await property.rightButtonAction()
            manager.dismiss()
          }
        )
        .padding(.horizontal, 24)
        .opacity(manager.isPresented ? 1.0 : 0.0)
        .zIndex(1)
      }
    }
    .animation(.default, value: manager.isPresented)
  }
}
