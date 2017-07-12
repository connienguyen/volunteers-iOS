//
//  UserModel.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/3/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

/**
    Track how the user logged in, by social network or manually
*/
enum UserType {
    case facebook
    case google
    case manual
}

/// Model for User data
class User {

    var name: String
    var email: String
    var userType: UserType
    var imageURL: URL?

    /**
    Initializer for a customized User, such as from manual login or for mocking purposes
     
    - Parameters:
        - name: Full name of user
        - email: Email address of user
        - userType: Method that user logged in
    */
    init(name: String, email: String, userType: UserType) {
        self.name = name
        self.email = email
        self.userType = userType
    }

    /**
    Initializer for User from logging in through Google
     
    - Parameters:
        - googleUser: GIDGoogleUser object to extract user details from (e.g. name, email)
    */
    init(googleUser: GIDGoogleUser) {
        name = googleUser.profile.name
        email = googleUser.profile.email
        userType = .google
        imageURL = googleUser.profile.imageURL(withDimension: UserNumbers.twiceImageIcon.rawValue)
    }

    /**
    Initializer for User from logging in through Facebook
     
    - Parameters:
        - fbResponse: Response from Facebook Graph API request for user data
    */
    init(fbResponse: [String: Any]) {
        name = fbResponse["name"] as? String ?? ""
        email = fbResponse["email"] as? String ?? ""
        userType = .facebook

        guard let id = fbResponse["id"] as? String,
            let url = URL(string: String(format: FBRequest.imageURLFormat, id)) else {
                Logger.error("Could not format Facebook user imageURL.")
                return
        }

        imageURL = url
    }
}
