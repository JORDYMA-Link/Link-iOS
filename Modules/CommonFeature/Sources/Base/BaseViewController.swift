//
//  BaseViewController.swift
//  ProjectDescriptionHelpers
//
//  Created by Kooky macBook Air on 2/21/24.
//

import UIKit

import SnapKit
import RxSwift

open class BaseViewController: UIViewController {
    open var disposeBag = DisposeBag()
    
    public init() {
         super.init(nibName: nil, bundle: nil)
     }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
#if DEBUG
        view.backgroundColor = .bkColor(.red)
#endif
    }
}


