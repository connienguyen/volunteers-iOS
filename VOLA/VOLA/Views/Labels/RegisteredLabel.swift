//
//  RegisteredLabel.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/8/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/// Stylized label to display user's event registration status
class RegisteredLabel: UILabel {
    /// Change label styling according to event registration status
    var eventType: EventType = .unregistered {
        willSet {
            text = newValue.labelText
            switch newValue {
            case .registered:
                isHidden = false
                backgroundColor = ThemeManager.shared.currentTheme.secondaryColor
            case .volunteering:
                isHidden = false
                backgroundColor = ThemeManager.shared.currentTheme.accentColor
            case .unregistered:
                isHidden = true
            }
        }
    }
}
