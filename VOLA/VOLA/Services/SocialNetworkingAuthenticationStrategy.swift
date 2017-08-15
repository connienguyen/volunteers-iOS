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

// Extension of SocialNetworkingAuthenticationStrategy with functions common across different strategies
extension SocialNetworkingAuthenticationStrategy {
    /**
        Login to Firebase using `credential` for a provider login
     
        - Parameters:
            - credential: Credential for a provider login
     
        - Returns: User Promise of connected Firebase user
    */
    func loginToFirebase(_ credential: AuthCredential) -> Promise<User> {
        return Promise { fulfill, reject in
            Auth.auth().signIn(with: credential, completion: { (firebaseUser, error) in
                guard let user = firebaseUser, error == nil else {
                    let signInError = error ?? VLError.invalidFirebaseAction
                    reject(signInError)
                    return
                }

                FirebaseDataManager.shared.userFromTable(firebaseUser: user)
                    .then { userInTable -> Promise<User> in
                        if let foundUser = userInTable {
                            return Promise { fulfill, _ in fulfill(foundUser) }
                        } else {
                            // Create user in Firebase database users table
                            var (firstName, lastName) = ("", "")
                            if let displayName = user.displayName {
                                (firstName, lastName) = displayName.splitFullName()
                            }
                            let values: [String: Any] = [
                                FirebaseKeys.User.firstName.key: firstName,
                                FirebaseKeys.User.lastName.key: lastName
                            ]
                            return FirebaseDataManager.shared.updateUserInTable(firebaseUser: user, values: values)
                        }
                    }.then { savedUserInTable -> Void in
                        fulfill(savedUserInTable)
                    }
            })
        }
    }
}

/**
    Available user authentication strategies

    - facebook: Login through Facebook
    - google: Login through Google
    - emailSignup: Sign up for an account (implicit login)
    - emailLogin: Login using email and password
    - custom: Use for testing/mocking purposes
*/
enum AvailableLoginStrategies {
    case facebook
    case google(NSNotification)
    case emailSignup(title: String, firstName: String, lastName: String, affiliation: String, email: String, password: String)
    case emailLogin(email: String, password: String)
    case custom(Promise<User>)
}

// MARK: - SocialNetworkingAuthenticationStrategy
extension AvailableLoginStrategies: SocialNetworkingAuthenticationStrategy {
    /// Login based on user authentication strategy
    func login() -> Promise<User> {
        switch self {
        case .facebook:
            return FacebookAuthenticationStrategy().login()
        case .google(let notification):
            return GoogleAuthenticationStrategy(notification: notification).login()
        case .emailSignup(let title, let firstName, let lastName, let affiliation, let email, let password):
            return EmailSignUpStrategy(title: title,
                                       firstName: firstName,
                                       lastName: lastName,
                                       affiliation: affiliation,
                                       email: email,
                                       password: password).login()
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
        Use Facebook access token to login to Firebase connected account
     
        - Returns: User promise populated with data from connected Firebase user if sucessful
    */
    func login() -> Promise<User> {
        return Promise { fulfill, reject in
            guard let fbTokenString = FBSDKAccessToken.current().tokenString else {
                reject(AuthenticationError.invalidFacebookToken)
                return
            }

            let credential = FacebookAuthProvider.credential(withAccessToken: fbTokenString)
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
 
    - `notification`: Notification passed from Google sign in delegate with Google user data
*/
struct GoogleAuthenticationStrategy: SocialNetworkingAuthenticationStrategy {
    let notification: NSNotification

    /**
        Use authenticated Google user data from `notification` to login to Firebase connected account
     
        - Returns: User promise populated with data from connected Firebase user if successful
    */
    func login() -> Promise<User> {
        return Promise { fulfill, reject in
            guard let googleUser = notification.userInfo?[DictKeys.user.rawValue] as? GIDGoogleUser,
                let authentication = googleUser.authentication else {
                reject(AuthenticationError.invalidGoogleUser)
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
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
    Strategy for creating a new user account on Firebase and implicitly logging in through signup
 
    - `name`: Full name for new user
    - `email`: Email address to sign up with and use for login
    - `password`: Password to sign up with and user for login
*/
struct EmailSignUpStrategy: SocialNetworkingAuthenticationStrategy {
    let title: String
    let firstName: String
    let lastName: String
    let affiliation: String
    let email: String
    let password: String

    /**
        Create new Firebase user account and updated user information on Firebase to match `name`
     
        - Returns: User promise populated with data from connected Firebase user if successful
    */
    func login() -> Promise<User> {
        return Promise { fulfill, reject in
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, signUpError) in
                guard let firebaseUser = user else {
                    let error = signUpError ?? AuthenticationError.invalidFirebaseAuth
                    reject(error)
                    return
                }

                let values: [String: Any] = [
                    FirebaseKeys.User.title.key: self.title,
                    FirebaseKeys.User.firstName.key: self.firstName,
                    FirebaseKeys.User.lastName.key: self.lastName,
                    FirebaseKeys.User.affiliation.key: self.affiliation
                ]
                FirebaseDataManager.shared.updateUserInTable(firebaseUser: firebaseUser, values: values)
                    .then { updatedUser in
                        fulfill(updatedUser)
                    }.catch { error in
                        Logger.error(error)
                    }
            })
        }
    }
}

// MARK: - SocialNetworkingAuthenticationStrategy
/**
    Strategy for logging in to a Firebase account manually
 
    - `email`: Email address to login wtih
    - `password`: Password to login with
*/
struct EmailLoginStrategy: SocialNetworkingAuthenticationStrategy {
    let email: String
    let password: String

    /**
        Login to Firebase account given an `email` and `password`
     
        - Returns: Use promise populated with data from connected Firebase user if successful
    */
    func login() -> Promise<User> {
        return Promise { fulfill, reject in
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            loginToFirebase(credential)
                .then { user -> Void in
                    fulfill(user)
                }.catch { error in
                    reject(error)
                }
        }
    }
}
