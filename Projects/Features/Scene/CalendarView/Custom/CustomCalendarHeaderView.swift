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
    config.title = "아나 왜 안돼"
    config.image = UIImage(systemName: "chevron.down")
    config.imagePlacement = .trailing
    config.baseForegroundColor = .bkColor(.gray900)
    button.configuration = config
    return button
  }()
  
  
  //MARK: - initialization
  init(frame: CGRect, calendar: FSCalendar) {
    super.init(frame: frame)
    self.calendar = calendar
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - FScalendar Method
  override func configureAppearance() {
    self.addSubview(monthButton)
    setCurrentPageTitle(currentPage: calendar.currentPage.toStringYearMonth)

    monthButton.translatesAutoresizingMaskIntoConstraints = true
    
    NSLayoutConstraint.activate([
      monthButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      monthButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
    ])
  }
  
  override func reloadData() {
    debugPrint(String(describing: self), #function)
    super.reloadData()
    
    guard let currentPage = calendar?.currentPage else { return }
    
    self.monthButton.setTitle(currentPage.toStringYearMonth, for: .normal)
  }
  
  //MARK: - Helpe
  public func setCurrentPageTitle(currentPage: String) {
    self.monthButton.setTitle(currentPage, for: .normal)
  }
}
