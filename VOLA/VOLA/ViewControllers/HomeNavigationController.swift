//
//  HomeNavigationController.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/2/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/**
Navigation controller that sets the root view controller for the home tab on the
 tab bar navigation
*/
class HomeNavigationController: HiddenBackTextNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC: HomeViewController = UIStoryboard(.home).instantiateViewController()
        setViewControllers([homeVC], animated: true)
    }
}
