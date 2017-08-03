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
    Log in user given an authentication strategy and sets currentUser on DataManager
     
    - Parameters:
        - strategy: Authentication strategy to log in with
     
    - Returns: User promise if login is successful
    */
    func login(_ strategy: AvailableLoginStrategies) -> Promise<Bool> {
        return strategy.login()
            .then { user -> Bool in
                DataManager.shared.setUserUpdateStoredUser(user)
                NotificationCenter.default.post(name: NotificationName.userLogin, object: nil)
                return true
        }
    }

    /**
    Log out current user from social network if applicable and set currentUser on DataManager to nil
    */
    func logOut() {
        guard let _ = DataManager.shared.currentUser else {
            Logger.error(VLError.notLoggedIn)
            return
        }

        /// Log out of any providers
        if let firebaseUser = FIRAuth.auth()?.currentUser {
            for provider in firebaseUser.providerData {
                if let loginProvider = LoginProvider(rawValue: provider.providerID) {
                    switch loginProvider {
                    case .facebook:
                        FBSDKLoginManager().logOut()
                    case .google:
                        GIDSignIn.sharedInstance().signOut()
                    default:
                        break
                    }
                }
            }

            do {
                try FIRAuth.auth()?.signOut()
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
    Link login to user's Firebase account
     
    - Parameters:
        - strategy: Connected login method for an authentication provider
     
    - Returns: Boolean promise of whether or not connection was successful
    */
    func addConnectedLogin(_ strategy: AvailableConnectLoginStrategies) -> Promise<Bool> {
        return strategy.connectLogin()
    }

    /**
    Unlink a connected login from a user's Firebase account
     
    - Parameters:
        - provider: Login provider to unlink from connected user account on Firebase
     
    - Returns: Boolean promise of whether or not removal of connected login was successful
    */
    func removeConnectedLogin(_ provider: LoginProvider) -> Promise<Bool> {
        return Promise { fulfill, reject in
            guard let currentUser = FIRAuth.auth()?.currentUser else {
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
