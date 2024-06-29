//
//  CustomCalendarHeaderView.swift
//  Features
//
//  Created by 문정호 on 6/29/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import FSCalendar

final class CustomCalendarHeaderView: FSCalendarHeaderView {
  //MARK: - Properties
  private let monthButton = {
    let button = UIButton(frame: .zero)
    var config = UIButton.Configuration.plain()
    config.title = "아나 시발 왜 안돼"
    config.imagePlacement = .trailing
    config.baseForegroundColor = .bkColor(.gray900)
    config.image = UIImage(systemName: "chevron.down")
    button.configuration = config
    return button
  }()
  
  
  //MARK: - initialization
  init(frame: CGRect, title: String) {
    super.init(frame: frame)
    configureLayout(title: title)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - FScalendar Method
  
  //MARK: - Helper
  private func configureLayout(title: String) {
    self.addSubview(monthButton)
    setCurrentPageTitle(currentPage: title)
    
    monthButton.translatesAutoresizingMaskIntoConstraints = true
    
    NSLayoutConstraint.activate([
      monthButton.topAnchor.constraint(equalTo: self.topAnchor),
      monthButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      monthButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
      monthButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
  
  public func setCurrentPageTitle(currentPage: String) {
    self.monthButton.setTitle(currentPage, for: .normal)
  }
}
