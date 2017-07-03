//
//  Errors.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

public enum AuthenticationError: Error {
    case invalidFacebookToken
    case invalidFacebookResponse
    case invalidGoogleUser
    case notLoggedIn
}

extension AuthenticationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidFacebookToken:
            return "error.invalid-facebook-token".localized
        case .invalidFacebookResponse:
            return "error.invalid-facebook-response".localized
        case .invalidGoogleUser:
            return "error.invalid-google-user".localized
        case .notLoggedIn:
            return "error.not-logged-in".localized
        }
    }
}
