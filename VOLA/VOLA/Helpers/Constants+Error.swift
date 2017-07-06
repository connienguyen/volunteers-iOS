//
//  Constants+Error.swift
//  VOLA
//
//  VLError is a class to display custom localized errors (from Localizable.strings)
//
//  Created by Connie Nguyen on 6/29/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

enum VLError: String, LocalizedError {
    case invalidFacebookToken = "error.invalid-facebook-token"
    case invalidFacebookResponse = "error.invalid-facebook-response"
    case invalidGoogleUser = "error.invalid-google-user"
    case notLoggedIn = "error.not-logged-in"
    case invalidEmail = "error.invalid-email"
    case invalidName = "error.invalid-name"
    case invalidPassword = "error.invalid-password"
    case invalidRequired = "error.invalid-required"
    case invalidTOS = "error.invalid-TOS"
    case invalidPrivacy = "error.invalid-privacy"
    case validation = "error.validation"
    case userUpdate = "error.user-update"

    var errorDescription: String? {
        return rawValue.localized
    }
}
