//
//  LoginsManagerTableViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/1/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

fileprivate let minimumLoginsTitleKey = "remove-login-error.title.label"

/// Table view where user can manage their connected logins
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

    deinit {
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
        cell.configureCell(provider, connectedStatus: viewModel.isConnected(provider))
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConnectedLoginCell.estimatedCellHeight
    }
}

// MARK: - Table view delegate
extension LoginsManagerTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let provider = viewModel.availableLogins[indexPath.row]
        toggleProviderLogin(provider)
    }

    /**
        Toggles connected login status and takes user through the appropriate flow for removing a login
            or adding a connected login
     
        - Parameters:
            - provider: Connected login to toggle
    */
    private func toggleProviderLogin(_ provider: LoginProvider) {
        if viewModel.isConnected(provider) {
            if viewModel.numberOfConnectedLogins() > 1 {
                // Can only remove login if there is more than one
                removeConnectedLoginUpdateTable(provider)
            } else {
                showErrorAlert(errorTitle: minimumLoginsTitleKey.localized,
                               errorMessage: VLError.minimumConnectedLogins.localizedDescription)
            }
        } else {
            switch provider {
            case .google:
                GIDSignIn.sharedInstance().signIn()
            case .email, .facebook:
                // TODO: Handle connected login case for email and facebook
                break
            }
        }
    }

    /// Removes a connected login from account and reflect changes in table
    private func removeConnectedLoginUpdateTable(_ provider: LoginProvider) {
        LoginManager.shared.removeConnectedLogin(provider)
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

// MARK: - NotificationObserver
extension LoginsManagerTableViewController {
    /**
        Add connected login after user has signed in with Google
     
        - Parameters:
            - notification: Notifies view controller of Google signin and holds authenticated Google user data
    */
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
