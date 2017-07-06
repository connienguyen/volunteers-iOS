//
//  DataManager.swift
//  VOLA
//
//  DataManager will manage data persistence for data such as currentUser and user events
//
//  Created by Connie Nguyen on 6/5/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

final class DataManager {

    static let shared = DataManager()

    private var _currentUser: User?

    var currentUser: User? {
        return _currentUser
    }

    var isLoggedIn: Bool {
        return _currentUser != nil
    }

    private init() { /* intentionally left empty */ }

    func setUser(_ user: User?) {
        _currentUser = user
    }
}
