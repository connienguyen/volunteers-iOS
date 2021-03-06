//
//  SecretKeyManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

/// Protocol method for class definition of SecretKeyManager and mocking for unit tests
protocol SecretKeyManagerProtocol {
    var keys: [String: String] { get }
}

/// Manager for reading secret keys from a plist file
final class SecretKeyManager: SecretKeyManagerProtocol {
    enum KeyName: String {
        case googleMaps = "GoogleMapsAPIKey"
        case eTouchesAccount = "ETouchesAccountID"
        case eTouchesKey = "ETouchesKey"
    }
    static let shared = SecretKeyManager()

    private let fileName: String = "SecretKeys"

    lazy var keys: [String: String] = {
        guard let path = Bundle.main.path(forResource: self.fileName, ofType: "plist"),
            let keyDict = NSDictionary(contentsOfFile: path) as? [String: String] else {
            Logger.error(VLError.loadPlistData)
            return [:]
        }

        return keyDict
    }()

    private init() { /* Intentionally left blank */ }

    /// Retrieve secret API key value
    func value(for key: KeyName) throws -> String {
        guard let value = keys[key.rawValue] else {
            throw VLError.secretKey
        }

        return value
    }
}
