//
//  LoginsManagerTableViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/1/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class LoginsManagerTableViewController: UITableViewController, GIDSignInUIDelegate {
    var viewModel = ConnectedLoginViewModel()

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
        return viewModel.availableLogins.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath, cellType: ConnectedLoginCell.self)
        let provider = viewModel.availableLogins[indexPath.row]
        let isConnected = viewModel.loginIsConnected(provider)
        cell.configureCell(provider, connectedStatus: isConnected)
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
        let provider = viewModel.availableLogins[indexPath.row]
        let isConnected = viewModel.loginIsConnected(provider)
        let loginsCount = viewModel.connectedLoginsCount()
        if isConnected && loginsCount > 1 {
            LoginManager.shared.removeConnectedLogin(provider)
                .then { [weak self] _ -> Void in
                    guard let `self` = self else {
                        return
                    }

                    self.tableView.reloadData()
                }.catch { error in
                    Logger.error(error)
                }
        } else if isConnected && loginsCount <= 1 {
            // Show error message, must have one login
        } else {
            switch provider {
            case .google:
                GIDSignIn.sharedInstance().signIn()
            default:
                break
            }
        }
    }
}

// MARK: - NotificationObserver
extension LoginsManagerTableViewController {
    func googleDidSignIn(_ notification: NSNotification) {
        LoginManager.shared.addConnectedLogin(.google(notification))
            .then { [weak self] _ -> Void in
                guard let `self` = self else {
                    return
                }

                self.tableView.reloadData()
            }.catch { error in
                Logger.error(error)
            }
    }
}
