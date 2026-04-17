//
//  GoogleAdInterstitialView.swift
//  Feature
//
//  Created by kyuchul on 11/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

public struct GoogleAdInterstitialView: UIViewControllerRepresentable {
  @Binding private var isPresented: Bool
  @Binding private var interstitialAd: GoogleAd?
  private let dismissAdScreen: () -> Void
  private let viewController: UIViewController

  public init(isPresented: Binding<Bool>,
       interstitialAd: Binding<GoogleAd?>,
       dismissAdScreen: @escaping () -> Void
  ) {
    self._isPresented = isPresented
    self._interstitialAd = interstitialAd
    self.dismissAdScreen = dismissAdScreen
    self.viewController = UIViewController()
  }

  public func makeUIViewController(context: Context) -> UIViewController {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
      if let interstitialAd {
        interstitialAd.ad.present(from: viewController)
      }
    }

    return viewController
  }

  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

  public func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
}

extension GoogleAdInterstitialView {
  public final class Coordinator: NSObject, FullScreenContentDelegate {
    private let parent: GoogleAdInterstitialView

    init(parent: GoogleAdInterstitialView) {
      self.parent = parent
      super.init()
      parent.interstitialAd?.ad.fullScreenContentDelegate = self
    }

    public func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
      parent.isPresented.toggle()
      parent.dismissAdScreen()
    }
  }
}
