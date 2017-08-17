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
    case normal
    case colorblind

    static let availableThemes: [Theme] = [.normal, .colorblind]

    /// Name of theme to display in Settings
    var themeName: String {
        switch self {
        case .normal:
            return "default-theme.title.label".localized
        case .colorblind:
            return "colorblind-theme.title.label".localized
        }
    }

    /// Main color of the app; used for navigational elements
    var primaryColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.marineBlue
        case .colorblind:
            return ThemeColors.richBlack
        }
    }

    /// Secondary color used in app for elements like buttons and labels
    var secondaryColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.emerald
        case .colorblind:
            return ThemeColors.mediumGrey
        }
    }

    /// Accent color for app used where primary and secondary colors do no apply
    var accentColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.tangerine
        case .colorblind:
            return ThemeColors.mediumGrey
        }
    }

    /// Color for displaying errors
    var errorColor: UIColor {
        return ThemeColors.crimson
    }

    /// Color for clickable elements on navbar; color for active tab on tabbar
    var tintColor: UIColor {
        switch self {
        case .normal, .colorblind:
            return ThemeColors.white
        }
    }

    /// Contrasting tint color for elements on tab bar not currently active
    var tintContrastColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.caribbean
        case .colorblind:
            return ThemeColors.white
        }
    }

    /// Color for body text in app
    var textColor: UIColor {
        switch self {
        case .normal, .colorblind:
            return ThemeColors.richBlack
        }
    }

    /// Color for clickable links in app
    var linkColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.tangerine
        case .colorblind:
            return ThemeColors.crimson
        }
    }

    /// Color used for icon elements
    var iconColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.white
        case .colorblind:
            return ThemeColors.crimson
        }
    }

    /// Color used for button elements
    var buttonColor: UIColor {
        switch self {
        case .normal:
            return ThemeColors.emerald
        case .colorblind:
            return ThemeColors.crimson
        }
    }

    /// Color for input borders
    var inputBorderColor: UIColor {
        switch self {
        case .normal, .colorblind:
            return ThemeColors.lightGrey
        }
    }

    /// Bar style of status bar for theme
    var barStyle: UIBarStyle {
        switch self {
        case .normal, .colorblind:
            return .black
        }
    }
}
