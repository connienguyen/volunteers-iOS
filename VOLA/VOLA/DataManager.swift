//
//  DataManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/5/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class DataManager {

    static let sharedInstance = DataManager()

    private var _currentUser: UserModel?

    var currentUser: UserModel? {
        return _currentUser
    }

    func logIn(user: UserModel) {
        _currentUser = user
    }

    func logOut() {
        if let user = _currentUser {
            switch user.userType {
            case .google:
                GIDSignIn.sharedInstance().signOut()
            case .facebook:
                FBSDKLoginManager().logOut()
            default:
                print("TODO")
            }

            _currentUser = nil
        }
    }
}
