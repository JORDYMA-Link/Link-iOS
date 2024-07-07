//
//  BKFont.swift
//  CommonFeature
//
//  Created by Kooky macBook Air on 3/12/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import UIKit
import SwiftUI

public enum BKFont {
    case SemiBold
    case Regular
    case Light
    
    fileprivate func fontName(size: CGFloat) -> UIFont {
        switch self {
        case .SemiBold: return CommonFeatureFontFamily.Pretendard.semiBold.font(size: size)
        case .Regular: return CommonFeatureFontFamily.Pretendard.regular.font(size: size)
        case .Light: return CommonFeatureFontFamily.Pretendard.light.font(size: size)
        }
    }
    
    fileprivate func fontName(size: CGFloat) -> Font {
        switch self {
        case .SemiBold: return CommonFeatureFontFamily.Pretendard.semiBold.swiftUIFont(size: size)
        case .Regular: return CommonFeatureFontFamily.Pretendard.regular.swiftUIFont(size: size)
        case .Light: return CommonFeatureFontFamily.Pretendard.light.swiftUIFont(size: size)
        }
    }
}

public extension CGFloat {
    enum Size: CGFloat {
        case _56 = 56
        case _48 = 48
        case _40 = 40
        case _36 = 36
        case _32 = 32
        case _28 = 28
        case _24 = 24
        case _20 = 20
        case _18 = 18
        case _16 = 16
        case _15 = 15
        case _14 = 14
        case _13 = 13
        case _12 = 12
        case _11 = 11
    }
}

public extension UIFont {
    static func light(size: CGFloat.Size) -> UIFont {
        return BKFont.Light.fontName(size: size.rawValue)
    }
    
    static func regular(size: CGFloat.Size) -> UIFont {
        return BKFont.Regular.fontName(size: size.rawValue)
    }
    
    static func semiBold(size: CGFloat.Size) -> UIFont {
        return BKFont.SemiBold.fontName(size: size.rawValue)
    }
}

public extension Font {
    static func light(size: CGFloat.Size) -> Font {
        return BKFont.Light.fontName(size: size.rawValue)
    }
    
    static func regular(size: CGFloat.Size) -> Font {
        return BKFont.Regular.fontName(size: size.rawValue)
    }
    
    static func semiBold(size: CGFloat.Size) -> Font {
        return BKFont.SemiBold.fontName(size: size.rawValue)
    }
}

public struct TextLineHeight: ViewModifier {
  private let font: UIFont
  private let lineHeight: CGFloat
  
  public init(font: UIFont, lineHeight: CGFloat) {
    self.font = font
    self.lineHeight = lineHeight
  }
  
  public func body(content: Content) -> some View {
    content
      .padding(.vertical, (lineHeight - font.lineHeight) / 2)
  }
}

public extension Text {
    func lineHeight(font: UIFont, lineHeight: CGFloat) -> some View {
        self.modifier(TextLineHeight(font: font, lineHeight: lineHeight))
    }
}
