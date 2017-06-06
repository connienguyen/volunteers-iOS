//
//  DataManager.swift
//  VOLA
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

    func setUser(_ user: User?) {
        _currentUser = user
    }
}
