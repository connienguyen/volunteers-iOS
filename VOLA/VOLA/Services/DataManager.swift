//
//  DataManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/5/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

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
        do {
            if let saveUser = user {
                // Create or update user in data store
                try DataStoreManager.shared.save(saveUser, replace: true)
            } else if _currentUser != nil {
                // _currentUser is being set to nil (log out), clear data store of User objecs
                try DataStoreManager.shared.deleteAll(of: User.self)
            }
        } catch {
            Logger.error(error)
        }

        _currentUser = user
    }

    /// Load user from data store if one exists and set it as the current user
    func loadUserIfExists() {
        // If there is no user in data store, no need to set _currentUser
        guard let savedUser = DataStoreManager.shared.loadFirst(of: User.self) else {
            return
        }

        _currentUser = savedUser
    }
}
