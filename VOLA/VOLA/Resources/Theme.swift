//
//  Theme.swift
//  VOLA
//
//  Theme is responsible for a stylized appearance.
//
//  Created by Connie Nguyen on 7/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

import Foundation
import UIKit

enum Theme: Int {
    case normal     // TODO: Add dark theme for accessibility

    var primaryColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.sublime
        }
    }

    var secondaryColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.caribbean
        }
    }

    var accentColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.tangerine
        }
    }

    var errorColor: UIColor {
        return ThemeColors.crimson
    }

    var tintColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.white
        }
    }

    var textColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.richBlack
        }
    }

    var linkColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.caribbean
        }
    }

    var barStyle: UIBarStyle {
        switch self {
        case .normal:
            return .black
        }
    }

    var navigationBackgroundImage: UIImage? {
        switch self {
        case .normal:
            // Return empty UIImage to remove gradient from navBar
            return UIImage()
        }
    }
}
