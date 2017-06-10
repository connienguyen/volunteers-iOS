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

    @IBAction func onLoginPressed(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            allFieldsValid() else {
                return
        }

        LoginManager.shared.loginManual(email: email, password: password) { (error) in
            guard error == nil else {
                // TODO error handling
                return
            }

            self.dismiss(animated: true, completion: nil)
        }
    }
}
