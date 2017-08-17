//
//  UIViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

// Apply StoryboardIdentifiable protocol to all UIViewControllers
extension UIViewController: StoryboardIdentifiable {}

extension UIViewController {

    /**
        Perform one of available segues
     
        - Parameters:
            - segue: Segue to perform
    */
    func performSegue(_ segue: Segue, sender: Any?) {
        performSegue(withIdentifier: segue.identifier, sender: sender)
    }

    /// Currently active indicator, nil if there is no indicator
    var currentActivityIndicator: UIActivityIndicatorView? {
        return view.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView
    }

    /// Display activity indicator if there is not one already active
    func displayActivityIndicator() {
        guard currentActivityIndicator == nil else {
            // Make sure there isn't already an activity indicator
            Logger.error(UIError.existingActivityIndicator)
            return
        }

        let indicator = UIActivityIndicatorView(frame: view.frame)
        indicator.activityIndicatorViewStyle = .gray
        indicator.center = view.center
        indicator.backgroundColor = ThemeColors.lightGrey
        indicator.isHidden = false
        indicator.startAnimating()
        self.view.addSubview(indicator)
    }

    /// Remove current activity indicator if there is one
    func removeActivityIndicator() {
        if let indicator = currentActivityIndicator {
            indicator.removeFromSuperview()
        }
    }

    /**
        Display error in an alert view controller
     
        - Parameters:
            - errorTitle: Title to display on error alert
            - errorMessage: Message to display on error alert
    */
    func showErrorAlert(errorTitle: String, errorMessage: String) {
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DictKeys.ok.rawValue, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    /// Current login upsell view if there is one
    var loginUpsellView: LoginUpsellView? {
        return view.subviews.first(where: {$0 is LoginUpsellView }) as? LoginUpsellView
    }

    /**
        Shows login upsell view if there is already not one on the view controller and sets
        up target for the button on the upsell
    */
    func showUpsell() {
        // Guard against showing multiple upsells on the same view controller
        guard loginUpsellView == nil else {
            return
        }

        let newUpsell = LoginUpsellView.instantiateFromXib()
        let viewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        newUpsell.frame = viewFrame
        newUpsell.layer.zPosition += 1
        newUpsell.loginButton.addTarget(self, action: #selector(presentLoginFromUpsell), for: .touchUpInside)
        view.addSubview(newUpsell)
        addNotificationObserver(NotificationName.userLogin, selector: #selector(removeUpsell))
    }

    /// Remove login upsell if there is one active on view controller
    func removeUpsell() {
        // Guard against removing upsell view from view controller when there is none
        guard let upsellView = loginUpsellView else {
            return
        }

        upsellView.removeFromSuperview()
        removeNotificationObserver(NotificationName.userLogin)
    }

    /// Present login flow where use can log in through a social network or manually with email
    func presentLoginFromUpsell() {
        let loginNavVC: LoginNavigationController = UIStoryboard(.login).instantiateViewController()
        present(loginNavVC, animated: true, completion: nil)
    }

    /**
        Show alert that user can dismiss or use as a shortcut to Settings to edit app permissions
     
        - Parameters:
            - title: Title of the alert (suggested to use title of permission that needs access)
            - message: Message of the alert (suggested to use an explaination for permission access)
    */
    func showEditSettingsAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let openSettingsAction = UIAlertAction(title: UIDisplay.editSettings.localized, style: .default, handler: { (_) in
            guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }

            URL.applicationOpen(url: settingsURL)
        })
        let cancelAction = UIAlertAction(title: UIDisplay.cancel.localized, style: .cancel, handler: nil)
        alert.addAction(openSettingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
