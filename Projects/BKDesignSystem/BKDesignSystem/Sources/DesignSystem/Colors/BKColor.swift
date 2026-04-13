//
//  BKColor.swift
//  CommonFeature
//
//  Created by Kooky macBook Air on 3/12/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import UIKit
import SwiftUI

public enum BKColor: Equatable, Hashable {
    case black
    case white
    case gray300
    case gray400 
    case gray500
    case gray600
    case gray700
    case gray800
    case gray900
    case green
    case lightRed
    case red
    case yellow
    case main900
    case main800
    case main700
    case main600
    case main500
    case main400
    case main300
    case main200
    case main100
    case main50
    case gradient400
    case gradient300
    case gradient200
    case gradient100
    case kakaoYellow
}

public extension BKColor {
    var color: UIColor {
        switch self {
        case .black: return BKDesignSystem.Colors.systemBlack.uiColor
        case .white: return BKDesignSystem.Colors.systemWhite.uiColor
        case .gray300: return BKDesignSystem.Colors.gray300.uiColor
        case .gray400: return BKDesignSystem.Colors.gray400.uiColor
        case .gray500: return BKDesignSystem.Colors.gray500.uiColor
        case .gray600: return BKDesignSystem.Colors.gray600.uiColor
        case .gray700: return BKDesignSystem.Colors.gray700.uiColor
        case .gray800: return BKDesignSystem.Colors.gray800.uiColor
        case .gray900: return BKDesignSystem.Colors.gray900.uiColor
        case .green: return BKDesignSystem.Colors.systemGreen.uiColor
        case .lightRed: return BKDesignSystem.Colors.systemLightRed.uiColor
        case .red: return BKDesignSystem.Colors.systemRed.uiColor
        case .yellow: return BKDesignSystem.Colors.systemYellow.uiColor
        case .main900: return BKDesignSystem.Colors.main900.uiColor
        case .main800: return BKDesignSystem.Colors.main800.uiColor
        case .main700: return BKDesignSystem.Colors.main700.uiColor
        case .main600: return BKDesignSystem.Colors.main600.uiColor
        case .main500: return BKDesignSystem.Colors.main500.uiColor
        case .main400: return BKDesignSystem.Colors.main400.uiColor
        case .main300: return BKDesignSystem.Colors.main300.uiColor
        case .main200: return BKDesignSystem.Colors.main200.uiColor
        case .main100: return BKDesignSystem.Colors.main100.uiColor
        case .main50: return BKDesignSystem.Colors.main50.uiColor
        case .gradient400: return BKDesignSystem.Colors.gradient400.uiColor
        case .gradient300: return BKDesignSystem.Colors.gradient300.uiColor
        case .gradient200: return BKDesignSystem.Colors.gradient200.uiColor
        case .gradient100: return BKDesignSystem.Colors.gradient100.uiColor
        case .kakaoYellow: return BKDesignSystem.Colors.kakaoYellow.uiColor
        }
    }

    var swiftUIColor: Color {
        switch self {
        case .black: return BKDesignSystem.Colors.systemBlack
        case .white: return BKDesignSystem.Colors.systemWhite
        case .gray300: return BKDesignSystem.Colors.gray300
        case .gray400: return BKDesignSystem.Colors.gray400
        case .gray500: return BKDesignSystem.Colors.gray500
        case .gray600: return BKDesignSystem.Colors.gray600
        case .gray700: return BKDesignSystem.Colors.gray700
        case .gray800: return BKDesignSystem.Colors.gray800
        case .gray900: return BKDesignSystem.Colors.gray900
        case .green: return BKDesignSystem.Colors.systemGreen
        case .lightRed: return BKDesignSystem.Colors.systemLightRed
        case .red: return BKDesignSystem.Colors.systemRed
        case .yellow: return BKDesignSystem.Colors.systemYellow
        case .main900: return BKDesignSystem.Colors.main900
        case .main800: return BKDesignSystem.Colors.main800
        case .main700: return BKDesignSystem.Colors.main700
        case .main600: return BKDesignSystem.Colors.main600
        case .main500: return BKDesignSystem.Colors.main500
        case .main400: return BKDesignSystem.Colors.main400
        case .main300: return BKDesignSystem.Colors.main300
        case .main200: return BKDesignSystem.Colors.main200
        case .main100: return BKDesignSystem.Colors.main100
        case .main50: return BKDesignSystem.Colors.main50
        case .gradient400: return BKDesignSystem.Colors.gradient400
        case .gradient300: return BKDesignSystem.Colors.gradient300
        case .gradient200: return BKDesignSystem.Colors.gradient200
        case .gradient100: return BKDesignSystem.Colors.gradient100
        case .kakaoYellow: return BKDesignSystem.Colors.kakaoYellow
        }
    }
}

extension UIColor {
    public static func bkColor(_ ybColor: BKColor) -> UIColor {
        return ybColor.color
    }
}

extension Color {
    public static func bkColor(_ ybColor: BKColor) -> Color {
        return ybColor.swiftUIColor
    }
}

extension Color {
  public var uiColor: UIColor {
    return UIColor(self)
  }
}
