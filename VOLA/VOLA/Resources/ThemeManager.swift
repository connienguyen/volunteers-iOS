//
//  ThemeManager.swift
//  VOLA
//
//  ThemeManager is responsible for keeping track of the current theme
//  and applying changes when the theme is changed.
//
//  Created by Connie Nguyen on 7/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

final class ThemeManager {
    static let shared = ThemeManager()

    private var _currentTheme: Theme

    var currentTheme: Theme {
        return _currentTheme
    }

    private init() {
        if let storedThemeValue = Defaults.getObject(forKey: .selectedTheme) as? Int,
            let selectedTheme = Theme(rawValue: storedThemeValue) {
            _currentTheme = selectedTheme
        } else {
            _currentTheme = .normal
        }
    }

    func applyTheme(theme: Theme) {
        Defaults.setObject(forKey: .selectedTheme, object: theme.rawValue)

        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.tintColor
        UINavigationBar.appearance().setBackgroundImage(theme.navigationBackgroundImage, for: .default)
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().backgroundColor = theme.primaryColor

        UITabBar.appearance().backgroundImage = theme.navigationBackgroundImage
        UITabBar.appearance().backgroundColor = theme.primaryColor

        VLButton.appearance().backgroundColor = theme.secondaryColor
    }
}
