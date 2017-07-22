//
//  Errors.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

enum AuthenticationError: String, LocalizedError {
    case invalidFacebookToken = "error.invalid-facebook-token"
    case invalidFacebookResponse = "error.invalid-facebook-response"
    case invalidGoogleUser = "error.invalid-google-user"
    case invalidFirebaseAuth = "error.invalid-firebase-auth"
    case notLoggedIn = "error.not-logged-in"

    var errorDescription: String? {
        return rawValue.localized
    }
}

public enum UIError: Error {
    case existingActivityIndicator
}

extension UIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .existingActivityIndicator:
            return "error.existing-activity-indicator".localized
        }
    }
}

public enum ETouchesError: Error {
    case couldNotRetrieveData
}

extension ETouchesError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .couldNotRetrieveData:
            return "error.etouches-no-data".localized
        }
    }
}
