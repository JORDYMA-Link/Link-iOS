//
//  ShareViewController.swift
//  SharedExtension
//
//  Created by 김규철 on 5/16/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import UIKit
import SwiftUI

class ShareViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    openParentApp()
    closeShareExtension()
  }
  
  func openParentApp() {
    if let url = URL(string: "blink://") {
      var responder: UIResponder? = self
      
      while responder != nil {
        if let application = responder as? UIApplication {
          application.open(url)
          break
        }
        
        responder = responder?.next
      }
    }
  }
  
  private func closeShareExtension() {
    extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
  }
}
