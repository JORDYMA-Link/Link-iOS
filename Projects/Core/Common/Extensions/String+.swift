//
//  String+.swift
//  CommonFeature
//
//  Created by 문정호 on 5/6/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import UIKit

extension String {
  public var containsHTTPorHTTPS: Bool {
    return self.lowercased().hasPrefix("http") || self.lowercased().hasPrefix("https")
  }
  
  public var containsOnlyKorean: Bool {
      let regex = "^[가-힣]+$"
      return self.range(of: regex, options: .regularExpression) != nil
  }
  
  public func calculateHeight(font: UIFont, width: CGFloat) -> CGFloat {
    let attributedText = NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font])
    
    let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    
    let boundingRect = attributedText.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
    
    return ceil(boundingRect.height)
  }
}
