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
        guard DataManager.sharedInstance.currentUser == nil else {
            DataManager.sharedInstance.logOut()
            updateUserUI()
            return
        }

        let loginVC: LoginViewController = UIStoryboard.init(storyboard: .login).instantiateViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        present(navController, animated: true, completion: nil)
    }

    private func updateUserUI() {
        DispatchQueue.main.async {
            if let user = DataManager.sharedInstance.currentUser {
                self.homeLabel.text = user.name
                self.loginButton.setTitle("Log Out", for: .normal)
            } else {
                self.homeLabel.text = "Home"
                self.loginButton.setTitle("Log In", for: .normal)
            }
        }
    }
}
