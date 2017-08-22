//
//  VLTabBarController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/10/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/// Tab bar controller for main navigation of the app
class VLTabBarController: UITabBarController {
    /**
        Items on the tab bar navigation
     
        - calendar: Tab for viewing events the user has registered for and has coming up
        - home: Tab for viewing and searching for nearby events
        - profile: Tab for viewing and editing the user profile
    */
    enum TabBarNav: Int {
        case calendar
        case home
        case profile

        static let availableTabs: [TabBarNav] = [.calendar, .home, .profile]

        /// Name of image to appear on a given tab
        var imageName: String {
            switch self {
            case .calendar:
                return "Calendar_icon"
            case .home:
                return "Location_icon"
            case .profile:
                return "Avatar_icon"
            }
        }

        /// Localized title to appear on tab
        var localizedTitle: String {
            var title: String
            switch self {
            case .calendar:
                title = "calendar.title.label"
            case .home:
                title = "home.title.label"
            case .profile:
                title = "profile.title.label"
            }
            return title.localized
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = TabBarNav.home.rawValue
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Watch for notification that the theme has changed since the configured tab bar
        // is not affected by the UIAppearance proxy changes by the ThemeManager
        addNotificationObserver(NotificationName.themeDidChange, selector: #selector(configureTabBar), nil)
        configureTabBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeNotificationObserver(NotificationName.themeDidChange)
    }

    deinit {
        removeNotificationObserver(NotificationName.themeDidChange)
    }

    /// Configure the display of the tab bar with images and titles for each tab
    func configureTabBar() {
        guard let tabBarItems = tabBar.items else {
            return
        }

        let selectedColor = ThemeManager.shared.currentTheme.iconColor
        let unselectedColor = ThemeManager.shared.currentTheme.tintContrastColor
        for i in 0..<tabBarItems.count {
            let item = tabBarItems[i]
            let nav = TabBarNav.availableTabs[i]
            item.title = nav.localizedTitle
            let selectedImage = UIImage(named: nav.imageName)?.maskWithColor(selectedColor)
            let unselectedImage = UIImage(named: nav.imageName)?.maskWithColor(unselectedColor)
            item.image = unselectedImage?.withRenderingMode(.alwaysOriginal)
            item.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        }
    }
}
