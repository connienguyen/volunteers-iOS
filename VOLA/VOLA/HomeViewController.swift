//
//  HomeViewController.swift
//  VOLA
//
//  Created by Bruno Henriques on 31/05/2017.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHomeUI()
    }
    
    @IBAction func onLoginPressed(_ sender: Any) {
        guard !DataManager.shared.isLoggedIn else {
            LoginManager.shared.logOut()
            updateHomeUI()
            return
        }

        let navController: LoginNavigationController = UIStoryboard.init(.login).instantiateViewController()
        present(navController, animated: true, completion: nil)
    }

    private func updateHomeUI() {
        guard let user = DataManager.shared.currentUser else {
            homeLabel.text = "Home".localized
            loginButton.setTitle("Log In".localized, for: .normal)
            return
        }

        homeLabel.text = user.name
        loginButton.setTitle("Log Out".localized, for: .normal)
    }
}
