//
//  SaveLinkViewModel.swift
//  Blink
//
//  Created by 문정호 on 4/29/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation
import UIKit
import Combine

import Common
import CommonFeature

final class SaveLinkViewModel: ViewModelable {
    enum Action {
        case onTapNextButton
        case onTapBackButton
    }
    
  enum State: Equatable {
        case buttonActivate(value: Bool)
        case presentLoadingAlert(valueToggle: Bool)
        case notValidationURL
        case dismiss
        case none
    }
    
    @Published var state: State
    @Published var urlText: String = ""
    @Published var presentLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(state: State = .none, urlText: String = "") {
        self.state = state
        bind()
    }
    
    func action(_ action: Action) {
        switch action {
        case .onTapNextButton:
            if urlText.containsHTTPorHTTPS {
                state = .presentLoadingAlert(valueToggle: togglePresentLoading())
                print("present LoadingAler")
            } else {
                state = .notValidationURL
                print("not validation")
            }
        case .onTapBackButton:
            state = .dismiss
        }
    }
    
    private func bind() {
        _urlText.projectedValue.sink { completion in
            switch completion {
            case .failure(let failure):
                print("failure: \(failure)")
            default:
                print("finished")
            }
        } receiveValue: { [weak self] string in
          guard let self else {return}
          if string.isEmpty {
            self.state = .buttonActivate(value: false)
          } else {
            self.state = .buttonActivate(value: true)
          }
        }
        .store(in: &cancellables)
    }
    
    private func togglePresentLoading() -> Bool {
        presentLoading.toggle()
        return presentLoading
    }
    
}
