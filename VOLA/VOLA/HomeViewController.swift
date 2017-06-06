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

        updateUserUI()
    }
    
    @IBAction func onLoginPressed(_ sender: Any) {
        guard !DataManager.shared.isLoggedIn else {
            DataManager.shared.logOut()
            updateUserUI()
            return
        }

//        let navController: UINavigationController = UIStoryboard.init(storyboard: .login).instantiateViewController()
        let loginVC: LoginViewController = UIStoryboard(.login).instantiateViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        present(navController, animated: true, completion: nil)
    }

    private func updateUserUI() {
        guard let user = DataManager.shared.currentUser else {
            homeLabel.text = "Home"
            loginButton.setTitle("Log In", for: .normal)
            return
        }

        homeLabel.text = user.name
        loginButton.setTitle("Log Out", for: .normal)
    }
}
