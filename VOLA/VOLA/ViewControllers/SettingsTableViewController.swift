//
//  SettingsTableViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/1/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/// Table view controller where user can view and edit their settings
class SettingsTableViewController: UITableViewController {}

// MARK: - Table view data source
extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Update with count according to whether or not user is logged in (use viewModel)
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Account for indexPath
        let cell = tableView.dequeue(indexPath, cellType: ManageLoginsCell.self)
        return cell
    }
}

// MARK:- Table view delegate
extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO perform segue based on corrent settings cell
        performSegue(.showLoginsManager, sender: self)
    }
}
