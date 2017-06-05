//
//  LoginViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 5/31/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import FRHyperLabel

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signUpLabel: FRHyperLabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancelPressed))

        // Handle hyper label set up
        if let labelText = signUpLabel.text {
            let attributes = [NSForegroundColorAttributeName: UIColor.black,
                              NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)]
            signUpLabel.attributedText = NSAttributedString(string: labelText, attributes: attributes)

            let signUpHandler = {(hyperLabel: FRHyperLabel?, substring: String?) -> Void in
                self.onSignUpPressed()
            }

            signUpLabel.setLinkForSubstring("Sign up now.", withLinkHandler: signUpHandler)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let _ = DataManager.sharedInstance.currentUser {
            onCancelPressed()
        }
    }

    @IBAction func onLoginWithEmailPressed(_ sender: Any) {
        performSegue(withIdentifier: "showLoginManual", sender: self)
    }

    func onSignUpPressed() {
        if let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
            as? SignUpViewController {
            navigationController?.show(signUpVC, sender: self)
        }
    }

    func onCancelPressed() {
        dismiss(animated: true, completion: nil)
    }
}
