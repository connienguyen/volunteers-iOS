//
//  Constants+Error.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/29/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

enum ErrorStrings: String {
    case invalidFacebookToken = "error.invalid-facebook-token"
    case invalidFacebookResponse = "error.invalid-facebook-response"
    case invalidGoogleUser = "error.invalid-google-user"
    case notLoggedIn = "error.not-logged-in"
    case invalidEmail = "error.invalid-email"
    case invalidName = "error.invalid-name"
    case invalidPassword = "error.invalid-password"
    case invalidRequired = "error.invalid-required"
    case validation = "error.validation"
    case userUpdate = "error.user-update"

    var localized: String {
        return rawValue.localized
    }
}
