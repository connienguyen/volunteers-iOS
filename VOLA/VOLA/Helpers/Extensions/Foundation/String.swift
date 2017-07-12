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
    Combine an array of strings into one string
     
    - Parameters:
        - strings: Array of strings to combine
        - separator: Separator between each string to combine
     
    - Returns: Combined string of array elements
    */
    static func combineStrings(_ strings: [String], separator: String) -> String {
        return strings.flatMap({$0.localized}).joined(separator: "\n")
    }
}
