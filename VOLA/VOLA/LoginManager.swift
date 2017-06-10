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
}
