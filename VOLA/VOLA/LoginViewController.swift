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

        GIDSignIn.sharedInstance().uiDelegate = self

        facebookLoginButton.readPermissions = ["public_profile", "email"]
        facebookLoginButton.delegate = self

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

        if DataManager.sharedInstance.currentUser != nil {
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

extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        guard let response = result, response.token != nil else {
            if let error = error {
                print("There was a problem with Facebook login: \(error.localizedDescription)")
            }
            return
        }

        if FBSDKAccessToken.current() != nil {
            let parameters = ["fields": "email, name"]
            FBSDKGraphRequest.init(graphPath: "me", parameters: parameters).start(completionHandler: { (_, result, error) in
                if error != nil {
                    //
                } else if let response = result as? [String:Any] {
                    DataManager.sharedInstance.logIn(user: UserModel(fbResponse: response))
                    self.onCancelPressed()
                }
            })
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // required
    }
}
