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
    case green
    case red
    case yellow
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
        case .green: return CommonFeatureAsset.Colors.systemGreen.color
        case .red: return CommonFeatureAsset.Colors.systemRed.color
        case .yellow: return CommonFeatureAsset.Colors.systemYellow.color
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
        case .green: return CommonFeatureAsset.Colors.systemGreen.swiftUIColor
        case .red: return CommonFeatureAsset.Colors.systemRed.swiftUIColor
        case .yellow: return CommonFeatureAsset.Colors.systemYellow.swiftUIColor
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

