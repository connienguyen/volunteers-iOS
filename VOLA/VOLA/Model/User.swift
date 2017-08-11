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
    dynamic var name: String = ""
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
            - name: Full name of user
            - email: Email address of user
    */
    convenience init(uid: String, name: String, email: String) {
        self.init()
        self.uid = uid
        self.name = name
        self.email = email
    }

    /**
        Convenience initializer for User via Firebase authentication
     
        - Parameters:
            - firebaseUser: Authenticated user data from Firebase
    */
    convenience init(firebaseUser: FirebaseAuth.User) {
        self.init()
        uid = firebaseUser.uid
        name = firebaseUser.displayName ?? ""
        email = firebaseUser.email ?? ""
        imageURLString = firebaseUser.photoURL?.absoluteString ?? ""
        loginProvidersJoined = firebaseUser.providerData
            .reduce("") { text, provider in
                "\(text),\(provider.providerID)"
            }
    }

    /**
        Failable convenience initializer for User via Firebase authentication and data from
            Firebase database snapshot
     
        - Parameters:
            - firebaseUser: Authenticated user data from Firebase
            - snapshotDict: User data from Firebase database snapshot
    */
    convenience init?(firebaseUser: FirebaseAuth.User, snapshotDict: [String: Any]) {
        self.init()
        uid = firebaseUser.uid
        email = firebaseUser.email ?? ""
        imageURLString = firebaseUser.photoURL?.absoluteString ?? ""
        loginProvidersJoined = firebaseUser.providerData
            .reduce("") { text, provider in
                "\(text),\(provider.providerID)"
            }

        guard let firstName = snapshotDict[FirebaseKeys.User.firstName.key] as? String,
            let lastName = snapshotDict[FirebaseKeys.User.lastName.key] as? String else {
                Logger.error(VLError.failedUserSnapshot)
                return nil
        }
        name = "\(firstName) \(lastName)"
    }
}
