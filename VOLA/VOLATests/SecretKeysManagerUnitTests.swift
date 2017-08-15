//
//  SecretKeysManagerUnitTests.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/23/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import XCTest
@testable import VOLA

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
        func value(for key: String) throws -> String {
            guard let value = keys[key] else {
                throw VLError.secretKey
            }

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
        do {
            let retrievedValue = try keyManager.value(for: SecretKeysConstants.secretKey)
            XCTAssertEqual(retrievedValue, SecretKeysConstants.secretValue)
        } catch {
            XCTFail("Should have retrieved valid value given valid key.")
        }
    }

    /// Test case where manager tries to access value for a key not stored in plist
    func testFailureInvalidKeyShouldReturnEmptyString() {
        let exp = expectation(description: "Attempt to retrieve invalid value from plist.")
        do {
            _ = try keyManager.value(for: SecretKeysConstants.invalidSecretKey)
            exp.fulfill()
            XCTFail("Should have gotten VLError.secretKey for value not in plist.")
        } catch {
            exp.fulfill()
            XCTAssertTrue(error is VLError, "Error should be custom error of type VLError.")
            XCTAssertTrue(error as? VLError == VLError.secretKey)
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    /// Test case where manager tries to access values from an invalid plist
    func testFailureInvalidFileShouldReturnEmptryString() {
        keyManager.fileName = SecretKeysConstants.invalidFileName
        let exp = expectation(description: "Attempt to retrieve value from invalid file.")
        do {
            _ = try keyManager.value(for: SecretKeysConstants.secretKey)
            exp.fulfill()
            XCTFail("Should have gotten VLError.secretKey for invalid plist file.")
        } catch {
            exp.fulfill()
            XCTAssertTrue(error is VLError, "Error should be custom error of type VLError.")
            XCTAssertTrue(error as? VLError == VLError.secretKey)
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}
