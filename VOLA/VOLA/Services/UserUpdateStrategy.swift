//
//  UserUpdateStrategy.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/22/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import PromiseKit
import FirebaseAuth

/// Protocol for updating user data on remote server
protocol UserUpdateStrategy {
    func update() -> Promise<User>
}

/**
Available strategies to update user data on remote service
 
 - firebase: Strategy to update user on Firebase servers
*/
enum AvailableUserUpdateStrategies {
    case firebase(title: String, firstName: String, lastName: String, affiliation: String, email: String)
    case custom(Promise<User>)
}

// MARK: - UserUpdateStrategy
extension AvailableUserUpdateStrategies: UserUpdateStrategy {
    /// Update user data on remote service based on selected strategy
    func update() -> Promise<User> {
        switch self {
        case .firebase(let title, let firstName, let lastName, let affiliation, let email):
            return FirebaseUserUpdateStrategy(title: title, firstName: firstName, lastName: lastName, affiliation: affiliation, email: email).update()
        case .custom(let userPromise):
            return userPromise
        }
    }
}

// MARK: - UserUpdateStrategy
/// Strategy for updating user data on the Firebase database and authentication tables
struct FirebaseUserUpdateStrategy: UserUpdateStrategy {
    let title: String
    let firstName: String
    let lastName: String
    let affiliation: String
    let email: String

    func update() -> Promise<User> {
        return Promise { fulfill, reject in
            guard let currentFirebaseUser = Auth.auth().currentUser else {
                reject(AuthenticationError.invalidFirebaseAuth)
                return
            }

            let updates: [String: Any] = [
                FirebaseKeys.User.title.key: title,
                FirebaseKeys.User.firstName.key: firstName,
                FirebaseKeys.User.lastName.key: lastName,
                FirebaseKeys.User.affiliation.key: affiliation
            ]
            FirebaseDataManager.shared.updateUserInTable(firebaseUser: currentFirebaseUser, values: updates)
                .then { user -> Void in
                    // Update user email if old value and new value do not match
                    if self.email != currentFirebaseUser.email {
                        currentFirebaseUser.updateEmail(to: self.email, completion: { (updateError) in
                            guard updateError == nil else {
                                let error = updateError ?? AuthenticationError.invalidFirebaseAuth
                                reject(error)
                                return
                            }

                            // TODO update user from user
                            fulfill(user)
                        })
                    } else {
                        fulfill(user)
                    }
                }.catch { error in
                    reject(error)
                }
        }
    }
}
