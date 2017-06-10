//
//  ProfileViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/10/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var currentUserView: UIView!
    @IBOutlet weak var anonUserView: UIView!
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

    @IBAction func onLogoutPressed(_ sender: Any) {
        LoginManager.shared.logOut()
        switchUserView()
    }

    @IBAction func onLoginPressed(_ sender: Any) {
        let loginNavController: LoginNavigationController = UIStoryboard.init(.login).instantiateViewController()
        present(loginNavController, animated: true, completion: nil)
    }

    func onEditPressed() {
        // TODO segue to Edit Profile VC
    }

    private func switchUserView() {
        currentUserView.isHidden = !DataManager.shared.isLoggedIn
        anonUserView.isHidden = DataManager.shared.isLoggedIn

        // Hide or show edit button
        navigationItem.rightBarButtonItem?.isEnabled = DataManager.shared.isLoggedIn
        navigationItem.rightBarButtonItem?.tintColor = DataManager.shared.isLoggedIn ? nil : UIColor.clear

        guard let user = DataManager.shared.currentUser else {
            return
        }

        nameLabel.text = user.name
        emailLabel.text = user.email
    }
}
