//
//  ThemeManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

/// Manager responsible for keeping track of current theme and applying changes when the theme is changed
final class ThemeManager {
    static let shared = ThemeManager()

    private var _currentTheme: Theme

    private init() {
        if let storedThemeValue = Defaults.getObject(forKey: .selectedTheme) as? Int,
            let selectedTheme = Theme(rawValue: storedThemeValue) {
            _currentTheme = selectedTheme
        } else {
            _currentTheme = .normal
        }
    }

    /// Publicly accessible current theme property for read purposes
    var currentTheme: Theme {
        return _currentTheme
    }

    /**
    Change theme and apply changes to UI immediately
    
    - Parameters:
        - theme: New theme
    */
    func applyTheme(theme: Theme) {
        Defaults.setObject(forKey: .selectedTheme, object: theme.rawValue)
        _currentTheme = theme

        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().backgroundColor = theme.primaryColor
        UINavigationBar.appearance().tintColor = theme.tintColor
        UINavigationBar.appearance().barTintColor = theme.primaryColor

        UITabBar.appearance().barTintColor = theme.primaryColor
        UITabBar.appearance().backgroundColor = theme.primaryColor
        UITabBarItem.appearance().setTitleTextAttributes([
                NSForegroundColorAttributeName: theme.tintContrastColor
            ], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([
                NSForegroundColorAttributeName: theme.tintColor
            ], for: .selected)

        VLButton.appearance().backgroundColor = theme.secondaryColor
        VLButton.appearance().tintColor = theme.tintColor

        VolunteersNeededLabel.appearance().backgroundColor = theme.accentColor
        TitleLabel.appearance().textColor = theme.textColor
        TextLabel.appearance().textColor = theme.textColor
    }
}
