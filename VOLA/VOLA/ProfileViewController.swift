//
//  ProfileViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/10/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {

    @IBOutlet weak var currentUserView: UIView!
    @IBOutlet weak var anonUserView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up "Edit" button on right side of navBar
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onEditPressed))
        navigationItem.rightBarButtonItem = editButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        switchUserView()
    }

    func onEditPressed() {
        performSegue(withIdentifier: Segue.showEditProfile.identifier, sender: self)
    }

    func switchUserView() {
        currentUserView.isHidden = !DataManager.shared.isLoggedIn
        anonUserView.isHidden = DataManager.shared.isLoggedIn

        // Hide or show edit button - Should only be shown if logged in AND a manual user
        let loggedInManual = DataManager.shared.currentUser?.userType == .manual
        navigationItem.rightBarButtonItem?.isEnabled = loggedInManual
        navigationItem.rightBarButtonItem?.tintColor = loggedInManual ? nil : UIColor.clear

        profileImageView.image = nil    // Ensure last user's image is not shown
        if let user = DataManager.shared.currentUser {
            nameLabel.text = user.name
            emailLabel.text = user.email
            if let imageURL = user.imageURL {
                profileImageView.kf.setImage(with: imageURL)
            }
        }
    }
}

// MARK: - IBActions
extension ProfileViewController {
    @IBAction func onLogoutPressed(_ sender: Any) {
        LoginManager.shared.logOut()
        switchUserView()
    }

    @IBAction func onLoginPressed(_ sender: Any) {
        let loginNavController: LoginNavigationController = UIStoryboard(.login).instantiateViewController()
        present(loginNavController, animated: true, completion: nil)
    }
}
