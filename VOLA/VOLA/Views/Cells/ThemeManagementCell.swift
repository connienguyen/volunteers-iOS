//
//  ThemeManagementCell.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/17/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/// Table view that allows users to change the color theme of the app
class ThemeManagementCell: UITableViewCell {
    @IBOutlet weak var segmentedThemeControl: VLSegmentedControl!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Configure display for segmented control
        for theme in Theme.availableThemes {
            segmentedThemeControl.setTitle(theme.themeName, forSegmentAt: theme.rawValue)
        }
        segmentedThemeControl.selectedSegmentIndex = ThemeManager.shared.currentTheme.rawValue
    }
}

// MARK: - IBActions
extension ThemeManagementCell {
    @IBAction func onSegmentedControlSelect(sender: AnyObject) {
        let currentTheme = ThemeManager.shared.currentTheme
        guard let theme = Theme(rawValue: segmentedThemeControl.selectedSegmentIndex),
            currentTheme.rawValue != segmentedThemeControl.selectedSegmentIndex else {
            // Using guard let to avoid using ?? syntax
            // Do not need to change theme if selection is the same as the current theme
            return
        }

        // Future improvement: apply theme as a preview and save changes
        // to currentTheme after user approves preview
        ThemeManager.shared.apply(theme)
        ThemeManager.shared.saveTheme(theme)

        // Post notification so UI elemented not affected by UIAppearance proxy changes are
        // updated to match theme
        NotificationCenter.default.post(name: NotificationName.themeDidChange, object: nil)
    }
}
