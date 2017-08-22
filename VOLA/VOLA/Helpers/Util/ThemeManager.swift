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
    private var appliedTheme: Theme?

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
    Change theme and apply changes to UI immediately. Can be used to preview a theme.
    
    - Parameters:
        - theme: New theme
    */
    func apply(_ theme: Theme = ThemeManager.shared.currentTheme) {
        guard theme != appliedTheme else {
            // Only apply changes to UI if theme is different than currently applied theme
            return
        }

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
                NSForegroundColorAttributeName: theme.iconColor
            ], for: .selected)

        VLButton.appearance().backgroundColor = theme.buttonColor
        VLButton.appearance().tintColor = theme.tintColor
        VLSegmentedControl.appearance().tintColor = theme.buttonColor

        VolunteersNeededLabel.appearance().backgroundColor = theme.accentColor
        VolunteersNeededLabel.appearance().textColor = theme.tintColor
        RegisteredLabel.appearance().textColor = theme.tintColor
        TitleLabel.appearance().textColor = theme.textColor
        TextLabel.appearance().textColor = theme.textColor
        CircleImageView.appearance().backgroundColor = theme.accentColor

        VLInputTextView.appearance().borderColor = theme.inputBorderColor

        // Remove and re-add subviews so that theme is applied to already created UIView instances
        for window in UIApplication.shared.windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }

        appliedTheme = theme
    }

    /**
    Save a theme to user defaults; used after previewing a theme.
     
    - Paramters:
        - theme: Theme to save
    */
    func saveTheme(_ theme: Theme) {
        Defaults.setObject(forKey: .selectedTheme, object: theme.rawValue)
        _currentTheme = theme

        // Post notification so UI elemented not affected by UIAppearance proxy changes are
        // updated to match theme
        NotificationCenter.default.post(name: NotificationName.themeDidChange, object: nil)
    }
}
