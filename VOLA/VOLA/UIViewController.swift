//
//  UIViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

extension UIViewController {
    func performSegue(_ segue: Segue) {
        performSegue(withIdentifier: segue.identifier, sender: self)
    }
}

extension UIViewController: StoryboardIdentifiable {}
