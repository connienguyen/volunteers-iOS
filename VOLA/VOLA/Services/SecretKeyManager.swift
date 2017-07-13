//
//  SecretKeyManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

/// Manager for reading secret keys from a plist file
final class SecretKeyManager {
    enum KeyName: String {
        case googleMaps = "GoogleMapsAPIKey"
    }
    static let shared = SecretKeyManager()

    private let fileName = "SecretKeys"

    private init() { /* Intentionally left blank */ }

    /// Retrieve secret API key value
    func value(forKey: KeyName) -> String {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
        let keys = NSDictionary(contentsOfFile: path) else {
            Logger.error(VLError.loadPlistData)
            return ""
        }

        // Return empty string as a default value
        return keys[forKey.rawValue] as? String ?? ""
    }
}
