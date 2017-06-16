//
//  EventTableViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import PromiseKit
import Kingfisher

class EventTableViewController: UITableViewController, XIBInstantiable {

    var events: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cellType: EventCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250.0
        firstly { () -> Promise<[Event]> in
            displayActivityIndicator()
            return ETouchesAPIService.shared.getAvailableEvents()
        }.then { [weak self] (events) -> Void in
            guard let controller = self else {
                return
            }

            controller.events = events
            controller.tableView.reloadData()
        }.catch { error in
            Logger.error(error.localizedDescription)
        }.always { [weak self] in
            guard let controller = self else {
                return
            }

            controller.removeActivityIndicator()
        }
    }

    func configureCell(cell: EventCell, event: Event) {
        cell.nameLabel.text = event.name
        cell.addressLabel.text = event.location.addressString()
        cell.registeredLabel.isHidden = event.eventType == .unregistered
        cell.registeredLabel.text = event.eventType.labelText

        if let eventImageURL = event.eventImageURL {
            cell.eventImageView.kf.setImage(with: eventImageURL)
        }
    }
}

// MARK: - Table view data source
extension EventTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath, cellType: EventCell.self)
        guard indexPath.row < events.count else {
            return cell
        }

        let event = events[indexPath.row]
        configureCell(cell: cell, event: event)
        return cell
    }
}
