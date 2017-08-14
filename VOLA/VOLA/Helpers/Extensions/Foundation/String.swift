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
        Split a full name into first and last based on the number of words in full name.
        Last name is the last word in the name, unless name is only one word long.
        First name is the first word in the name, or the first two words in the name if the
        name is three words or longer.
    */
    func splitFullName() -> (firstName: String, lastName: String) {
        var names = self.components(separatedBy: " ")
        switch names.count {
        case 0:
            return ("", "")
        case 1:
            return (names[0], "")
        case 2:
            return (names[0], names[1])
        default:
            // Full name is three words or longer
            let firstName = names[0...1].flatMap({ $0 }).joined(separator: " ")
            let lastName = names[names.count-1]
            return (firstName, lastName)
        }
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
