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
    func performSegue(_ segue: Segue) {
        performSegue(withIdentifier: segue.identifier, sender: self)
    }

    /**
    Finds the currently active activity indicator
     
    - Returns: Current activity indicator if there is one, otherwise nil
    */
    func findActivityIndicator() -> UIActivityIndicatorView? {
        return view.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView
    }

    /// Display activity indicator if there is not one already active
    func displayActivityIndicator() {
        guard findActivityIndicator() == nil else {
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
        if let indicator = findActivityIndicator() {
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
}
