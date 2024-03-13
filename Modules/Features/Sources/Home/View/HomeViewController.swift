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
    private let label: UILabel = {
        let label = UILabel()
        label.text = "비트코인 2억간다."
        label.font = .semiBold(size: BKFont.DisplaySize.Display1)
        label.textColor = .bkColor(.white)
        return label
    }()
    
    private let viewModel: HomeViewModel
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadCoinData()
        
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
