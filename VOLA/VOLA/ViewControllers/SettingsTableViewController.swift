//
//  SettingsTableViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/1/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/// Table view controller where user can view and edit their settings
class SettingsTableViewController: UITableViewController {
    var viewModel = SettingsViewModel()
}

// MARK: - Table view data source
extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.availableSettings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = viewModel.availableSettings[indexPath.row]
        let cell = tableView.dequeue(indexPath, cellType: setting.cellType)
        switch setting {
        case .theme:
            cell.selectionStyle = .none
        case .connectedLogins:
            break
        }
        return cell
    }
}

// MARK: - Table view delegate
extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let setting = viewModel.availableSettings[indexPath.row]
        switch setting {
        case .connectedLogins:
            performSegue(.showLoginsManager, sender: self)
        case .theme:
            break
        }
    }
}
