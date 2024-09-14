//
//  BKActivityView.swift
//  CommonFeature
//
//  Created by kyuchul on 9/14/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public struct BKActivityView: UIViewControllerRepresentable {
  @Binding var isPresented: Bool
  private let activityItmes: [Any]
  private let applicationActivities: [UIActivity]? = nil
  
  public init(
    isPresented: Binding<Bool>,
    activityItmes: [Any]
  ) {
    self._isPresented = isPresented
    self.activityItmes = activityItmes
  }
  
  public func makeUIViewController(context: UIViewControllerRepresentableContext<BKActivityView>) -> UIActivityViewController {
    let activityViewController = UIActivityViewController(
      activityItems: activityItmes,
      applicationActivities: applicationActivities
    )
    
    activityViewController.completionWithItemsHandler = { (_, _, _, _) in
      isPresented = false
    }
    
    return activityViewController
  }
  
  public func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<BKActivityView>) {}
}
