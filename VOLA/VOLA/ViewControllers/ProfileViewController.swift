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
    @IBOutlet weak var nameLabel: TitleLabel!
    @IBOutlet weak var affiliationLabel: TextLabel!
    @IBOutlet weak var emailLabel: TextLabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up "Settings" button on right side of navBar
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(onSettingsPressed))
        navigationItem.rightBarButtonItem = settingsButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if DataManager.shared.isLoggedIn {
            configureUserView()
        } else {
            showUpsell()
        }
    }

    /// Configure UI elements to match details of current user
    func configureUserView() {
        profileImageView.image = nil    // Ensure last user's image is not shown
        guard let user = DataManager.shared.currentUser else {
            return
        }
        
        nameLabel.text = "\(user.title) \(user.firstName) \(user.lastName)".trimmed
        affiliationLabel.text = user.affiliation
        emailLabel.text = user.email
        if let imageURL = user.imageURL {
            profileImageView.kf.setImage(with: imageURL)
        }
    }

    /// Segue to SettingsViewController
    func onSettingsPressed() {
        performSegue(.showSettings, sender: self)
    }
}

// MARK: - IBActions
extension ProfileViewController {
    /// Log out user and update display accordingly
    @IBAction func onLogoutPressed(_ sender: Any) {
        LoginManager.shared.logOut()
        showUpsell()
    }

    /// Show Edit Profile view
    @IBAction func onEditProfilePressed(_ sender: Any) {
        performSegue(.showEditProfile, sender: self)
    }
}
