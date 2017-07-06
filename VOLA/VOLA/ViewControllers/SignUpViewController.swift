//
//  SignUpViewController.swift
//  VOLA
//
//  SignUpViewController allows user to manually sign up for the app.
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

        nameTextField.validator = .name
        emailTextField.validator = .email
        passwordTextField.validator = .password
        confirmTextField.addTarget(self, action: #selector(confirmFieldDidChange(_:)), for: .editingDidEnd)

        // Set up hyper label
        let labelText = "signup-agree.title.label".localized
        signUpAgreeLabel.setAttributedString(labelText, fontSize: 14.0)
        let termsHandler = {(hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            guard let url = ABIURL.termsOfService else {
                Logger.error(VLError.invalidTOS.localizedDescription)
                return
            }

            UIApplication.shared.openURL(url)
        }
        let privacyHandler = {(hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            guard let url = ABIURL.privacyPolicy else {
                Logger.error(VLError.invalidPrivacy.localizedDescription)
                return
            }

            UIApplication.shared.openURL(url)
        }
        signUpAgreeLabel.setLinkForSubstring("tos.title.label".localized, withLinkHandler: termsHandler)
        signUpAgreeLabel.setLinkForSubstring("privacy.title.label".localized, withLinkHandler: privacyHandler)
    }

    func confirmFieldDidChange(_ textField: VLTextField) {
        confirmTextField.isValid = confirmTextField.text == passwordTextField.text
    }
}

//MARK: - IBActions
extension SignUpViewController {
    @IBAction func onSignUpPressed(_ sender: Any) {
        let errorDescriptions = areAllFieldsValid()
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirm = confirmTextField.text,
            password == confirm,
            errorDescriptions.isEmpty else {
                let errorMessage = errorDescriptions.flatMap({$0.localized}).joined(separator: "\n")
                showErrorAlert(errorTitle: VLError.validation.localizedDescription, errorMessage: errorMessage)
                return
        }
        guard errorDescriptions.isEmpty else {
            let errorMessage = errorDescriptions.flatMap({$0.localized}).joined(separator: "\n")
            showErrorAlert(errorTitle: VLError.validation.localizedDescription, errorMessage: errorMessage)
            Logger.error(errorMessage)
            return
        }

        LoginManager.shared.login(.manualSignup(name, email, password))
            .then { [weak self] (success) -> Void in
                guard let `self` = self,
                    success else {
                        return
                }

                `self`.dismiss(animated: true, completion: nil)
            }.catch { error in
                Logger.error(error.localizedDescription)
            }
    }
}
