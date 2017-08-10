//
//  LoginManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FirebaseAuth
import PromiseKit

/// Manager for handling the available login methods
final class LoginManager {
    static let shared = LoginManager()

    private init() { /* Intentionally left empty */ }

    /**
        Log in user using given `strategy` and set `currentUser` on `DataManager`
     
        - Parameters:
            - strategy: Authentication strategy to log in with
     
        - Returns: User promise if login is successful, otherwise error
    */
    func login(_ strategy: AvailableLoginStrategies) -> Promise<Bool> {
        return strategy.login()
            .then { user -> Bool in
                DataManager.shared.setUserUpdateStoredUser(user)
                NotificationCenter.default.post(name: NotificationName.userLogin, object: nil)
                return true
        }
    }

    /// Log out current user from social networks and set `currentUser` on `DataManater` to nil
    func logOut() {
        guard DataManager.shared.currentUser != nil else {
            Logger.error(VLError.notLoggedIn)
            return
        }

        /// Log out of any providers
        if let firebaseUser = Auth.auth().currentUser {
            for provider in firebaseUser.providerData {
                if let loginProvider = LoginProvider(rawValue: provider.providerID) {
                    switch loginProvider {
                    case .facebook:
                        FBSDKLoginManager().logOut()
                    case .google:
                        GIDSignIn.sharedInstance().signOut()
                    case .email:
                        // log out occurs below from Firebase
                        break
                    }
                }
            }

            do {
                // All log in goes through Firebase, so after logging out of any
                // applicable social networks, log out of Firebase to complete logout
                try Auth.auth().signOut()
            } catch let signOutError {
                Logger.error(signOutError)
            }
        }

        DataManager.shared.setUserUpdateStoredUser(nil)
    }

    /**
        Update user data on remote server and then update local data to match given a strategy
 
        - Parameters:
            - strategy: User update strategy to update user data with
     
        - Returns: Boolean promise whether or not user update was successful
    */
    func updateUser(_ strategy: AvailableUserUpdateStrategies) -> Promise<Bool> {
        return strategy.update()
            .then { user -> Bool in
                DataManager.shared.setUserUpdateStoredUser(user)
                return true
            }
    }

    /**
        Connect a provider login to user's Firebase account so user can use multiple providers to
            log into one account
     
        - Parameters:
            - strategy: Strategy for connecting a provider login to user's account
     
        - Returns: Boolean promise that returns true if successful
    */
    func addConnectedLogin(_ strategy: AvailableConnectLoginStrategies) -> Promise<Bool> {
        return strategy.connectLogin()
    }

    /**
        Remove a connected provider login from user's Firebase account
     
        - Parameters:
            - provider: Login provider to remove from user's account
     
        - Returns: Boolean promise that returns true if successfull
    */
    func removeConnectedLogin(_ provider: LoginProvider) -> Promise<Bool> {
        return Promise { fulfill, reject in
            guard let currentUser = Auth.auth().currentUser else {
                reject(AuthenticationError.notLoggedIn)
                return
            }

            currentUser.unlink(fromProvider: provider.providerID, completion: { (updatedUser, error) in
                guard let firebaseUser = updatedUser, error == nil else {
                    let unlinkError = error ?? AuthenticationError.invalidFirebaseAuth
                    reject(unlinkError)
                    return
                }

                DataManager.shared.setUserUpdateStoredUser(User(firebaseUser: firebaseUser))
                fulfill(true)
            })
        }
    }
}
