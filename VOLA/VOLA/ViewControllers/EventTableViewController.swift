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
    var tableType: EventTableType = .home
    private var isShown: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cellType: EventCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = EventCell.estimatedHeight

        // If child viewcontroller, will still recieve notification and update
        if tableType == .home {
            addNotificationObserver(NotificationName.availableEventsUpdated, selector: #selector(eventsDidUpdate(_:)))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if tableType == .calendar {
            addNotificationObserver(NotificationName.calendarEventsUpdated, selector: #selector(eventsDidUpdate(_:)))
        }
        // Since view controller is instantiated from XIB file, need to do first load
        // UI setup here (set title, retrieve events for data source)
        guard !isShown else {
            return
        }

        isShown = true
        self.title = tableType.rawValue
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if tableType == .calendar {
            removeNotificationObserver(NotificationName.calendarEventsUpdated)
        }
    }

    deinit {
        // Remove notification here instead of viewWillDisappear so non-active child viewcontroller
        // can still receive notification
        removeNotificationObserver(NotificationName.availableEventsUpdated)
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
        let event = events[indexPath.row]
        let eventDetailVC = EventDetailViewController.instantiateFromXib()
        eventDetailVC.event = event
        self.navigationController?.show(eventDetailVC, sender: self)
    }
}

// MARK: - Notification observer
extension EventTableViewController {
    func eventsDidUpdate(_ notification: NSNotification) {
        guard let updatedEvents = notification.object as? [Event] else {
            return
        }

        events = updatedEvents
        tableView.reloadData()
    }
}
