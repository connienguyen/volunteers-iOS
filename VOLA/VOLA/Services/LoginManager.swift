//
//  LoginManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import FBSDKLoginKit
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
                DataManager.shared.setUser(user)
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
            // TODO: Print statement used as placeholder for manual logOut
            print("Manual logout")
        }
        DataManager.shared.setUser(nil)
    }

    func updateUser(name: String, email: String, completion: @escaping ErrorCompletionBlock) {
        // TODO - currently saving changes as if successful
        guard let currentUser = DataManager.shared.currentUser else {
            let error: Error = AuthenticationError.notLoggedIn
            completion(error)
            return
        }

        currentUser.name = name
        currentUser.email = email
        DataManager.shared.setUser(currentUser)
        completion(nil)
    }
}
