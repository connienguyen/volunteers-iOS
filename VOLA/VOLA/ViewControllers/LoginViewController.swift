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

    /// Set to true if sender was an introduction slide
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
        let signUpHandlers = [
            HyperHandler(linkText: signUpPromptKey.localized, linkHandler: {
                self.onSignUpPressed()
            })
        ]
        signUpLabel.setUpLabel(signUpTitleKey.localized, textSize: .normal, handlers: signUpHandlers)
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

    deinit {
        removeNotificationObserver(NotificationName.googleDidSignIn)
    }

    /// Show SignUpViewController
    func onSignUpPressed() {
        guard let storyboard = storyboard else {
            Logger.error("Storyboard for LoginViewController was nil.")
            return
        }

        let signUpVC: SignUpViewController = storyboard.instantiateViewController()
        navigationController?.show(signUpVC, sender: self)
    }

    /// Dismiss login views
    func onCancelPressed() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - IBActions
extension LoginViewController {
    @IBAction func onLoginWithEmailPressed(_ sender: Any) {
        performSegue(.showLoginManual, sender: self)
    }
}

// MARK: - FBSDKLoginButtonDelegate
extension LoginViewController: FBSDKLoginButtonDelegate {
    /// Log in user using Facebook
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        guard let response = result, response.token != nil else {
            Logger.error(VLError.invalidFacebookResponse)
            return
        }

        displayActivityIndicator()
        LoginManager.shared.login(.facebook)
            .then { [weak self] (success) -> Void in
                guard let `self` = self,
                    success else {
                    return
                }

                self.removeActivityIndicator()
                self.onCancelPressed()
            }.catch { [weak self] error in
                Logger.error(error)
                guard let `self` = self else {
                    return
                }

                self.removeActivityIndicator()
                self.showErrorAlert(errorTitle: UIDisplay.loginErrorTitle.localized, errorMessage: error.localizedDescription)
            }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        /* intentionally left blank and required to confirm to FBSDKLoginButtonDelegate */
    }
}

// MARK: - NotificationObserver
extension LoginViewController {
    func googleDidSignIn(_ notification: NSNotification) {
        displayActivityIndicator()
        LoginManager.shared.login(.google(notification))
            .then { [weak self] (success) -> Void in
                guard let `self` = self,
                    success else {
                    return
                }

                self.removeActivityIndicator()
                self.onCancelPressed()
            }.catch { [weak self] error in
                Logger.error(error)
                guard let `self` = self else {
                    return
                }

                self.removeActivityIndicator()
                self.showErrorAlert(errorTitle: UIDisplay.loginErrorTitle.localized, errorMessage: error.localizedDescription)
            }
    }
}
