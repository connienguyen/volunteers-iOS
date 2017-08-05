//
//  Constants+Firebase.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/5/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

/// Protocol for values that are used as parameter keys in API requests
protocol ParameterKey {
    var key: String { get }
}

/// Parameter keys used with Firebase requests
struct FirebaseKeys {
    enum User: String, ParameterKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case organization

        var key: String {
            return rawValue
        }
    }
}
