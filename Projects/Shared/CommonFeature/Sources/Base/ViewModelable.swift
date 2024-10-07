//
//  ViewModelable.swift
//  CommonFeature
//
//  Created by 김규철 on 2024/04/08.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI
import Combine

public protocol ViewModelable: ObservableObject {
  associatedtype Action
  associatedtype State
  
  var state: State { get }
  
  func action(_ action: Action)
}
