//
//  VLTextField.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

fileprivate let normalBorderWidth: CGFloat = 0.5
fileprivate let errorBorderWidth: CGFloat = 1.0
fileprivate let cornerRadius: CGFloat = 3.0

/// Stylized custom text field enabled with input validation
class VLTextField: UITextField {
    /// Validation method for text input
    var validator: InputValidation = .none
    /// Update text field's border display according to input validity
    var isValid: Bool = false {
        willSet {
            self.layer.borderColor = newValue ? ThemeManager.shared.currentTheme.inputBorderColor.cgColor
                    : ThemeManager.shared.currentTheme.errorColor.cgColor
            // If invalid, show wider border for emphasis
            self.layer.borderWidth = newValue ? normalBorderWidth : errorBorderWidth
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderColor = ThemeManager.shared.currentTheme.inputBorderColor.cgColor
        layer.borderWidth = normalBorderWidth
        layer.cornerRadius = cornerRadius
    }

    /// Validate current text input and update border display accordingly
    func validate() {
        isValid = validator.isValid(self.text)
    }
}
