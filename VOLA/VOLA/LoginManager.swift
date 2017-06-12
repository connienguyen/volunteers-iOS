//
//  LoginManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

final class LoginManager {
    static let shared = LoginManager()

    private init() { /* Intentionally left empty */ }

    func login(user: User) {
        DataManager.shared.setUser(user)
    }

    func logOut() {
        guard let user = DataManager.shared.currentUser else {
            return
        }

        user.userType.logOut()
        DataManager.shared.setUser(nil)
    }

    func loginFacebook(completion: @escaping ErrorCompletionBlock) {
        guard FBSDKAccessToken.current() != nil else {
            let error: Error = AuthenticationError.invalidFacebookToken
            completion(error)
            return
        }

        let parameters = ["fields": FBRequest.graphParameters]
        FBSDKGraphRequest(graphPath: FBRequest.graphPath, parameters: parameters)
            .start { (_, result, error) in
            guard error == nil else {
                completion(error)
                return
            }

            guard let response = result as? [String: Any] else {
                let error: Error = AuthenticationError.invalidFacebookResponse
                completion(error)
                return
            }

            self.login(user: User(fbResponse: response))
            completion(nil)
        }
    }

    func loginGoogle(notification: NSNotification, completion: @escaping ErrorCompletionBlock) {
        guard let googleUser = notification.userInfo?["user"] as? GIDGoogleUser else {
            let error = AuthenticationError.invalidGoogleUser
            completion(error)
            return
        }

        login(user: User(googleUser: googleUser))
        completion(nil)
    }

    func signUpManual(name: String, email: String, password: String, completion: @escaping ErrorCompletionBlock) {
        // TODO - Need API access + documentation to save create user on backend
        // temporarily saving the user and returning

        login(user: User(name: name, email: email, userType: .manual))
        completion(nil)
    }

    func loginManual(email: String, password: String, completion: @escaping ErrorCompletionBlock) {
        // TODO - Need API access + documentation to log in user on backend
        // temporarily saving the user and returning (Gives user a default name for now)

        login(user: User(name: "Default Name", email: email, userType: .manual))
        completion(nil)
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
