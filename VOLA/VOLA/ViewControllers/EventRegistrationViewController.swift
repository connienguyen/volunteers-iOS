//
//  EventRegistrationViewController.swift
//  VOLA
//
//  EventRegistrationViewController allows the user to register for an event.
//  Some fields may be autofilled if the user is logged in.
//
//  Created by Connie Nguyen on 6/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import FRHyperLabel

class EventRegistrationViewController: UIViewController {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var loginBenefitLabel: VLHyperLabel!
    @IBOutlet weak var nameTextField: VLTextField!
    @IBOutlet weak var emailTextField: VLTextField!
    @IBOutlet weak var accommodationTextView: UITextView!
    @IBOutlet weak var volunteerCheckbox: VLCheckbox!

    var event: Event = Event()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "registration.title.label".localized
        nameTextField.validator = .name
        emailTextField.validator = .email
        setUpValidatableFields()

        // Set up VLHyperLabel
        let labelText = "registration-login.title.label".localized
        loginBenefitLabel.setAttributedString(labelText, fontSize: TextSize.normal.fontSize)
        let loginHandler = {(hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            let loginNavVC: LoginNavigationController = UIStoryboard(.login).instantiateViewController()
            self.present(loginNavVC, animated: true, completion: nil)
        }
        loginBenefitLabel.setLinkForSubstring("registration-login.prompt.title.label".localized, withLinkHandler: loginHandler)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureRegistrationView()
    }

    func configureRegistrationView() {
        eventNameLabel.text = event.name
        loginBenefitLabel.isHidden = DataManager.shared.isLoggedIn
        guard let user = DataManager.shared.currentUser else {
            return
        }

        nameTextField.text = user.name
        emailTextField.text = user.email
    }
}

// MARK: - IBActions
extension EventRegistrationViewController {
    @IBAction func onRegisterPressed(_ sender: Any) {
        let errorDescriptions = areAllFieldsValid()
        guard let _ = nameTextField.text,
            let _ = emailTextField.text,
            errorDescriptions.isEmpty else {
                let errorMessage = errorDescriptions.flatMap({$0.localized}).joined(separator: "\n")
                showErrorAlert(errorTitle: VLError.validation.localizedDescription, errorMessage: errorMessage)
                return
        }

        // TODO event registration API call
    }
}

extension EventRegistrationViewController: Validatable {
    var fieldsToValidate: [VLTextField] {
        return [nameTextField, emailTextField]
    }
}
