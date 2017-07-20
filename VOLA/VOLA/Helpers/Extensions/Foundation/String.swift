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
}

extension Sequence where Iterator.Element == String {
    /**
    Combine an array of strings into one localized string
     
    - Parameteters:
        - separator: String between each element to combine; default is newline character
     
    - Returns: Combined string of localized array elements
    */
    func joinLocalized(separator: String = "\n") -> String {
        return flatMap({ $0.localized}).joined(separator: separator)
    }
}
