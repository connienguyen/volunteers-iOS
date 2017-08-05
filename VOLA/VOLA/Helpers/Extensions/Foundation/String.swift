//
//  String.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/14/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

extension String {
    /// String trimmed of whitespace characters from beginning and end
    public var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /**
        Split a full name into first and last, where last name is the last word in the
            name preceded by a space and the first name is everything before the last name
    */
    func splitFullName() -> (firstName: String, lastName: String) {
        var names = self.components(separatedBy: " ")
        guard names.count >= 2 else {
            return ("", "")
        }
        let lastName = names.popLast() ?? ""
        let firstName = names.flatMap({ $0 }).joined(separator: " ")
        return (firstName, lastName)
    }
}

extension Sequence where Iterator.Element == String {
    /**
        Combine an array of strings into one localized string
     
        - Parameters:
            - separator: String between each element to combine; default is newline character
     
        - Returns: Combined string of localized array elements
    */
    func joinLocalized(separator: String = "\n") -> String {
        return flatMap({ $0.localized}).joined(separator: separator)
    }
}
