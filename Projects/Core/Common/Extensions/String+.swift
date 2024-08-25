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
  
  public var containsOtherLanguage: Bool {
    let pattern = "[^가-힣]" // 한국어가 아닌 문자
    if let _ = self.range(of: pattern, options: .regularExpression) {
        return true // 한국어가 아닌 문자가 포함되어 있음
    } else {
        return false // 오직 한국어만 포함되어 있음
    }
  }
  
  public var containsEmoji: Bool {
      let pattern = "[\\u{1F600}-\\u{1F64F}]|[\\u{1F300}-\\u{1F5FF}]|[\\u{1F680}-\\u{1F6FF}]|[\\u{1F700}-\\u{1F77F}]|[\\u{1F780}-\\u{1F7FF}]|[\\u{1F800}-\\u{1F8FF}]|[\\u{1F900}-\\u{1F9FF}]|[\\u{1FA00}-\\u{1FA6F}]|[\\u{1FA70}-\\u{1FAFF}]|[\\u{2600}-\\u{26FF}]|[\\u{2700}-\\u{27BF}]"
      if let _ = self.range(of: pattern, options: .regularExpression) {
          return true // 이모티콘이 포함되어 있음
      } else {
          return false // 이모티콘이 없음
      }
  }
  
  public var containsWhitespace: Bool {
      let pattern = "\\s"
      if let _ = self.range(of: pattern, options: .regularExpression) {
          return true // 공백이 포함되어 있음
      } else {
          return false // 공백이 없음
      }
  }
  
  public func calculateHeight(font: UIFont, width: CGFloat) -> CGFloat {
    let attributedText = NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font])
    
    let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    
    let boundingRect = attributedText.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
    
    return ceil(boundingRect.height)
  }
}
