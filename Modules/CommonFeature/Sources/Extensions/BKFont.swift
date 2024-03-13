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

public protocol FontSizeProtocol {
    var rawValue: CGFloat { get }
}

public extension BKFont {
    enum DisplaySize: CGFloat, FontSizeProtocol {
        case Display1 = 56
        case Display2 = 48
        case Display3 = 40
        case Display4 = 36
        case Display5 = 32
        case Display6 = 28
    }
    
    enum HeadlineSize: CGFloat, FontSizeProtocol {
        case Headline1 = 32
        case Headline2 = 28
        case Headline3 = 24
        case Headline4 = 20
        case Headline5 = 18
        case Headline6 = 16
    }
    
    enum TitileSize: CGFloat, FontSizeProtocol {
        case Titile1 = 24
        case Titile2 = 20
        case Titile3 = 18
        case Titile4 = 16
    }
    
    enum BodySize: CGFloat, FontSizeProtocol {
        case Body1 = 15
        case Body2 = 14
        case Body3 = 13
        case Body4 = 12
    }
    
    enum CaptionSize: CGFloat, FontSizeProtocol {
        case Caption1 = 13
        case Caption2 = 12
        case Caption3 = 11
    }
    
    enum BtntxtSize: CGFloat, FontSizeProtocol {
        case Btntxt1 = 16
        case Btntxt2 = 14
        case Btntxt3 = 13
        case Btntxt4 = 12
    }
}

public extension UIFont {
    static func light<S: FontSizeProtocol>(size: S) -> UIFont {
        return BKFont.Light.fontName(size: size.rawValue)
    }
    
    static func regular<S: FontSizeProtocol>(size: S) -> UIFont {
        return BKFont.Regular.fontName(size: size.rawValue)
    }
    
    static func semiBold<S: FontSizeProtocol>(size: S) -> UIFont {
        return BKFont.SemiBold.fontName(size: size.rawValue)
    }
}

public extension Font {
    static func light<S: FontSizeProtocol>(size: S) -> Font {
        return BKFont.Light.fontName(size: size.rawValue)
    }
    
    static func regular<S: FontSizeProtocol>(size: S) -> Font {
        return BKFont.Regular.fontName(size: size.rawValue)
    }
    
    static func semiBold<S: FontSizeProtocol>(size: S) -> Font {
        return BKFont.SemiBold.fontName(size: size.rawValue)
    }
}
