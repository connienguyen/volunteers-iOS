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

    @IBOutlet weak var signUpLabel: FRHyperLabel!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up viewController for social login
        GIDSignIn.sharedInstance().uiDelegate = self

        facebookLoginButton.readPermissions = ["public_profile", "email"]
        facebookLoginButton.delegate = self

        // Set up Cancel button to dismiss
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancelPressed))

        // Handle hyper label set up
        let labelText = "Don't have a Vola account yet? Sign up now."
        let labelAttributes = [NSForegroundColorAttributeName: UIColor.black,
                               NSFontAttributeName: UIFont.systemFont(ofSize: 16.0)]
        signUpLabel.attributedText = NSAttributedString(string: labelText, attributes: labelAttributes)
        let signUpHandler = {(hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            self.onSignUpPressed()
        }
        signUpLabel.setLinkForSubstring("Sign up now.", withLinkHandler: signUpHandler)
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
            if let error = error {
                print("There was a problem with Facebook login: \(error.localizedDescription)")
            }
            return
        }

        SocialLoginManager.sharedInstance.retrieveFacebookUser { (response, _) in
            guard let response = response else {
                return
            }

            DataManager.shared.logIn(user: UserModel(fbResponse: response))
            self.onCancelPressed()
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // required
    }
}
