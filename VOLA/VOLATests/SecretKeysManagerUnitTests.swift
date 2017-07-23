//
//  SecretKeysManagerUnitTests.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/23/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import XCTest

class SecretKeysManagerUnitTests: XCTestCase {
    /// Mock of SecretKeyManager class for testing purposes
    class MockSecretKeyManager: SecretKeyManagerProtocol {
        /// Name of plist file to load. Variable so valid and invalid files may be tested
        var fileName: String = SecretKeysConstants.fileName

        /**
        Required to conform to SecretKeyManagerProtocol. Properly loading a dictionary from a plist and 
         returning a default value if unable to load data. This is the subject of these unittests.
        */
        lazy var keys: [String: String] = {
            guard let path = Bundle(for: SecretKeysManagerUnitTests.self).path(forResource: self.fileName, ofType: "plist"),
                let keyDict = NSDictionary(contentsOfFile: path) as? [String: String] else {
                    return [:]
            }

            return keyDict
        }()

        /// Stubbed function for retreiving value from stored plist
        func value(for key: String) -> String {
            guard let value = keys[key] else {
                return ""
            }

            print(keys)
            return value
        }
    }

    /**
    Due to the nature of the way unittest are run, cannot successfully run unittests if
     MockSecretManager is a singleton with lazy loading
    */
    var keyManager = MockSecretKeyManager()

    override func setUp() {
        super.setUp()

        // Set up each
        keyManager.fileName = SecretKeysConstants.fileName
    }

    /// Test case where a valid key in plist returns a valid secret value stored in plist
    func testSuccessValidKeyShouldReturnSecret() {
        let retrievedValue = keyManager.value(for: SecretKeysConstants.secretKey)
        XCTAssertEqual(retrievedValue, SecretKeysConstants.secretValue)
    }

    /// Test case where manager tries to access value for a key not stored in plist
    func testFailureInvalidKeyShouldReturnEmptyString() {
        let retrievedValue = keyManager.value(for: SecretKeysConstants.invalidSecretKey)
        XCTAssertEqual(retrievedValue, "")
    }

    /// Test case where manager tries to access values from an invalid plist
    func testFailureInvalidFileShouldReturnEmptryString() {
        keyManager.fileName = SecretKeysConstants.invalidFileName
        let retrievedValue = keyManager.value(for: SecretKeysConstants.secretKey)
        XCTAssertEqual(retrievedValue, "")
    }
}
