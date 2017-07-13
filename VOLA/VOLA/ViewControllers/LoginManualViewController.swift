//
//  LoginManualViewController.swift
//  VOLA
//
//  View controller that allows user to log in to their account
//  manually with an email and password.
//
//  Created by Connie Nguyen on 5/31/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class LoginManualViewController: VLViewController {

    @IBOutlet weak var emailTextField: VLTextField!
    @IBOutlet weak var passwordTextField: VLTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.validator = .email
        passwordTextField.validator = .required
    }
}

extension LoginManualViewController {
    @IBAction func onLoginPressed(_ sender: Any) {
        let errorDescriptions = areAllFieldsValid()
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            errorDescriptions.isEmpty else {
                let errorMessage = errorDescriptions.flatMap({$0.localized}).joined(separator: "\n")
                showErrorAlert(errorTitle: VLError.validation.localizedDescription, errorMessage: errorMessage)
                return
        }

        LoginManager.shared.login(.manualLogin(email, password))
            .then { [weak self] (success) -> Void in
                guard let `self` = self,
                    success else {
                        return
                }

                self.dismiss(animated: true, completion: nil)
            }.catch { error in
                Logger.error(error)
            }
    }
}
