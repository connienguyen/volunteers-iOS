//
//  UIViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

extension UIViewController: StoryboardIdentifiable {}

extension UIViewController {

    func performSegue(_ segue: Segue) {
        performSegue(withIdentifier: segue.identifier, sender: self)
    }

    func findActivityIndicator() -> UIActivityIndicatorView? {
        return view.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView
    }

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

    func removeActivityIndicator() {
        if let indicator = findActivityIndicator() {
            indicator.removeFromSuperview()
        }
    }

    func showErrorAlert(errorTitle: String, errorMessage: String) {
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DictKeys.ok.rawValue, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
