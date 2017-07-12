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

/**
View controller where user is presented with multiple methods of logging in,
 including social logins amd manual login. User can also navigate to sign up
 from this view controller.
*/
class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signUpLabel: VLHyperLabel!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!

    let signUpTitleKey = "signup.title.label"
    let signUpPromptKey = "signup.prompt.title.label"

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
        let labelText = signUpTitleKey.localized
        signUpLabel.setAttributedString(labelText, fontSize: 16.0)
        let signUpHandler = {(hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            self.onSignUpPressed()
        }
        signUpLabel.setLinkForSubstring(signUpPromptKey.localized, withLinkHandler: signUpHandler)
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

    /**
    Show SignUpViewController
    */
    func onSignUpPressed() {
        guard let storyboard = storyboard else {
            Logger.error("Storyboard for LoginViewController was nil.")
            return
        }

        let signUpVC: SignUpViewController = storyboard.instantiateViewController()
        navigationController?.show(signUpVC, sender: self)
    }

    /**
    Dismiss login views 
    */
    func onCancelPressed() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - IBActions
extension LoginViewController {
    @IBAction func onLoginWithEmailPressed(_ sender: Any) {
        performSegue(.showLoginManual)
    }
}

// MARK:- FBSDKLoginButtonDelegate
extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        guard let response = result, response.token != nil else {
            Logger.error(VLError.invalidFacebookResponse)
            return
        }

        LoginManager.shared.login(.facebook)
            .then { [weak self] (success) -> Void in
                guard let `self` = self,
                    success else {
                    return
                }

                self.onCancelPressed()

            }.catch { error in
                Logger.error(error)
            }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // TODO - func is required to be defined as a FBSDKLoginButtonDelegate
    }
}

// MARK: - NotificationObserver
extension LoginViewController {
    func googleDidSignIn(_ notification: NSNotification) {
        LoginManager.shared.login(.google(notification))
            .then { [weak self] (success) -> Void in
                guard let `self` = self,
                    success else {
                    return
                }

                self.onCancelPressed()
            }.catch { error in
                Logger.error(error)
            }
    }
}
