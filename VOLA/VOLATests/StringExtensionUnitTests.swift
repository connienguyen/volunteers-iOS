//
//  StringExtensionUnitTests.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/11/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import XCTest
@testable import VOLA

class StringExtensionUnitTests: XCTestCase {

    /// Test splitting a full name (two words) into first and last names
    func testSuccessSplitTwoNameShouldReturnFirstLast() {
        let fullName = SplitNameConstants.standardFullName
        let (firstName, lastName) = fullName.splitFullName()
        XCTAssertEqual(firstName, SplitNameConstants.standardFirstName)
        XCTAssertEqual(lastName, SplitNameConstants.standardLastName)
    }

    /// Test splitting a full name (one word) into first and last names
    func testSuccessSplitOneNameShouldReturnFirstEmptyLast() {
        let fullName = SplitNameConstants.oneWordFullName
        let (firstName, lastName) = fullName.splitFullName()
        XCTAssertEqual(firstName, SplitNameConstants.oneWordFirstName)
        XCTAssertEqual(lastName, SplitNameConstants.oneWordLastName)
    }

    /// Test splitting a full name that is three words long into first and last names
    func testSuccessSplitMultipleNameShouldReturnMultiFirstOneLast() {
        let fullName = SplitNameConstants.multiWordFullName
        let (firstName, lastName) = fullName.splitFullName()
        XCTAssertEqual(firstName, SplitNameConstants.multiWordFirstName)
        XCTAssertEqual(lastName, SplitNameConstants.multiWordLastName)
    }

    /// Test splitting a full name is more than three words long into first and last names
    func testSuccessSplitMultipleNameShouldReturnTwoFirstOneLast() {
        let fullName = SplitNameConstants.superMultiWordFullName
        let (firstName, lastName) = fullName.splitFullName()
        XCTAssertEqual(firstName, SplitNameConstants.superMultiWordFirstName)
        XCTAssertEqual(lastName, SplitNameConstants.superMultiWordLastName)
    }

    /// Test splitting an empty name into first and last names
    func testFailureSplitEmptyNameShouldReturnEmptyFirstLast() {
        let fullName = ""
        let (firstName, lastName) = fullName.splitFullName()
        XCTAssertEqual(firstName, "")
        XCTAssertEqual(lastName, "")
    }
}
