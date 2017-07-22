//
//  SocialNetworkingAuthenticationStrategy.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/16/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import PromiseKit
import FirebaseAuth

/// Protocol for user authentication (social login and manual) for user with LoginManager
protocol SocialNetworkingAuthenticationStrategy {
    func login() -> Promise<User>
}

/**
Available user authentication strategies

 - facebook: Login through Facebook
 - google: Login through Google
 - manualSignup: Sign up for an account (implicit login)
 - manualLogin: Login using email and password
 - custom: Use for testing/mocking purposes
*/
enum AvailableLoginStrategies {
    case facebook
    case google(NSNotification)
    case manualSignup(String, String, String)
    case manualLogin(String, String)
    case custom(Promise<User>)
}

// MARK: - SocialNetworkingAuthenticationStrategy
extension AvailableLoginStrategies: SocialNetworkingAuthenticationStrategy {
    /**
    Login based on the selected user authentication method
    */
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

// MARK: - SocialNetworkingAuthenticationStrategy
/// Strategy for user authentication via Facebook
struct FacebookAuthenticationStrategy: SocialNetworkingAuthenticationStrategy {
    /**
    Retrieve user data from Facebook
     
    - Returns: User promise populated with Facebook user data if successful
    */
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

// MARK: - SocialNetworkingAuthenticationStrategy
/**
Strategy for user authentication via Google
 
- notification: Notification passed from Google sign in delegate with Google user data
*/
struct GoogleAuthenticationStrategy: SocialNetworkingAuthenticationStrategy {
    let notification: NSNotification

    /**
    Retrieve Google user data passed via notification
     
    - Returns: User promise populated with Google user data if successful
    */
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

// MARK: - SocialNetworkingAuthenticationStrategy
/**
Strategy for user authentication by creating a new user account
 
- name: Full name for new user account
- email: Email address to sign up with
- password: Password to sign up with
*/
struct ManualSignUpStrategy: SocialNetworkingAuthenticationStrategy {
    let name: String
    let email: String
    let password: String

    /**
    Retrieve newly created user
     
    - Returns: User promise populated with new user data if successful
    */
    func login() -> Promise<User> {
        return Promise { fulfill, reject in
            guard let firebaseAuth = FIRAuth.auth() else {
                reject(AuthenticationError.invalidFirebaseAuth)
                return
            }

            firebaseAuth.createUser(withEmail: email, password: password, completion: { (user, signUpError) in
                guard let firebaseUser = user else {
                    let error = signUpError ?? AuthenticationError.invalidFirebaseAuth
                    reject(error)
                    return
                }

                let changeRequest = firebaseUser.profileChangeRequest()
                changeRequest.displayName = self.name
                changeRequest.commitChanges(completion: { (profileError) in
                    guard profileError == nil else {
                        let error = profileError ?? AuthenticationError.invalidFirebaseAuth
                        reject(error)
                        return
                    }

                    fulfill(User(firebaseUser: firebaseUser))
                })
            })
        }
    }
}

// MARK: - SocialNetworkingAuthenticationStrategy
/**
Strategy for user authentication by manually logging in
 
- email: Email address to log in with
- password: Password to log in with
*/
struct ManualLoginStrategy: SocialNetworkingAuthenticationStrategy {
    let email: String
    let password: String

    /**
    Retrieve user from manual login
     
    - Returns: User promise populated with user data if successful
    */
    func login() -> Promise<User> {
        return Promise { fulfill, reject in
            guard let firebaseAuth = FIRAuth.auth() else {
                reject(AuthenticationError.invalidFirebaseAuth)
                return
            }

            firebaseAuth.signIn(withEmail: email, password: password, completion: { (user, loginError) in
                guard let firebaseUser = user else {
                    let error = loginError ?? AuthenticationError.invalidFirebaseAuth
                    reject(error)
                    return
                }

                fulfill(User(firebaseUser: firebaseUser))
            })
        }
    }
}
