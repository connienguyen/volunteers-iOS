//
//  EditProfileViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/10/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import Kingfisher

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
                let errorMessage = String.combineStrings(errorDescriptions, separator: "\n")
                showErrorAlert(errorTitle: VLError.validation.localizedDescription, errorMessage: errorMessage)
                return
        }

        LoginManager.shared.updateUser(name: name, email: email) { (loginError) in
            guard loginError == nil else {
                Logger.error(loginError?.localizedDescription ?? VLError.userUpdate.localizedDescription)
                return
            }

            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Validatable; protocol to validate text fields on view controller
extension EditProfileViewController: Validatable {
    var fieldsToValidate: [VLTextField] {
        return [nameTextField, emailTextField]
    }
}
