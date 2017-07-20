//
//  DataManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/5/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import RealmSwift

/// DataManager will manage data persistence for data such as currentUser and user events
final class DataManager {

    static let shared = DataManager()

    private var _currentUser: User?

    /// Publicly accessible value for user currently logged in
    var currentUser: User? {
        return _currentUser
    }

    var isLoggedIn: Bool {
        return _currentUser != nil
    }

    private init() { /* intentionally left empty */ }

    /**
    Set private current user variable
     
    - Parameters:
        - user: User model to set the current user to (nil to log out)
    */
    func setUser(_ user: User?) {
        saveUser(user)
        _currentUser = user
    }

    /**
    Save user to Realm database; Remove user from Realm if nil
     
    - Parameters:
        - user: User model to save to delete
    */
    func saveUser(_ user: User?) {
        let realm = try! Realm()
        try! realm.write {
            if let saveUser = user {
                realm.add(saveUser)
            } else if let currentUser = _currentUser {
                // if user to save is nil and current user is not nil
                realm.delete(currentUser)
            }
        }
    }

    /// Load user from Realm if is exists
    func loadUser() {
        _currentUser = try! Realm().objects(User.self).first
    }
}
