//
//  EventRegistrationViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import FRHyperLabel

/**
View controller that allows user to register for an event. Some fields may be autofilled
 if the user is logged in.
*/
class EventRegistrationViewController: UIViewController {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var loginBenefitLabel: VLHyperLabel!
    @IBOutlet weak var nameTextField: VLTextField!
    @IBOutlet weak var emailTextField: VLTextField!
    @IBOutlet weak var accommodationTextView: UITextView!
    @IBOutlet weak var volunteerCheckbox: VLCheckbox!

    let titleKey = "registration.title.label"
    let registrationLabelKey = "registration-login.title.label"
    let registrationPromptKey = "registration-login.prompt.title.label"

    var event: Event = Event()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = titleKey.localized
        nameTextField.validator = .name
        emailTextField.validator = .email
        setUpValidatableFields()

        // Set up VLHyperLabel
        let loginHandlers = [
            HyperHandler(linkText: registrationPromptKey.localized, linkHandler: {
                let loginNavVC: LoginNavigationController = UIStoryboard(.login).instantiateViewController()
                self.present(loginNavVC, animated: true, completion: nil)
            })
        ]
        loginBenefitLabel.setUpLabel(registrationLabelKey.localized, textSize: .normal, handlers: loginHandlers)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureRegistrationView()
    }

    /// Configure event registration display based on whether or nor user is logged in
    func configureRegistrationView() {
        eventNameLabel.text = event.name
        loginBenefitLabel.isHidden = DataManager.shared.isLoggedIn
        guard let user = DataManager.shared.currentUser else {
            // If user is not logged in, do not pre-fill text fields
            return
        }

        nameTextField.text = user.name
        emailTextField.text = user.email
    }
}

// MARK: - IBActions
extension EventRegistrationViewController {
    @IBAction func onRegisterPressed(_ sender: Any) {
        let errorDescriptions = validationErrorDescriptions
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            errorDescriptions.isEmpty else {
                let errorMessage = errorDescriptions.joinLocalized()
                showErrorAlert(errorTitle: VLError.validation.localizedDescription, errorMessage: errorMessage)
                return
        }

        // TODO event registration API call
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Validatable; protocol to validate application text fields on view controller
extension EventRegistrationViewController: Validatable {
    var fieldsToValidate: [VLTextField] {
        return [nameTextField, emailTextField]
    }
}
