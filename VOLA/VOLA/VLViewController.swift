//
//  VLViewController.swift
//  VOLA
//
//  VLViewController is a base view controller class that handles
//  showing error alert messages and checking field validity
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

    func areAllFieldsValid() -> [String] {
        var errorDescriptions: [String] = []
        for field in fieldsToValidate where !field.isValid {
            errorDescriptions.append(field.validator.error)
            field.validate() // Show error in case it hasn't been shown yet
        }

        return errorDescriptions
    }

    func textFieldEditingDidEnd(_ textField: VLTextField) {
        textField.validate()
    }

    func showErrorAlert(errorTitle: String, errorMessage: String) {
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DictKeys.ok.rawValue, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
