//
//  EventRegistrationViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/**
    View controller that allows user to register for an event. Some fields may be autofilled
    if the user is logged in.
*/
class EventRegistrationViewController: UIViewController {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: VLTextField!
    @IBOutlet weak var lastNameTextField: VLTextField!
    @IBOutlet weak var affiliationTextField: VLTextField!
    @IBOutlet weak var titleTextField: VLTextField!
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
        firstNameTextField.validator = .name
        lastNameTextField.validator = .name
        affiliationTextField.validator = .required
        titleTextField.validator = .required
        emailTextField.validator = .email
        setUpValidatableFields()

        // Autofill fields with current user data since user must be logged in to view this page
        guard let currentUser = DataManager.shared.currentUser else {
            Logger.error(VLError.notLoggedIn)
            return
        }

        eventNameLabel.text = event.name
        firstNameTextField.text = currentUser.firstName
        lastNameTextField.text = currentUser.lastName
        affiliationTextField.text = currentUser.affiliation
        titleTextField.text = currentUser.title
        emailTextField.text = currentUser.email
    }
}

// MARK: - IBActions
extension EventRegistrationViewController {
    @IBAction func onRegisterPressed(_ sender: Any) {
        let errorDescriptions = validationErrorDescriptions
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let affiliation = affiliationTextField.text,
            let title = titleTextField.text,
            let email = emailTextField.text,
            errorDescriptions.isEmpty else {
                let errorMessage = errorDescriptions.joinLocalized()
                showErrorAlert(errorTitle: VLError.validation.localizedDescription, errorMessage: errorMessage)
                return
        }

        // TODO: Update to user new Firebae eTouches replacement
        ETouchesAPIService.shared.registerForEvent(eventID: event.eventID,
                                                   name: "\(firstName) \(lastName)".trimmed,
                                                   email: email,
                                                   volunteering: volunteerCheckbox.isChecked,
                                                   accommodation: accommodationTextView.text)
            .then { [weak self] (_) -> Void in
                self?.navigationController?.popViewController(animated: true)
            }.catch { [weak self] error in
                self?.showErrorAlert(errorTitle: "Could not register for event", errorMessage: error.localizedDescription)
            }
    }
}

// MARK: - Validatable; protocol to validate application text fields on view controller
extension EventRegistrationViewController: Validatable {
    var fieldsToValidate: [VLTextField] {
        return [firstNameTextField, lastNameTextField, affiliationTextField, titleTextField, emailTextField]
    }
}
