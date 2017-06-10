//
//  UserModel.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/3/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import FBSDKLoginKit

enum UserType {
    case facebook
    case google
    case manual

    func logOut() {
        switch self {
        case .facebook:
            FBSDKLoginManager().logOut()
        case .google:
            GIDSignIn.sharedInstance().signOut()
        case .manual:
            // TODO: Print statement used as placeholder for manual logOut
            print("Manual logout")
        }
    }
}

class User {

    var name: String
    var email: String
    var userType: UserType
    var imageURL: URL?

    init(name: String, email: String, userType: UserType) {
        self.name = name
        self.email = email
        self.userType = userType
    }

    init(googleUser: GIDGoogleUser) {
        name = googleUser.profile.name
        email = googleUser.profile.email
        userType = .google
        imageURL = googleUser.profile.imageURL(withDimension: 200)
    }

    init(fbResponse: [String: Any]) {
        name = fbResponse["name"] as? String ?? ""
        email = fbResponse["email"] as? String ?? ""
        userType = .facebook

        guard let id = fbResponse["id"] as? String,
            let url = URL(string: String(format: FBRequest.imageURLFormat, id)) else {
                return
        }

        imageURL = url
    }
}
