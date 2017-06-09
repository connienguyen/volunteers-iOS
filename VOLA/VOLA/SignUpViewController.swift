//
//  SignUpViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/3/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import FRHyperLabel

class SignUpViewController: VLViewController {

    @IBOutlet weak var nameTextField: VLTextField!
    @IBOutlet weak var emailTextField: VLTextField!
    @IBOutlet weak var passwordTextField: VLTextField!
    @IBOutlet weak var confirmTextField: VLTextField!
    @IBOutlet weak var signUpAgreeLabel: VLHyperLabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set appropriate validators for text fields and delegates
        nameTextField.validator = .name
        emailTextField.validator = .email
        passwordTextField.validator = .password
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self

        // Set up hyper label
        let labelText = "signup-agree.title.label".localized
        signUpAgreeLabel.setAttributedString(labelText, fontSize: 14.0)
        let termsHandler = {(hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            guard let url = ABIURL.termsOfService else {
                return
            }

            UIApplication.shared.openURL(url)
        }
        let privacyHandler = {(hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            guard let url = ABIURL.privacyPolicy else {
                return
            }

            UIApplication.shared.openURL(url)
        }
        signUpAgreeLabel.setLinkForSubstring("tos.title.label".localized, withLinkHandler: termsHandler)
        signUpAgreeLabel.setLinkForSubstring("privacy.title.label".localized, withLinkHandler: privacyHandler)
    }

    @IBAction func onSignUpPressed(_ sender: Any) {
        guard allFieldsValid() else {
            return
        }

        // Handle confirmTextField, special case of validation
        confirmTextField.isValid = confirmTextField.text == passwordTextField.text

        // TODO Use LoginManger to log in user
    }
}

//MARK: - UITextFieldDelegate
extension SignUpViewController {
    override func textFieldDidEndEditing(_ textField: UITextField) {
        guard let vlTextField = textField as? VLTextField else {
            return
        }

        if vlTextField == confirmTextField {
            vlTextField.isValid = vlTextField.text == passwordTextField.text
        } else {
            super.textFieldDidEndEditing(textField)
        }
    }
}
