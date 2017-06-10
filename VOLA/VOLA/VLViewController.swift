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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Using this instead of UITextFieldDelegate, because setting view controller as
        // the UITextFieldDelegate disables TPKeyboardAvoiding "Next" button feature
        for field in fieldsToValidate {
            field.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        }
    }

    func allFieldsValid() -> Bool {
        var retValue = true
        for field in fieldsToValidate where !field.isValid {
            field.validate() // Show error in case it hasn't been shown yet
            retValue = false
        }

        return retValue
    }

    func textFieldEditingDidEnd(_ textField: VLTextField) {
        textField.validate()
    }
}
