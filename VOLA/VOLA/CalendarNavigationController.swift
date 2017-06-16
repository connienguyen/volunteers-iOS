//
//  CalendarNavigationController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/16/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class CalendarNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let eventTable = EventTableViewController.instantiateFromXib()
        setViewControllers([eventTable], animated: true)
    }
}
