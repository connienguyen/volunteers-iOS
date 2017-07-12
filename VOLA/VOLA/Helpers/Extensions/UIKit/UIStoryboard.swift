//
//  UIStoryboard.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

extension UIStoryboard {
    /**
    Storyboards used within app
     
    - main: Initial view controller and main tab bar navigation
    - login: User login flow
    - profile: View and edit user profile
    - home: View and search for available events
    - calendar: View registered events
    */
    enum Storyboard: String {
        case main
        case login
        case profile
        case home
        case calendar

        /// Filename for storyboard
        var filename: String {
            return rawValue.capitalized
        }
    }

    convenience init(_ storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }

    /// Instantiate view controller given its type
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier)")
        }

        return viewController
    }
}

/// Protocol to return storyboard identifier
protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    /// Storyboard identifier for view controller
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
