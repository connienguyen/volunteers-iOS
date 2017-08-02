//
//  LoginsManagerTableViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/1/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class LoginsManagerTableViewController: UITableViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addNotificationObserver(NotificationName.googleDidSignIn, selector: #selector(googleDidSignIn(_:)))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeNotificationObserver(NotificationName.googleDidSignIn)
    }
}

// MARK: - Table view data source
extension LoginsManagerTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO account for indexPath
        let cell = tableView.dequeue(indexPath, cellType: ConnectedLoginCell.self)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConnectedLoginCell.estimatedCellHeight
    }
}

// MARK: - Table view delegate
extension LoginsManagerTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO open connected login flow
        print("Attempt to connect login")
        GIDSignIn.sharedInstance().signIn()
    }
}

// MARK: - NotificationObserver
extension LoginsManagerTableViewController {
    func googleDidSignIn(_ notification: NSNotification) {
        LoginManager.shared.addConnectedLogin(.google(notification))
            .then { _ -> Void in
                // TODO update table
                print("Update table")
            }.catch { error in
                Logger.error(error)
            }
    }
}
