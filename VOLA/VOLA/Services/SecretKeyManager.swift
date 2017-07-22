//
//  SecretKeyManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

fileprivate let fileName: String = "SecretKeys"

/// Manager for reading secret keys from a plist file
final class SecretKeyManager {
    enum KeyName: String {
        case googleMaps = "GoogleMapsAPIKey"
    }
    static let shared = SecretKeyManager()

    lazy var keys: [String: String] = {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
            let keyDict = NSDictionary(contentsOfFile: path) as? [String: String] else {
            Logger.error(VLError.loadPlistData)
            return [:]
        }

        return keyDict
    }()

    private init() { /* Intentionally left blank */ }

    /// Retrieve secret API key value
    func value(for key: KeyName) -> String {
        guard let value = keys[key.rawValue] else {
            Logger.error(VLError.secretKey)
            return ""
        }

        return value
    }
}
