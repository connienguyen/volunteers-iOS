//
//  LoginViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 5/31/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import FRHyperLabel
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signUpLabel: VLHyperLabel!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up viewController for social login
        GIDSignIn.sharedInstance().uiDelegate = self

        facebookLoginButton.readPermissions = FBRequest.readPermissions
        facebookLoginButton.delegate = self

        // Set up Cancel button to dismiss
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancelPressed))

        // Handle hyper label set up
        let labelText = "signup.title.label".localized
        signUpLabel.setAttributedString(labelText, fontSize: 16.0)
        let signUpHandler = {(hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            self.onSignUpPressed()
        }
        signUpLabel.setLinkForSubstring("signup.prompt.title.label".localized, withLinkHandler: signUpHandler)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard DataManager.shared.currentUser == nil else {
            dismiss(animated: true, completion: nil)
            return
        }
    }

    @IBAction func onLoginWithEmailPressed(_ sender: Any) {
        performSegue(.showLoginManual)
    }

    func onSignUpPressed() {
        guard let storyboard = storyboard else {
            return
        }

        let signUpVC: SignUpViewController = storyboard.instantiateViewController()
        navigationController?.show(signUpVC, sender: self)
    }

    func onCancelPressed() {
        dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        guard let response = result, response.token != nil else {
            // TODO: Error handling
            return
        }

        LoginManager.shared.loginFacebook { (error) in
            guard error == nil else {
                // TODO: Show error?
                return
            }

            self.onCancelPressed()
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // TODO - func is required to be defined as a FBSDKLoginButtonDelegate
    }
}
