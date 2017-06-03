//
//  HomeViewController.swift
//  VOLA
//
//  Created by Bruno Henriques on 31/05/2017.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBAction func onLoginPressed(_ sender: Any) {
        if let loginVC = UIStoryboard(name: "LoginStoryboard", bundle: nil)
            .instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            let navController = UINavigationController(rootViewController: loginVC)
            present(navController, animated: true, completion: nil)
        }
//        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
//            let navController = UINavigationController(rootViewController: loginVC)
//            present(navController, animated: true, completion: nil)
//        }
    }
}
