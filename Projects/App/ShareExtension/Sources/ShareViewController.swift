//
//  ShareViewController.swift
//  SharedExtension
//
//  Created by 김규철 on 5/16/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import UIKit
import Models

import ComposableArchitecture


@objc(ShareViewController)
class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ShareViewController viewDidLoad called")
        
        view.backgroundColor = UIColor.systemBackground
        
        let label = UILabel()
        label.text = "Blink 공유 화면"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("닫기", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20)
        ])
        
        print("ShareViewController UI setup completed")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ShareViewController viewDidAppear called")
    }
    
    @objc private func closeButtonTapped() {
        print("Close button tapped")
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
