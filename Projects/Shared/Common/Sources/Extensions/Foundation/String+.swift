//
//  String+.swift
//  CommonFeature
//
//  Created by 문정호 on 5/6/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import UIKit
import SwiftUI

extension String {
  public var isHTTPURL: Bool {
    if let url = URL(string: self.lowercased()), url.host != nil {
      return UIApplication.shared.canOpenURL(url as URL)
    }
    return false
  }
    
  public var isYouTubeOrInstagramURL: Bool {
    guard let url = URL(string: self.lowercased()),
          let urlHost = url.host() else {
      return false
    }
    
    return urlHost.contains("youtube.com") || urlHost.contains("instagram.com")
  }
  
  public var containsOtherLanguage: Bool {
    // 한글 조합형 문자 (음절) 유니코드 범위
    let koreanSyllablesRange = Unicode.Scalar("\u{AC00}")...Unicode.Scalar("\u{D7A3}")
    // 한글 자모 유니코드 범위
    let koreanJamoRange = Unicode.Scalar("\u{1100}")...Unicode.Scalar("\u{11FF}")
    // 한글 자음 유니코드 범위
    let koreanConsonantsRange = Unicode.Scalar("\u{3131}")...Unicode.Scalar("\u{314E}")
    // 한글 모음 유니코드 범위
    let koreanVowelsRange = Unicode.Scalar("\u{314F}")...Unicode.Scalar("\u{3163}")
    
    // 위 범위들을 포함하는 문자 집합 생성
    let koreanCharacterSet = CharacterSet(charactersIn: koreanSyllablesRange)
      .union(CharacterSet(charactersIn: koreanJamoRange))
      .union(CharacterSet(charactersIn: koreanConsonantsRange))
      .union(CharacterSet(charactersIn: koreanVowelsRange))
    
    // 문자열이 한글만 포함하고 있는지 확인 (한글 이외의 문자를 포함하면 false 반환)
    return !self.unicodeScalars.allSatisfy { koreanCharacterSet.contains($0) }
  }
  
  public var containsEmoji: Bool {
    for scalar in self.unicodeScalars {
      if scalar.properties.isEmoji {
        return true
      }
    }
    return false
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
  
  public func toDate(from dateFormat: String) -> Date? {
    // DateFormatter 생성 및 설정
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale.current

    // 문자열을 Date로 변환
    return dateFormatter.date(from: self)
  }
}

public extension String {
  /// String 시작과 끝 공백 체크
  func isValidLeadingTrailingWhitespace() -> Bool {
    return self.hasPrefix(" ") || self.hasSuffix(" ")
  }
}

public extension String {
  func parseBoldString(
    font: Font? = nil,
    color: Color? = nil
  ) -> AttributedString {
    let pattern = "\\*\\*(.*?)\\*\\*"
    let regex = try! NSRegularExpression(pattern: pattern)
    
    let cleanText = self.replacingOccurrences(of: "**", with: "")
    var attributedString = AttributedString(cleanText)
    
    let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
    
    for match in matches {
      if let range = Range(match.range(at: 1), in: self) {
        let boldText = String(self[range])
        
        if let startRange = cleanText.range(of: boldText) {
          let startIndex = cleanText.distance(from: cleanText.startIndex, to: startRange.lowerBound)
          let length = boldText.count
          
          if let attributedRange = Range(NSRange(location: startIndex, length: length), in: attributedString) {
            
            if let font = font {
              attributedString[attributedRange].font = font
            }
            
            if let color = color {
              attributedString[attributedRange].foregroundColor = color
            }
          }
        }
      }
    }
    
    return attributedString
  }
}
