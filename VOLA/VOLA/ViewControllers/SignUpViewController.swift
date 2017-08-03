//
//  SignUpViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/3/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import FRHyperLabel

let agreeLabelKey = "signup-agree.title.label"
let tosPromptKey = "tos.title.label"
let privacyPromptKey = "privacy.title.label"
let signUpErrorKey = "signup-error.title.label"

/// View controller allows user to sign up for an account
class SignUpViewController: UIViewController {

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
        setUpValidatableFields()
        confirmTextField.addTarget(self, action: #selector(confirmFieldDidChange(_:)), for: .editingDidEnd)

        // Set up hyper label
        let signUpHandlers = [
            HyperHandler(linkText: tosPromptKey.localized, linkHandler: {
                URL.applicationOpen(url: ABIURL.termsOfService)
            }),
            HyperHandler(linkText: privacyPromptKey.localized, linkHandler: {
                URL.applicationOpen(url: ABIURL.privacyPolicy)
            })
        ]
        signUpAgreeLabel.setUpLabel(agreeLabelKey.localized, textSize: .small, handlers: signUpHandlers)
    }

    /// Validate confirmTextField on editing did end
    func confirmFieldDidChange(_ textField: VLTextField) {
        confirmTextField.isValid = confirmTextField.text == passwordTextField.text
    }
}

// MARK: - IBActions
extension SignUpViewController {
    /**
     Display validation errors it there are any, otherwise make request to server to
     create an account
    */
    @IBAction func onSignUpPressed(_ sender: Any) {
        let errorDescriptions = validationErrorDescriptions
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
            let errorMessage = errorDescriptions.joinLocalized()
            showErrorAlert(errorTitle: VLError.validation.localizedDescription, errorMessage: errorMessage)
            Logger.error(errorMessage)
            return
        }

        LoginManager.shared.login(.emailSignup(name, email, password))
            .then { [weak self] (success) -> Void in
                guard let `self` = self,
                    success else {
                        return
                }

                self.dismiss(animated: true, completion: nil)
            }.catch { [weak self] error in
                Logger.error(error)
                guard let `self` = self else {
                    return
                }

                self.showErrorAlert(errorTitle: signUpErrorKey.localized, errorMessage: error.localizedDescription)
            }
    }
}

// MARK: - Validatable; protocol to validate applicable text fields on view controller
extension SignUpViewController: Validatable {
    var fieldsToValidate: [VLTextField] {
        return [nameTextField, emailTextField, passwordTextField]
    }
}
