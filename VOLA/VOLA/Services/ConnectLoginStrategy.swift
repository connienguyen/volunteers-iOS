//
//  ConnectLoginStrategy.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/2/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import PromiseKit
import FirebaseAuth

/// Protocol for connecting an authentication provider to a Firebase account
protocol ConnectLoginStrategy {
    func connectLogin() -> Promise<Bool>
}

// Extension on ConnectLoginStrategy of helper functions that are common across strategies
extension ConnectLoginStrategy {
    /**
        Connect authorized provider login to Firebase account given `credential`
     
        - Parameters:
            - credential: Credential for login provider
     
        - Returns: Boolean Promise if connecting provider login to Firebase account was successful
    */
    func linkToFirebase(_ credential: FIRAuthCredential) -> Promise<Bool> {
        return Promise { fulfill, reject in
            guard let currentUser = FIRAuth.auth()?.currentUser else {
                reject(VLError.notLoggedIn)
                return
            }

            currentUser.link(with: credential, completion: { (_, linkError) in
                guard linkError == nil else {
                    let connectError = linkError ?? VLError.invalidFirebaseAction
                    reject(connectError)
                    return
                }

                fulfill(true)
            })
        }
    }
}

/**
    Available login connection strategies
 
    - facebook: Connect facetook login
    - google: Connect google login
    - email: Connect manual login
    - custom: user for testing/mocking purposes
*/
enum AvailableConnectLoginStrategies {
    case facebook
    case google(NSNotification)
    case email(email: String, password: String)
    case custom(Promise<Bool>)
}

// MARK: - ConnectLoginStrategy
extension AvailableConnectLoginStrategies: ConnectLoginStrategy {
    /// Connect login to Firebase account based on available login strategy
    func connectLogin() -> Promise<Bool> {
        switch self {
        case .facebook:
            return FacebookConnectLoginStrategy().connectLogin()
        case .google(let notification):
            return GoogleConnectLoginStrategy(notification: notification).connectLogin()
        case .email(let email, let password):
            return EmailConnectLoginStrategy(email: email, password: password).connectLogin()
        case .custom(let promise):
            return promise
        }
    }
}

// MARK: - ConnectLoginStrategy
/**
    Strategy for connecting a Facebook login to a Firebase user
*/
struct FacebookConnectLoginStrategy: ConnectLoginStrategy {
    /// Connect Facebook login to Firebase account
    func connectLogin() -> Promise<Bool> {
        return Promise { fulfill, reject in
            guard let fbTokenString = FBSDKAccessToken.current().tokenString else {
                reject(AuthenticationError.invalidFacebookToken)
                return
            }

            let credential = FIRFacebookAuthProvider.credential(withAccessToken: fbTokenString)
            linkToFirebase(credential)
                .then { success -> Void in
                    fulfill(success)
                }.catch { error in
                    reject(error)
                }
        }
    }
}

// MARK: - ConnectLoginStrategy
/**
    Strategy for connecting a Google login to a Firebase user
 
    - `notification`: Notification passed from Google sign in delegate with Google user data
*/
struct GoogleConnectLoginStrategy: ConnectLoginStrategy {
    let notification: NSNotification

    /// Connect Google login to Firebase account
    func connectLogin() -> Promise<Bool> {
        return Promise { fulfill, reject in
            guard let googleUser = notification.userInfo?[DictKeys.user.rawValue] as? GIDGoogleUser,
                let authentication = googleUser.authentication else {
                reject(AuthenticationError.invalidGoogleUser)
                return
            }

            let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            linkToFirebase(credential)
                .then { success -> Void in
                    fulfill(success)
                }.catch { error in
                    reject(error)
                }
        }
    }
}

// MARK: - ConnectLoginStrategy
/**
    Strategy for connecting an email/password login to a Firebase account

    - `email`: Email address to login with
    - `password`: Passowrd to login with
*/
struct EmailConnectLoginStrategy: ConnectLoginStrategy {
    let email: String
    let password: String

    /// Connect email/password login to Firebase account
    func connectLogin() -> Promise<Bool> {
        return Promise { fulfill, reject in
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
            linkToFirebase(credential)
                .then { success -> Void in
                    fulfill(success)
                }.catch { error in
                    reject(error)
                }
        }
    }
}
