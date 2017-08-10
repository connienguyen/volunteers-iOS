//
//  LoginsManagerTableViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/1/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import FBSDKLoginKit

fileprivate let addLoginErrorKey = "add-login-error.title.label"
fileprivate let removeLoginErrorKey = "remove-login-error.title.label"

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
                showErrorAlert(errorTitle: removeLoginErrorKey.localized,
                               errorMessage: VLError.minimumConnectedLogins.localizedDescription)
            }
        } else {
            switch provider {
            case .google:
                GIDSignIn.sharedInstance().signIn()
            case .facebook:
                FBSDKLoginManager().logIn(withReadPermissions: FBRequest.readPermissions, from: self, handler: { (_, error) in
                    guard error == nil else {
                        let fbError = error ?? AuthenticationError.invalidFacebookToken
                        Logger.error(fbError)
                        return
                    }

                    self.addConnectedLogin(.facebook)
                })
            case .email:
                let connectVC: ConnectEmailViewController = UIStoryboard(.login).instantiateViewController()
                connectVC.delegate = self
                show(connectVC, sender: self)
            }
        }
    }

    /**
        Add a connected login to Firebase account given a `strategy`. Update tableview
        display if connection was successful.
     
        - Parameters:
            - strategy: Strategy to add connected login by (email, facebook, etc)
    */
    func addConnectedLogin(_ strategy: AvailableConnectLoginStrategies) {
        displayActivityIndicator()
        LoginManager.shared.addConnectedLogin(strategy)
            .then { [weak self] _ -> Void in
                guard let `self` = self else {
                    return
                }

                self.tableView.reloadData()
            }.always { [weak self] in
                guard let `self` = self else {
                    return
                }

                self.removeActivityIndicator()
            }.catch { [weak self] error in
                guard let `self` = self else {
                    Logger.error(error)
                    return
                }

                self.showErrorAlert(errorTitle: addLoginErrorKey.localized,
                                    errorMessage: error.localizedDescription)
        }
    }

    /**
        Remove a connected login from Firebase account and reflect changes in the
        tableview.
     
        - Parameters:
            - provider: Provider of connected login to be removed
    */
    private func removeConnectedLoginUpdateTable(_ provider: LoginProvider) {
        displayActivityIndicator()
        LoginManager.shared.removeConnectedLogin(provider)
            .then { [weak self] _ -> Void in
                guard let `self` = self else {
                    return
                }

                self.tableView.reloadData()
            }.always { [weak self] in
                guard let `self` = self else {
                    return
                }

                self.removeActivityIndicator()
            }.catch { [weak self] error in
                guard let `self` = self else {
                    Logger.error(error)
                    return
                }
                self.showErrorAlert(errorTitle: removeLoginErrorKey.localized,
                                    errorMessage: error.localizedDescription)
            }
    }
}

// MARK: - NotificationObserver; For Google sign in
extension LoginsManagerTableViewController {
    /**
        Add connected login after user has signed in with Google
     
        - Parameters:
            - notification: Notifies view controller of Google signin and holds authenticated Google user data
    */
    func googleDidSignIn(_ notification: NSNotification) {
        addConnectedLogin(.google(notification))
    }
}

// MARK: - ConnectEmailViewControllerDelegate
extension LoginsManagerTableViewController: ConnectEmailViewControllerDelegate {
    func emailDidConnect(email: String, password: String) {
        addConnectedLogin(.email(email: email, password: password))
    }
}
