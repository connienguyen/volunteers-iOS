//
//  EventTableViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import PromiseKit

/**
Type of data source table should display
 
- home: Use all available events as data source for table
- calendar: Use events user has registered as data source for table
*/
enum EventTableType: String {
    case home = "Home"
    case calendar = "Calendar"
}

/**
Table view controller displays events in a list (table format). View controller allows user to
 select an event to view more detail
*/
class EventTableViewController: UITableViewController, XIBInstantiable {

    var events: [Event] = []
    var viewModel: EventsViewModel!
    var tableType: EventTableType = .home
    private var isShown: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cellType: EventCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = EventCell.estimatedHeight
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Since view controller is instantiated from XIB file, need to do first load
        // UI setup here (set title, retrieve events for data source)
        guard !isShown else {
            return
        }

        isShown = true
        self.title = tableType.rawValue
    }
}

// MARK: - Table view data source
extension EventTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.eventCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath, cellType: EventCell.self)
        let event = viewModel.event(at: indexPath.row)
        cell.configureCell(event: event)
        return cell
    }
}

// MARK: - Table view delegate
extension EventTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = viewModel.event(at: indexPath.row)
        let eventDetailVC = EventDetailViewController.instantiateFromXib()
        eventDetailVC.event = event
        self.navigationController?.show(eventDetailVC, sender: self)
    }
}
