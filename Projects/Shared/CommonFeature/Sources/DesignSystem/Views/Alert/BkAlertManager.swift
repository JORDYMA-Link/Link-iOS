//
//  BkAlertManager.swift
//  CommonFeature
//
//  Created by kyuchul on 8/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

@MainActor
public final class BkAlertManager: ObservableObject {
  public static let shared = BkAlertManager()
  private init() {}
  
  @Published var isPresented: Bool = false
  private(set) var property: [BKAlertProperty] = []
  private var continuation: CheckedContinuation<Void, Never>?
  
  
  public func present(_ property: BKAlertProperty) async {
    self.property.append(property)
    self.isPresented = true
    return await withCheckedContinuation { continuation in
      self.continuation = continuation
    }
  }
  
  public func dismiss() {
    isPresented = false
    property.removeAll()
    continuation?.resume()
    continuation = nil
  }
}
