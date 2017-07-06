//
//  HomeNavigationController.swift
//  VOLA
//
//  HomeNavigationController determines the root view controller for
//  the Home tab on the tab bar navigation
//
//  Created by Connie Nguyen on 7/2/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let eventTable = EventTableViewController.instantiateFromXib()
        setViewControllers([eventTable], animated: true)
    }
}
