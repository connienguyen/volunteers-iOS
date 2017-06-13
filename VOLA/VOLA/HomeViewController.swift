//
//  HomeViewController.swift
//  VOLA
//
//  View controller where user can view available events in their area
//
//  Created by Connie Nguyen on 6/10/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if intro slides have been shown before
        let isShownIntro = Defaults.getObject(forKey: .shownIntro) as? Bool ?? false
        if !isShownIntro {
            let introNavController: IntroductionNavigationController = UIStoryboard(.main).instantiateViewController()
            present(introNavController, animated: true, completion: nil)
        } else {
            let eventViewController = EventTableViewController.instantiateFromXib()
            navigationController?.pushViewController(eventViewController, animated: true)
        }
    }
}
