//
//  HomeViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/10/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if intro slides have been shown before
        let shownIntro = Defaults.getObject(forKey: .shownIntro) as? Bool ?? false
        if !shownIntro {
            let introNavController: IntroductionNavigationController = UIStoryboard(.main).instantiateViewController()
            present(introNavController, animated: true, completion: nil)
        } else {
            let eventViewController = EventTableViewController.instantiateFromXib()
            navigationController?.pushViewController(eventViewController, animated: true)
        }
    }
}
