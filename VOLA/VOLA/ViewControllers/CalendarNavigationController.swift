//
//  CalendarNavigationController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/16/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/**
Navigation controller for the calendar tab on the tab bar navigation. Where the root view controller is configured.
 */
class CalendarNavigationController: HiddenBackTextNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let eventTable = EventTableViewController.instantiateFromXib()
        eventTable.tableType = .calendar
        eventTable.viewModel = EventsViewModel()
        eventTable.viewModel.delegate = eventTable
        setViewControllers([eventTable], animated: true)
    }
}
