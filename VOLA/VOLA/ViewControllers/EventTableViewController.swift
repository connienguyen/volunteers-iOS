//
//  EventTableViewController.swift
//  VOLA
//
//  EventTableViewController displays events in a list (table format).
//  From this view controller, the user can select an event to view more information
//  about that event. This view controller can be used for both the My Events view
//  or for browsing nearby events from the Home screen.
//
//  Created by Connie Nguyen on 6/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import PromiseKit

enum EventTableType: String {
    case home = "Home"
    case calendar = "My Events"
}


class EventTableViewController: UITableViewController, XIBInstantiable {

    var events: [Event] = []
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
        displayActivityIndicator()
        // TODO - Switch case on self.tableType to determine which ETouchesAPIService call to return
        // Not done yet since API call for a user's registered events is still ambiguous
        ETouchesAPIService.shared.getAvailableEvents()
            .then { [weak self] (events) -> Void in
                guard let `self` = self else {
                    return
                }

                self.events = events
                self.tableView.reloadData()
            }.always { [weak self] in
                guard let `self` = self else {
                    return
                }

                self.removeActivityIndicator()
            }.catch { error in
                Logger.error(error)
            }
    }
}

// MARK: - Table view data source
extension EventTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath, cellType: EventCell.self)
        let event = events[indexPath.row]
        cell.configureCell(event: event)
        return cell
    }
}

// MARK: - Table view delegate
extension EventTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < events.count else {
            return
        }

        let event = events[indexPath.row]
        let eventDetailVC = EventDetailViewController.instantiateFromXib()
        eventDetailVC.event = event
        self.navigationController?.show(eventDetailVC, sender: self)
    }
}
