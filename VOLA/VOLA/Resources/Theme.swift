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
    // TODO: Add dark theme for accessibility
    case normal

    /// Main color of the app; used for navigational elements
    var primaryColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.sublime
        }
    }

    /// Secondary color used in app for elements like buttons and labels
    var secondaryColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.caribbean
        }
    }

    /// Accent color for app used where primary and secondary colors do no apply
    var accentColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.tangerine
        }
    }

    /// Color for displaying errors
    var errorColor: UIColor {
        return ThemeColors.crimson
    }

    /// Color for clickable elements on navbar; color for active tab on tabbar
    var tintColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.white
        }
    }

    /// Contrasting tint color for elements on tab bar not currently active
    var tintContrastColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.emerald
        }
    }

    /// Color for body text in app
    var textColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.richBlack
        }
    }

    /// Color for clickable links in app
    var linkColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.caribbean
        }
    }

    /// Bar style of status bar for theme
    var barStyle: UIBarStyle {
        switch self {
        case .normal:
            return .black
        }
    }
}
