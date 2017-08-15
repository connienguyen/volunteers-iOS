//
//  UserModel.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/3/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import RealmSwift
import FirebaseAuth.FIRUser

/**
    Login providers that can be connected to a single Firebase user account
 
    - facebook: Connected Facebook login
    - google: Connected Google login
    - email: Connected login via email and password
*/
enum LoginProvider: String {
    case facebook = "facebook.com"
    case google = "google.com"
    case email = "password"

    /// Array of login providers available
    static let allProviders: [LoginProvider] = [.facebook, .google, .email]

    /// Provider identifier used by Firebase, primarily for unlinking a login
    var providerID: String {
        return rawValue
    }
}

/// Model for User data
class User: Object {
    dynamic var uid: String = ""
    dynamic var title: String = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var affiliation: String = ""
    dynamic var email: String = ""
    dynamic var loginProvidersJoined: String = ""
    dynamic var imageURLString: String = ""
    // Computed values since their types are unsupported by Realm
    var providers: [LoginProvider?] {
        return loginProvidersJoined.components(separatedBy: ",")
            .map { LoginProvider(rawValue: $0) }
            .filter { $0 != nil }
    }
    var imageURL: URL? {
        return URL(string: imageURLString)
    }

    /// Primary key for Realm object so that it can be updated in data store
    override static func primaryKey() -> String? {
        return "uid"
    }

    /**
        Initializer for a customized User, such as from manual login or for mocking purposes
     
        - Parameters:
            - uid: Unique identifier for user
            - firstName: First name of the user
            - lastName: Last name of the user
            - email: Email address of user
    */
    convenience init(uid: String, firstName: String, lastName: String, email: String) {
        self.init()
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }

    /**
        Failable convenience initializer for User via Firebase authentication. Initialization fails
        if `displayName` or `email` properties on `firebaseUser` are nil
     
        - Parameters:
            - firebaseUser: Authenticated user data from Firebase
    */
    convenience init?(firebaseUser: FirebaseAuth.User) {
        self.init()
        guard let fullName = firebaseUser.displayName,
            let firebaseEmail = firebaseUser.email else {
                Logger.error(VLError.failedUserFirebase)
                return nil
        }
        uid = firebaseUser.uid
        email = firebaseEmail
        (firstName, lastName) = fullName.splitFullName()
        imageURLString = firebaseUser.photoURL?.absoluteString ?? ""
        loginProvidersJoined = firebaseUser.providerData
            .reduce("") { text, provider in
                "\(text),\(provider.providerID)"
            }

    }

    /**
        Failable convenience initializer for User via Firebase authentication and data from
        Firebase database snapshot. Fails whenever values `email`, `firstName`, or `lastName`
        from `firebaseUser` or `snapshotDict` are nil
     
        - Parameters:
            - firebaseUser: Authenticated user data from Firebase
            - snapshotDict: User data from Firebase database snapshot
    */
    convenience init?(firebaseUser: FirebaseAuth.User, snapshotDict: [String: Any]) {
        self.init()
        guard let firebaseEmail = firebaseUser.email else {
            Logger.error(VLError.failedUserFirebase)
            return nil
        }

        guard let firstName = snapshotDict[FirebaseKeys.User.firstName.key] as? String,
            let lastName = snapshotDict[FirebaseKeys.User.lastName.key] as? String else {
                Logger.error(VLError.failedUserSnapshot)
                return nil
        }
        uid = firebaseUser.uid
        self.email = firebaseEmail
        self.firstName = firstName
        self.lastName = lastName
        imageURLString = firebaseUser.photoURL?.absoluteString ?? ""
        loginProvidersJoined = firebaseUser.providerData
            .reduce("") { text, provider in
                "\(text),\(provider.providerID)"
            }

        // These values from the Firebase snapshot may be nil if the user did not set them
        // after logging in via a social login
        if let title = snapshotDict[FirebaseKeys.User.title.key] as? String {
            self.title = title
        }
        if let affiliation = snapshotDict[FirebaseKeys.User.affiliation.key] as? String {
            self.affiliation = affiliation
        }
    }
}
