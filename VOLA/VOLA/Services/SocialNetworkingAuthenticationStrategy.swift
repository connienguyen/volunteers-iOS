//
//  SocialNetworkingAuthenticationStrategy.swift
//  VOLA
//
//  Protocols for user authentication (social logins and manual) for use with
//  LoginManager. Each strategy returns a Promise<User> for each respective
//  social network.
//
//  Created by Connie Nguyen on 6/16/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import PromiseKit

protocol SocialNetworkingAuthenticationStrategy {
    func login() -> Promise<User>
}

enum AvailableLoginStrategies {
    case facebook
    case google(NSNotification)
    case manualSignup(String, String, String)
    case manualLogin(String, String)
    case custom(Promise<User>)
}

extension AvailableLoginStrategies: SocialNetworkingAuthenticationStrategy {
    func login() -> Promise<User> {
        switch self {
        case .facebook:
            return FacebookAuthenticationStrategy().login()
        case .google(let notification):
            return GoogleAuthenticationStrategy(notification: notification).login()
        case .manualSignup(let name, let email, let password):
            return ManualSignUpStrategy(name: name, email: email, password: password).login()
        case .manualLogin(let email, let password):
            return ManualLoginStrategy(email: email, password: password).login()
        case .custom(let promise):
            return promise
        }
    }
}

struct FacebookAuthenticationStrategy: SocialNetworkingAuthenticationStrategy {
    func login() -> Promise<User> {
        return Promise { fulfill, reject in
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
        }
    }
}

struct GoogleAuthenticationStrategy: SocialNetworkingAuthenticationStrategy {
    let notification: NSNotification

    func login() -> Promise<User> {
        return Promise { fulfill, reject in
            guard let googleUser = notification.userInfo?[DictKeys.user.rawValue] as? GIDGoogleUser else {
                let error = AuthenticationError.invalidGoogleUser
                reject(error)
                return
            }

            fulfill(User(googleUser: googleUser))
        }
    }
}

struct ManualSignUpStrategy: SocialNetworkingAuthenticationStrategy {
    let name: String
    let email: String
    let password: String

    func login() -> Promise<User> {
        return Promise { fulfill, _ in
            // TODO - Need  API access + documentation to save created user on backend
            // temporarily saving the user and returning
            fulfill(User(name: name, email: email, userType: .manual))
        }
    }
}

struct ManualLoginStrategy: SocialNetworkingAuthenticationStrategy {
    let email: String
    let password: String

    func login() -> Promise<User> {
        return Promise { fulfill, _ in
            // TODO - Need API access + documentation to log in user on backend
            // temporarily saving the user and returning (Gives user a default name for now)
            // "Default Name" name is temporary and will be changed once hooked up to backend
            fulfill(User(name: UIDisplay.defaultName.localized, email: email, userType: .manual))
        }
    }
}
