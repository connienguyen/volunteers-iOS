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
    @IBOutlet weak var nameTextField: VLTextField!
    @IBOutlet weak var emailTextField: VLTextField!

    override func viewDidLoad() {
         super.viewDidLoad()

        nameTextField.validator = .name
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
        nameTextField.text = user.name
        emailTextField.text = user.email
        nameTextField.isValid = true
        emailTextField.isValid = true

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
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            errorDescriptions.isEmpty else {
                let errorMessage = errorDescriptions.joinLocalized()
                showErrorAlert(errorTitle: VLError.validation.localizedDescription, errorMessage: errorMessage)
                return
        }

        LoginManager.shared.updateUser(.firebase(name, email))
            .then { [weak self] (success) -> Void in
                guard let `self` = self, success else {
                    return
                }

                self.navigationController?.popViewController(animated: true)
            }.catch { [weak self] (error) in
                Logger.error(error)
                guard let `self` = self else {
                    return
                }

                self.showErrorAlert(errorTitle: saveErrorKey.localized, errorMessage: error.localizedDescription)
            }
    }
}

// MARK: - Validatable; protocol to validate text fields on view controller
extension EditProfileViewController: Validatable {
    var fieldsToValidate: [VLTextField] {
        return [nameTextField, emailTextField]
    }
}
