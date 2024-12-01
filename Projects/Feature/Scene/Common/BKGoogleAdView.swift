//
//  BKGoogleAdView.swift
//  Feature
//
//  Created by kyuchul on 11/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import Services

import GoogleMobileAds

struct BKGoogleAdView: UIViewControllerRepresentable {
  @Binding private var isPresented: Bool
  @Binding private var interstitialAd: GoogleAd?
  private let dismissAdScreen: () -> Void
  private let viewController: UIViewController
  
  init(isPresented: Binding<Bool>,
       interstitialAd: Binding<GoogleAd?>,
       dismissAdScreen: @escaping () -> Void
  ) {
    self._isPresented = isPresented
    self._interstitialAd = interstitialAd
    self.dismissAdScreen = dismissAdScreen
    self.viewController = UIViewController()
  }
  
  func makeUIViewController(context: Context) -> UIViewController {    
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
      if let interstitialAd {
        interstitialAd.ad.present(fromRootViewController: viewController)
      }
    }
    
    return viewController
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
}

extension BKGoogleAdView {
  final class Coordinator: NSObject, GADFullScreenContentDelegate {
    private let parent: BKGoogleAdView
    
    init(parent: BKGoogleAdView) {
      self.parent = parent
      super.init()
      parent.interstitialAd?.ad.fullScreenContentDelegate = self
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      parent.isPresented.toggle()
      parent.dismissAdScreen()
    }
  }
}
