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
        confirmTextField.addTarget(self, action: #selector(confirmFieldDidChange(_:)), for: .editingDidEnd)

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

        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else {
                return
        }

        LoginManager.shared.signUpManual(name: name, email: email, password: password) { (error) in
            guard error == nil else {
                // TODO error handling
                return
            }

            self.dismiss(animated: true, completion: nil)
        }
    }

    func confirmFieldDidChange(_ textField: VLTextField) {
        confirmTextField.isValid = confirmTextField.text == passwordTextField.text
    }
}
