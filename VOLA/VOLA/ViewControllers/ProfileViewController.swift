//
//  ProfileViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/10/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import Kingfisher

/**
View controller where user can view their profile if they are logged in, otherwise
 encourage user to sign up or log in.
*/
class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: CircleImageView!
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

        if DataManager.shared.isLoggedIn {
            configureUserView()
        } else {
            showUpsell()
            showEditButton(false)
        }
    }

    /// Segue to EditProfileViewController
    func onEditPressed() {
        performSegue(withIdentifier: Segue.showEditProfile.identifier, sender: self)
    }

    /// Configure UI elements to match details of current user
    func configureUserView() {
        profileImageView.image = nil    // Ensure last user's image is not shown
        guard let user = DataManager.shared.currentUser else {
            return
        }

        let loggedInManual = user.userType == .manual
        showEditButton(loggedInManual)
        nameLabel.text = user.name
        emailLabel.text = user.email
        if let imageURL = user.imageURL {
            profileImageView.kf.setImage(with: imageURL)
        }
    }

    /**
    Show or hide edit button
    
    - Parameters:
        - show: Boolean value of whether or not to show edit button
    */
    func showEditButton(_ show: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = show
        navigationItem.rightBarButtonItem?.title = show ? "Edit" : nil
    }
}

// MARK: - IBActions
extension ProfileViewController {
    /// Log out user and update display accordingly
    @IBAction func onLogoutPressed(_ sender: Any) {
        LoginManager.shared.logOut()
        showUpsell()
    }

    /// Show login user flow
    @IBAction func onLoginPressed(_ sender: Any) {
        let loginNavController: LoginNavigationController = UIStoryboard(.login).instantiateViewController()
        present(loginNavController, animated: true, completion: nil)
    }
}
