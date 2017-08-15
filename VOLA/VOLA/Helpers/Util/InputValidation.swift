//
//  InputValidation.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

/// Struct to manage regexes used to validate text input
struct ValidationRegex {
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let name = "^([ \\u00c0-\\u01ffa-zA-Z'\\-]){2,}$"    // Regex allows alphabetic unicode characters, e.g. ëøå 
    static let password = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
}

/**
Input validation rules to apply to text

 - email: Follows proper email format
 - name: Follows naming conventions
 - required: Text is not empty
 - none: No validation rule, input is always valid
*/
enum InputValidation: String {
    case email = "error.invalid-email"
    case name = "error.invalid-name"
    case password = "error.invalid-password"
    case required = "error.invalid-required"
    case none = ""

    /// Error description for when text fails validation
    var error: String {
        return self.rawValue
    }

    /**
    Validates text input according to validation rule
     
    - Parameters:
        - input: Text to validate
    */
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

protocol Validatable {
    var fieldsToValidate: [VLTextField] { get }
}

///  Additional wrapper protocol to avoid #selector objc error in setUpValidatableFields()
protocol Validator {
    func textFieldEditingDidEnd(_ textField: VLTextField)
}

extension Validatable where Self: UIViewController {
    /// Array of strings describing input validation errors on view controller
    var validationErrorDescriptions: [String] {
        var errorDescriptions: [String] = []
        for field in fieldsToValidate {
            field.validate()
            if !field.isValid {
                errorDescriptions.append(field.validator.error)
            }
        }

        return errorDescriptions
    }

    /**
    Set up each validatable field to do validation at the end of editing
    */
    func setUpValidatableFields() {
        for field in fieldsToValidate {
            field.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        }
    }
}

// MARK: - Validator
extension UIViewController: Validator {
    /**
    Validate text field at end of editing
     
    - Parameters:
        - textField: Text field to validate
    */
    func textFieldEditingDidEnd(_ textField: VLTextField) {
        textField.validate()
    }
}
