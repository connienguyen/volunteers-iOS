//
//  VLTextField.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class VLTextField: UITextField {
    var validator: InputValidation = .none
    var isValid: Bool = false {
        willSet {
            self.layer.borderColor = newValue ? ThemeColors.lightGrey.cgColor : ThemeManager.shared.currentTheme.errorColor.cgColor
            // If invalid, show wider border for emphasis
            self.layer.borderWidth = newValue ? 0.5 : 1.0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderColor = ThemeColors.lightGrey.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 3.0
    }

    func validate() {
        isValid = validator.isValid(self.text)
    }
}
