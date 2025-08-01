//
//  ShareViewController.swift
//  SharedExtension
//
//  Created by 김규철 on 5/16/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import UIKit
import SwiftUI

import ComposableArchitecture

@objc(ShareViewController)
class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ShareViewController viewDidLoad called")
        
        setupSwiftUIView()
    }
    
    private func setupSwiftUIView() {
        let store = Store(
            initialState: ShareRootFeature.State()
        ) {
            ShareRootFeature()
        }
        
        let hostingController = UIHostingController(
            rootView: ShareRootView(store: store)
        )
        hostingController.presentationController?.delegate = self
        hostingController.modalPresentationStyle = .automatic
        present(hostingController, animated: true)
    }
    
    private func closeShareExtension() {
        print("ShareExtension closing...")
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension ShareViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        closeShareExtension()
    }
}
