//
//  HomeViewController.swift
//  Features
//
//  Created by Kooky macBook Air on 2/12/24.
//  Copyright © 2024 kyuchul. All rights reserved.
//

import UIKit

import CommonFeature

import RealmSwift
import RxSwift

public final class HomeViewController: BaseViewController {
    
    private let viewModel: HomeViewModel
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadCoinData()
    }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
