//
//  VLViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/9/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class VLViewController: UIViewController {

    @IBOutlet var fieldsToValidate: [VLTextField]!

    func allFieldsValid() -> Bool {
        var retValue = true
        for field in fieldsToValidate where !field.isValid {
            field.validate() // Show error in case it hasn't been shown yet
            retValue = false
        }

        return retValue
    }
}

extension VLViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let vlTextField = textField as? VLTextField {
            vlTextField.validate()
        }
    }
}
