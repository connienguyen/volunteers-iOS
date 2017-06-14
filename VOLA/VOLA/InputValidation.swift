//
//  InputValidation.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

struct ValidationRegex {
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let name = "^([ \\u00c0-\\u01ffa-zA-Z'\\-]){2,}$"    // Regex allows alphabetic unicode characters, e.g. ëøå 
    static let password = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
}

enum InputValidation: String {
    case email = "error.invalid-email"
    case name = "error.invalid-name"
    case password = "error.invalid-password"
    case required = "error.invalid-required"
    case none = ""

    var error: String {
        return self.rawValue
    }

    func isValid(_ input: String?) -> Bool {
        guard let input = input else {
            return false
        }

        switch self {
        case .email:
            return NSPredicate(format: "SELF MATCHES %@", ValidationRegex.email).evaluate(with: input)
        case .name:
            return NSPredicate(format: "SELF MATCHES %@", ValidationRegex.name).evaluate(with: input)
        case .password:
            return NSPredicate(format: "SELF MATCHES %@", ValidationRegex.password).evaluate(with: input)
        case .required:
            return input.trimmed.characters.count >= 1
        case .none:
            return true
        }
    }
}
