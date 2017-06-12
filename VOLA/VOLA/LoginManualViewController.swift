//
//  LoginManualViewController.swift
//  VOLA
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
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            areAllFieldsValid() else {
                return
        }

        LoginManager.shared.loginManual(email: email, password: password) { (error) in
            guard error == nil else {
                Logger.error(error?.localizedDescription ?? "Could not log in to Systers server.")
                return
            }

            self.dismiss(animated: true, completion: nil)
        }
    }
}
