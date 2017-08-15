//
//  EditProfileViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/10/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate let saveErrorKey: String = "save-error.title.label"

/// View controller where a logged in user can edit their profile.
class EditProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: CircleImageView!
    @IBOutlet weak var titleTextField: VLTextField!
    @IBOutlet weak var firstNameTextField: VLTextField!
    @IBOutlet weak var lastNameTextField: VLTextField!
    @IBOutlet weak var affiliationTextField: VLTextField!
    @IBOutlet weak var emailTextField: VLTextField!

    override func viewDidLoad() {
         super.viewDidLoad()

        titleTextField.validator = .required
        firstNameTextField.validator = .name
        lastNameTextField.validator = .name
        affiliationTextField.validator = .required
        emailTextField.validator = .email
        setUpValidatableFields()

        configureProfile()
    }

    private func configureProfile() {
        guard let user = DataManager.shared.currentUser else {
            Logger.error(VLError.notLoggedIn)
            return
        }

        // Textfields are considered valid since they are pre-filled from previous data
        titleTextField.text = user.title
        firstNameTextField.text = user.firstName
        lastNameTextField.text = user.lastName
        affiliationTextField.text = user.affiliation
        emailTextField.text = user.email
        [firstNameTextField, lastNameTextField, emailTextField].setIsValid(true)

        if let imageURL = user.imageURL {
            profileImageView.kf.setImage(with: imageURL)
        }
    }
}

// MARK: - IBActions
extension EditProfileViewController {
    /**
        Save changes made to user profile to backend
    */
    @IBAction func onSaveChangesPressed(_ sender: Any) {
        let errorDescriptions = validationErrorDescriptions
        guard let title = titleTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let affiliation = affiliationTextField.text,
            let email = emailTextField.text,
            errorDescriptions.isEmpty else {
                let errorMessage = errorDescriptions.joinLocalized()
                showErrorAlert(errorTitle: VLError.validation.localizedDescription, errorMessage: errorMessage)
                return
        }

        displayActivityIndicator()
        LoginManager.shared.updateUser(.firebase(title: title, firstName: firstName, lastName: lastName, affiliation: affiliation, email: email))
            .then { [weak self] (success) -> Void in
                guard success else {
                    Logger.error(VLError.invalidFirebaseAction)
                    return
                }
                
                self?.navigationController?.popViewController(animated: true)
            }.catch { [weak self] (error) in
                Logger.error(error)
                self?.showErrorAlert(errorTitle: saveErrorKey.localized, errorMessage: error.localizedDescription)
            }.always { [weak self] in
                self?.removeActivityIndicator()
            }
    }
}

// MARK: - Validatable; protocol to validate text fields on view controller
extension EditProfileViewController: Validatable {
    var fieldsToValidate: [VLTextField] {
        return [titleTextField, firstNameTextField, lastNameTextField, affiliationTextField, emailTextField]
    }
}
