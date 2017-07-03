//
//  EditProfileViewController.swift
//  VOLA
//
//  EditProfileViewController manages the view controller where a logged in user can edit
//  their profile.
//
//  Created by Connie Nguyen on 6/10/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import Kingfisher

class EditProfileViewController: VLViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: VLTextField!
    @IBOutlet weak var emailTextField: VLTextField!

    override func viewDidLoad() {
         super.viewDidLoad()

        nameTextField.validator = .name
        emailTextField.validator = .email

        configureProfile()
    }

    private func configureProfile() {
        guard let user = DataManager.shared.currentUser else {
            Logger.error(ErrorStrings.notLoggedIn.localized)
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
    @IBAction func onSaveChangesPressed(_ sender: Any) {
        let errorDescriptions = areAllFieldsValid()
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            errorDescriptions.isEmpty else {
                let errorMessage = errorDescriptions.flatMap({$0.localized}).joined(separator: "\n")
                showErrorAlert(errorTitle: ErrorStrings.validation.localized, errorMessage: errorMessage)
                return
        }

        LoginManager.shared.updateUser(name: name, email: email) { (loginError) in
            guard loginError == nil else {
                Logger.error(loginError?.localizedDescription ?? ErrorStrings.userUpdate.localized)
                return
            }

            self.navigationController?.popViewController(animated: true)
        }
    }
}
