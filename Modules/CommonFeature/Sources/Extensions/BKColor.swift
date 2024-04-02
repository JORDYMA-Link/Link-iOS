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
}

public extension BKColor {
    var color: UIColor {
        switch self {
        case .black: return CommonFeatureAsset.Colors.systemBlack.color
        case .white: return CommonFeatureAsset.Colors.systemWhite.color
        case .gray300: return CommonFeatureAsset.Colors.gray300.color
        case .gray400: return CommonFeatureAsset.Colors.gray400.color
        case .gray500: return CommonFeatureAsset.Colors.gray500.color
        case .gray600: return CommonFeatureAsset.Colors.gray600.color
        case .gray700: return CommonFeatureAsset.Colors.gray700.color
        case .gray800: return CommonFeatureAsset.Colors.gray800.color
        case .gray900: return CommonFeatureAsset.Colors.gray900.color
        case .green: return CommonFeatureAsset.Colors.systemGreen.color
        case .red: return CommonFeatureAsset.Colors.systemRed.color
        case .yellow: return CommonFeatureAsset.Colors.systemYellow.color
        case .main900: return CommonFeatureAsset.Colors.main900.color
        case .main800: return CommonFeatureAsset.Colors.main800.color
        case .main700: return CommonFeatureAsset.Colors.main700.color
        case .main600: return CommonFeatureAsset.Colors.main600.color
        case .main500: return CommonFeatureAsset.Colors.main500.color
        case .main400: return CommonFeatureAsset.Colors.main400.color
        case .main300: return CommonFeatureAsset.Colors.main300.color
        case .main200: return CommonFeatureAsset.Colors.main200.color
        case .main100: return CommonFeatureAsset.Colors.main100.color
        case .main50: return CommonFeatureAsset.Colors.main50.color
        }
    }

    var swiftUIColor: Color {
        switch self {
        case .black: return CommonFeatureAsset.Colors.systemBlack.swiftUIColor
        case .white: return CommonFeatureAsset.Colors.systemWhite.swiftUIColor
        case .gray300: return CommonFeatureAsset.Colors.gray300.swiftUIColor
        case .gray400: return CommonFeatureAsset.Colors.gray400.swiftUIColor
        case .gray500: return CommonFeatureAsset.Colors.gray500.swiftUIColor
        case .gray600: return CommonFeatureAsset.Colors.gray600.swiftUIColor
        case .gray700: return CommonFeatureAsset.Colors.gray700.swiftUIColor
        case .gray800: return CommonFeatureAsset.Colors.gray800.swiftUIColor
        case .gray900: return CommonFeatureAsset.Colors.gray900.swiftUIColor
        case .green: return CommonFeatureAsset.Colors.systemGreen.swiftUIColor
        case .red: return CommonFeatureAsset.Colors.systemRed.swiftUIColor
        case .yellow: return CommonFeatureAsset.Colors.systemYellow.swiftUIColor
        case .main900: return CommonFeatureAsset.Colors.main900.swiftUIColor
        case .main800: return CommonFeatureAsset.Colors.main800.swiftUIColor
        case .main700: return CommonFeatureAsset.Colors.main700.swiftUIColor
        case .main600: return CommonFeatureAsset.Colors.main600.swiftUIColor
        case .main500: return CommonFeatureAsset.Colors.main500.swiftUIColor
        case .main400: return CommonFeatureAsset.Colors.main400.swiftUIColor
        case .main300: return CommonFeatureAsset.Colors.main300.swiftUIColor
        case .main200: return CommonFeatureAsset.Colors.main200.swiftUIColor
        case .main100: return CommonFeatureAsset.Colors.main100.swiftUIColor
        case .main50: return CommonFeatureAsset.Colors.main50.swiftUIColor
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

