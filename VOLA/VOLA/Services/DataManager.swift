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
        if let saveUser = user, _currentUser == nil {
            DataStoreManager.shared.save(saveUser)
        }
        _currentUser = user
    }
}
