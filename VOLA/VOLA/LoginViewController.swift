//
//  LoginViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 5/31/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancelPressed))
    }

    @IBAction func onLoginWithEmailPressed(_ sender: Any) {
        performSegue(withIdentifier: "showLoginManual", sender: self)
    }

    func onCancelPressed() {
        dismiss(animated: true, completion: nil)
    }
}
