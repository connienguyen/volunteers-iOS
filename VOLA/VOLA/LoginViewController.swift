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

    var introSender: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up viewController for social login
        GIDSignIn.sharedInstance().uiDelegate = self

        facebookLoginButton.readPermissions = FBRequest.readPermissions
        facebookLoginButton.delegate = self

        // Set up Cancel button to dismiss
        if !introSender {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancelPressed))
        }

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

        addNotificationObserver(NotificationName.googleDidSignIn, selector: #selector(googleDidSignIn(_:)), nil)

        guard DataManager.shared.currentUser == nil else {
            dismiss(animated: true, completion: nil)
            return
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeNotificationObserver(NotificationName.googleDidSignIn)
    }

    func onSignUpPressed() {
        guard let storyboard = storyboard else {
            Logger.error("Storyboard for LoginViewController was nil.")
            return
        }

        let signUpVC: SignUpViewController = storyboard.instantiateViewController()
        navigationController?.show(signUpVC, sender: self)
    }

    func onCancelPressed() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - IBActions
extension LoginViewController {
    @IBAction func onLoginWithEmailPressed(_ sender: Any) {
        performSegue(.showLoginManual)
    }
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        guard let response = result, response.token != nil else {
            Logger.error("Facebook response or access token is nil.")
            return
        }

        LoginManager.shared.loginFacebook().then { (success) -> Void in
            guard success else {
                return
            }
            self.onCancelPressed()

            }.catch { error in
                Logger.error(error.localizedDescription)
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // TODO - func is required to be defined as a FBSDKLoginButtonDelegate
    }
}

//MARK: - NotificationObserver
extension LoginViewController {
    func googleDidSignIn(_ notification: NSNotification) {
        LoginManager.shared.loginGoogle(notification: notification) { (error) in
            guard error == nil else {
                Logger.error(error?.localizedDescription ?? "Error while attempting to log in with Google.")
                return
            }

            self.onCancelPressed()
        }
    }
}
