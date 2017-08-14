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
    case firebase(String, String)
    case custom(Promise<User>)
}

// MARK: - UserUpdateStrategy
extension AvailableUserUpdateStrategies: UserUpdateStrategy {
    /// Update user data on remote service based on selected strategy
    func update() -> Promise<User> {
        switch self {
        case .firebase(let name, let email):
            return FirebaseUserUpdateStrategy(name: name, email: email).update()
        case .custom(let userPromise):
            return userPromise
        }
    }
}

// MARK: - UserUpdateStrategy
/// Strategy for updating user data on Firebase servers
struct FirebaseUserUpdateStrategy: UserUpdateStrategy {
    let name: String
    let email: String

    /**
    Update user data on Firebase servers
     
    - Returns: User promise of updated user model
    */
    func update() -> Promise<User> {
        return Promise { fulfill, reject in
            guard let firebaseUser = Auth.auth().currentUser else {
                reject(AuthenticationError.invalidFirebaseAuth)
                return
            }

            let changeRequest = firebaseUser.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges(completion: { (updateError) in
                guard updateError == nil else {
                    let error = updateError ?? AuthenticationError.invalidFirebaseAuth
                    reject(error)
                    return
                }

                if firebaseUser.email != self.email {
                    firebaseUser.updateEmail(to: self.email, completion: { (updateError) in
                        guard updateError == nil else {
                            let error = updateError ?? AuthenticationError.invalidFirebaseAuth
                            reject(error)
                            return
                        }

                        guard let userFromFirebase = User(firebaseUser: firebaseUser) else {
                            reject(VLError.failedUserFirebase)
                            return
                        }
                        fulfill(userFromFirebase)
                    })
                } else {
                    guard let userFromFirebase = User(firebaseUser: firebaseUser) else {
                        reject(VLError.failedUserFirebase)
                        return
                    }
                    fulfill(userFromFirebase)
                }
            })

        }
    }
}
