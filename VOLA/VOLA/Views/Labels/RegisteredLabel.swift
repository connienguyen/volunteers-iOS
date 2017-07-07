//
//  RegisteredLabel.swift
//  VOLA
//
//  RegisteredLabel is used to display a user's event registration status
//
//  Created by Connie Nguyen on 7/8/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class RegisteredLabel: UILabel {
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

    override func awakeFromNib() {
        super.awakeFromNib()

        textColor = ThemeColors.white
    }
}
