//
//  BkModalManager.swift
//  CommonFeature
//
//  Created by kyuchul on 8/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

@MainActor
public final class BkModalManager: ObservableObject {
  public static let shared = BkModalManager()
  private init() {}
  
  @Published var isPresented: Bool = false
  private(set) var property: BKAlertProperty = .init(title: "", description: "", buttonType: .singleButton(), rightButtonAction: {})
  private var continuation: CheckedContinuation<Void, Never>?
  
  public func present(_ property: BKAlertProperty) async {
    self.isPresented = true
    self.property = property
    return await withCheckedContinuation { continuation in
      self.continuation = continuation
//      self.continuation?.resume(returning: ())
    }
  }
  
  public func dismiss() {
    isPresented = false
    continuation?.resume()
    continuation = nil
  }
}
