//
//  LoginManager.swift
//  VOLA
//
//  LoginManager handles the various methods a user may login (sign up is an
//  implicit login)
//
//  Created by Connie Nguyen on 6/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import PromiseKit

class LoginManager {
    static let shared = LoginManager()

    private init() { /* Intentionally left empty */ }

    func login(user: User) {
        DataManager.shared.setUser(user)
    }

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

    func login(_ strategy: AvailableLoginStrategies) -> Promise<Bool> {
        return strategy.login()
            .then { user -> Bool in
                DataManager.shared.setUser(user)
                return true
            }
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
