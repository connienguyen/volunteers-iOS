//
//  UserModel.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/3/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import RealmSwift
import FirebaseAuth

/**
Possible login methods used by the user (there must be at least one)
 
 - facebook: Login via Facebook
 - google: Login via Google
 - email: Login via email and password
*/
enum LoginProvider: String {
    case facebook = "facebook.com"
    case google = "google.com"
    case email = "password"

    static let allProviders: [LoginProvider] = [.facebook, .google, .email]

    var providerID: String {
        return rawValue
    }
}

/// Model for User data
class User: Object {
    dynamic var uid: String = ""
    dynamic var name: String = ""
    dynamic var email: String = ""
    dynamic var providersRawJoined: String = ""
    dynamic var imageURLString: String = ""
    // Computed values since their types are unsupported by Realm
    var providers: [LoginProvider?] {
        return providersRawJoined.components(separatedBy: ",")
            .map { LoginProvider(rawValue: $0) }
            .filter { $0 != nil }
    }
    var imageURL: URL? {
        return URL(string: imageURLString)
    }

    /// Primary key for Realm object so that it can up updated in data store
    override static func primaryKey() -> String? {
        return "uid"
    }

    /**
    Initializer for a customized User, such as from manual login or for mocking purposes
     
    - Parameters:
        - name: Full name of user
        - email: Email address of user
        - userType: Method that user logged in
    */
    convenience init(uid: String, name: String, email: String) {
        self.init()
        self.uid = uid
        self.name = name
        self.email = email
    }

    /**
    Initializer for User from manual login via Firebase
     
    - Parameters:
        - firebaseUser: FIRUser object response from Firebase API
    */
    convenience init(firebaseUser: FIRUser) {
        self.init()
        uid = firebaseUser.uid
        name = firebaseUser.displayName ?? ""
        email = firebaseUser.email ?? ""
        imageURLString = firebaseUser.photoURL?.absoluteString ?? ""
        providersRawJoined = firebaseUser.providerData
            .reduce("") { text, provider in
                "\(text),\(provider.providerID)"
            }
    }
}
