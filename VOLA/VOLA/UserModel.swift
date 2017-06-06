//
//  UserModel.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/3/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

enum UserType {
    case facebook
    case google
    case manual
}

class UserModel: NSObject {

    var name: String
    var email: String
    var userType: UserType

    init(name: String, email: String, userType: UserType) {
        self.name = name
        self.email = email
        self.userType = userType

        super.init()
    }

    init(googleUser: GIDGoogleUser) {
        name = googleUser.profile.name
        email = googleUser.profile.email
        userType = .google
    }

    init(fbResponse: [String: Any]) {
        name = fbResponse["name"] as? String ?? ""
        email = fbResponse["email"] as? String ?? ""
        userType = .facebook
    }
}
