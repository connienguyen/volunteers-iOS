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
        guard let user = DataManager.shared.currentUser else {
            Logger.error(VLError.notLoggedIn)
            return
        }
        switch user.userType {
        case .facebook:
            FBSDKLoginManager().logOut()
        case .google:
            GIDSignIn.sharedInstance().signOut()
        case .manual:
            guard let firebaseAuth = FIRAuth.auth() else {
                Logger.error(AuthenticationError.invalidFirebaseAuth)
                return
            }

            do {
                try firebaseAuth.signOut()
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
}
