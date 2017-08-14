//
//  ConnectEmailViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/9/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/// Protocol for updating view on delegate of ConnectEmailViewController
protocol ConnectEmailViewControllerDelegate: class {
    /**
        Add connected login for email/password
     
        - Parameters:
            - email: Email address for connected login
            - password: Password for connected login
    */
    func emailDidConnect(email: String, password: String)
}

/// View controller for creating a new email connected login
class ConnectEmailViewController: UIViewController {
    @IBOutlet weak var emailTextField: VLTextField!
    @IBOutlet weak var passowrdTextField: VLTextField!
    @IBOutlet weak var confirmTextField: VLTextField!

    weak var delegate: ConnectEmailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.validator = .email
        passowrdTextField.validator = .password
        setUpValidatableFields()
        confirmTextField.addTarget(self, action: #selector(confirmFieldDidChange(_:)), for: .editingDidEnd)
    }
}

// MARK: - IBActions
extension ConnectEmailViewController {
    /// Validate text inputs and add email conneted login via delegate
    @IBAction func onConnectPressed(_ sender: Any) {
        let errorDescriptions = validationErrorDescriptions
        guard let email = emailTextField.text,
            let password = passowrdTextField.text,
            let confirm = confirmTextField.text,
            password == confirm,
            errorDescriptions.isEmpty else {
                let errorMessage = errorDescriptions.joinLocalized()
                showErrorAlert(errorTitle: VLError.validation.localizedDescription,
                               errorMessage: errorMessage)
                return
        }

        delegate?.emailDidConnect(email: email, password: password)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Validatable; protocol to validate applicable text fields on view controller
extension ConnectEmailViewController: Validatable {
    var fieldsToValidate: [VLTextField] {
        return [emailTextField, passowrdTextField]
    }

    /// Validate confirmTextField on editing did end
    func confirmFieldDidChange(_ textfield: VLTextField) {
        confirmTextField.isValid = confirmTextField.text == passowrdTextField.text
    }
}
