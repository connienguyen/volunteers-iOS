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

// Extension on SocialNetworkingAuthenticationStrategy of helper functions that are common across strategies
extension SocialNetworkingAuthenticationStrategy {
    /**
    Login to Firebase given a credential to a login provider
     
    - Parameters:
        - credential: Credential for login provider
     
    - Returns: User Promise of Firebase user account
    */
    func loginToFirebase(_ credential: FIRAuthCredential) -> Promise<User> {
        return Promise { fulfill, reject in
            FIRAuth.auth()?.signIn(with: credential, completion: { (firebaseUser, error) in
                guard let user = firebaseUser, error == nil else {
                    let signInError = error ?? VLError.invalidFirebaseAction
                    reject(signInError)
                    return
                }

                fulfill(User(firebaseUser: user))
            })
        }
    }
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
    case emailSignup(String, String, String)
    case emailLogin(String, String)
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
        case .emailSignup(let name, let email, let password):
            return EmailSignUpStrategy(name: name, email: email, password: password).login()
        case .emailLogin(let email, let password):
            return EmailLoginStrategy(email: email, password: password).login()
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
            guard let fbTokenString = FBSDKAccessToken.current().tokenString else {
                reject(AuthenticationError.invalidFacebookToken)
                return
            }

            let credential = FIRFacebookAuthProvider.credential(withAccessToken: fbTokenString)
            loginToFirebase(credential)
                .then { user -> Void in
                    fulfill(user)
                }.catch { error in
                    reject(error)
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
            guard let googleUser = notification.userInfo?[DictKeys.user.rawValue] as? GIDGoogleUser,
                let authentication = googleUser.authentication else {
                reject(AuthenticationError.invalidGoogleUser)
                return
            }

            let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            loginToFirebase(credential)
                .then { user -> Void in
                    fulfill(user)
                }.catch { error in
                    reject(error)
                }
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
struct EmailSignUpStrategy: SocialNetworkingAuthenticationStrategy {
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

                // TODO: Save/set user to Firebase
                //FirebaseDataManager.shared.setUser(email: self.email)
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
struct EmailLoginStrategy: SocialNetworkingAuthenticationStrategy {
    let email: String
    let password: String

    /**
    Retrieve user from manual login
     
    - Returns: User promise populated with user data if successful
    */
    func login() -> Promise<User> {
        return Promise { fulfill, reject in
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
            loginToFirebase(credential)
                .then { user -> Void in
                    fulfill(user)
                }.catch { error in
                    reject(error)
                }
        }
    }
}
