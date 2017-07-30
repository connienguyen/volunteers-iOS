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
    For a string, returns its SHA1 hex-encoded encryption.
     Source: https://stackoverflow.com/questions/25761344/how-to-crypt-string-to-sha1-with-swift

    - Returns: A hex encoded string using SHA1
    */
    func sha1HexString() -> String {
        let data = self.data(using: .utf8)!
        var digest = [UInt8](repeatElement(0, count: Int(CC_SHA1_DIGEST_LENGTH)))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
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
