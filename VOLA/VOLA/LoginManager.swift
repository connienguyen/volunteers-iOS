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

class LoginManager {
    static let shared = LoginManager()

    private init() { /* Intentionally left empty */ }

    func login(user: User) {
        DataManager.shared.setUser(user)
    }

    func logOut() {
        guard let user = DataManager.shared.currentUser else {
            Logger.error("Attempted to log out when not logged in.")
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

    func login(authenticationPromise: Promise<User>) -> Promise<Bool> {
        return authenticationPromise
            .then { user -> Bool in
                DataManager.shared.setUser(user)
                return true
        }
    }

    func loginFacebook() -> Promise<Bool> {
        return login(authenticationPromise: Promise {fulfill, reject in
            guard FBSDKAccessToken.current() != nil else {
                let error: Error = AuthenticationError.invalidFacebookToken
                reject(error)
                return
            }

            let parameters = [DictKeys.fields.rawValue: FBRequest.graphParameters]
            FBSDKGraphRequest(graphPath: FBRequest.graphPath, parameters: parameters).start { (_, result, error) in
                guard error == nil else {
                    reject(error ?? AuthenticationError.invalidFacebookResponse)
                    return
                }

                guard let response = result as? [String: Any] else {
                    reject(AuthenticationError.invalidFacebookResponse)
                    return
                }

                fulfill(User(fbResponse: response))
            }
        })
    }

    func loginGoogle(notification: NSNotification) -> Promise<Bool> {
        return login(authenticationPromise: Promise {fulfill, reject in
            guard let googleUser = notification.userInfo?[DictKeys.user.rawValue] as? GIDGoogleUser else {
                let error = AuthenticationError.invalidGoogleUser
                reject(error)
                return
            }

            fulfill(User(googleUser: googleUser))
        })
    }

    func signUpManual(name: String, email: String, password: String) -> Promise<Bool> {
        return login(authenticationPromise: Promise {fulfill, reject in
            // TODO - Need API access + documentation to save create user on backend
            // temporarily saving the user and returning

            fulfill(User(name: name, email: email, userType: .manual))
        })
    }

    func loginManual(email: String, password: String) -> Promise<Bool> {
        return login(authenticationPromise: Promise {fulfill, reject in
            // TODO - Need API access + documentation to log in user on backend
            // temporarily saving the user and returning (Gives user a default name for now)
            // "Default Name" name is temporary and will be changed once hooked up to backend

            fulfill(User(name: "Default Name", email: email, userType: .manual))
        })
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
