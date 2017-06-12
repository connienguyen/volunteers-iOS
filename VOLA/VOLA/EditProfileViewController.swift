//
//  EditProfileViewController.swift
//  VOLA
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

        // Set up validators for text fields
        nameTextField.validator = .name
        emailTextField.validator = .email

        configureProfile()
    }

    private func configureProfile() {
        guard let user = DataManager.shared.currentUser else {
            Logger.error("Could not configure user since user is not logged in.")
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

//MARK: - IBActions
extension EditProfileViewController {
    @IBAction func onSaveChangesPressed(_ sender: Any) {
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            areAllFieldsValid() else {
                return
        }

        LoginManager.shared.updateUser(name: name, email: email) { (error) in
            guard error == nil else {
                Logger.error(error?.localizedDescription ?? "Could not update user.")
                return
            }

            self.navigationController?.popViewController(animated: true)
        }
    }
}
