//
//  LoginManualViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 5/31/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/**
View controller where user can log in to their account manually with an email and password
*/
class LoginManualViewController: UIViewController {

    @IBOutlet weak var emailTextField: VLTextField!
    @IBOutlet weak var passwordTextField: VLTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.validator = .email
        passwordTextField.validator = .required
        setUpValidatableFields()
    }
}

// MARK : - IBActions
extension LoginManualViewController {
    /// Display validation errors if there are any, otherwise make request to backend to login user
    @IBAction func onLoginPressed(_ sender: Any) {
        let errorDescriptions = validationErrorDescriptions
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            errorDescriptions.isEmpty else {
                let errorMessage = errorDescriptions.joinLocalized()
                showErrorAlert(errorTitle: VLError.validation.localizedDescription, errorMessage: errorMessage)
                return
        }

        LoginManager.shared.login(.emailLogin(email, password))
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

                self.showErrorAlert(errorTitle: UIDisplay.loginErrorTitle.localized, errorMessage: error.localizedDescription)
            }
    }
}

// MARK: - Validatable; protocol to validate applicable fields on view controller
extension LoginManualViewController: Validatable {
    var fieldsToValidate: [VLTextField] {
        return [emailTextField, passwordTextField]
    }
}
