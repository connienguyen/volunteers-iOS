//
//  SettingsViewModel.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/4/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

enum UserSetting {
    case theme
    case connectedLogins

    var cellType: UITableViewCell.Type {
        switch self {
        case .theme:
            return UITableViewCell.self
        case .connectedLogins:
            return ManageLoginsCell.self
        }
    }
}

class SettingsViewModel {
    static let loggedInSettings: [UserSetting] = [.theme, .connectedLogins]
    static let notLoggedInSettings: [UserSetting] = [.theme]
    var availableSettings: [UserSetting] {
        return DataManager.shared.isLoggedIn ? SettingsViewModel.loggedInSettings : SettingsViewModel.notLoggedInSettings
    }
}
