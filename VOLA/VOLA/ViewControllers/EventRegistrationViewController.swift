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

class EventRegistrationViewController: VLViewController {
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

        // Set up VLHyperLabel
        let labelText = registrationLabelKey.localized
        loginBenefitLabel.setAttributedString(labelText, fontSize: TextSize.normal.fontSize)
        let loginHandler = {(hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            let loginNavVC: LoginNavigationController = UIStoryboard(.login).instantiateViewController()
            self.present(loginNavVC, animated: true, completion: nil)
        }
        loginBenefitLabel.setLinkForSubstring(registrationPromptKey.localized, withLinkHandler: loginHandler)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureRegistrationView()
    }

    func configureRegistrationView() {
        eventNameLabel.text = event.name
        loginBenefitLabel.isHidden = DataManager.shared.isLoggedIn
        guard let user = DataManager.shared.currentUser else {
            Logger.error(VLError.notLoggedIn)
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
