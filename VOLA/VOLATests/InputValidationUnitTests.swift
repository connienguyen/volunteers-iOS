//
//  InputValidationUnitTests.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/12/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import XCTest
@testable import VOLA

class InputValidationUnitTests: XCTestCase {

    func testValidEmail() {
        let validation: InputValidation = .email

        // Test good inputs
        let goodInput = "systers.volunteers@gmail.com"
        let goodInput2 = "syster.volunteers+1@gmail.com"

        XCTAssertTrue(validation.isValid(goodInput), "Standard email address is valid.")
        XCTAssertTrue(validation.isValid(goodInput2), "Emails using + (available with gmail) are valid.")

        // Test bad inputs
        let badInput = "incomplete@email"
        let badInput2 = "syster.volunteers@gmail.com "

        XCTAssertFalse(validation.isValid(badInput), "Emails with invalid domain strings are invalid")
        XCTAssertFalse(validation.isValid(badInput2), "Emails with extra whitespace are invalid.")
    }

    func testValidName() {
        let validation: InputValidation = .name

        // Test good inputs
        let goodInput = "Anita Borg"
        let goodInput2 = "Anne Isabella Milbanke"
        let goodInput3 = "Åsa Blomström"
        let goodInput4 = "Jerry O'Connel"
        let goodInput5 = "Joseph Gordon-Levitt"
        let goodInput6 = "Cher"

        XCTAssertTrue(validation.isValid(goodInput), "Standard first and last name should be valid.")
        XCTAssertTrue(validation.isValid(goodInput2), "Names with middle names are valid.")
        XCTAssertTrue(validation.isValid(goodInput3), "Names with non-ASCII letters are valid.")
        XCTAssertTrue(validation.isValid(goodInput4), "Names with apostrophe are valid.")
        XCTAssertTrue(validation.isValid(goodInput5), "Hyphenated names are valid.")
        XCTAssertTrue(validation.isValid(goodInput6), "Single word names are valid.")

        // Test bad inputs
        let badInput = "Ca$h Money"

        XCTAssertFalse(validation.isValid(badInput), "Names with special characters are not valid.")
    }

    func testValidPassword() {
        let validation: InputValidation = .password

        // Test good inputs
        let goodInput = "MyPassword1"

        XCTAssertTrue(validation.isValid(goodInput), "Passwords with at least 8 characters, one lowercase, one uppercase, and one number are valid.")

        // Test bad inputs
        let badInput = "mypassword"
        let badInput2 = "my passworD1"
        let badInput3 = "5maLL"

        XCTAssertFalse(validation.isValid(badInput), "Password with no uppercase letters or numbers is invalid.")
        XCTAssertFalse(validation.isValid(badInput2), "Password with whitespace is invalid.")
        XCTAssertFalse(validation.isValid(badInput3), "Password with less than 8 characters is invalid.")
    }

    func testValidRequired() {
        let validation: InputValidation = .required

        // Test good inputs
        let goodInput = "Textfield input"
        let goodInput2 = "Hur är läget?"

        XCTAssertTrue(validation.isValid(goodInput), "Input with more than one character is valid.")
        XCTAssertTrue(validation.isValid(goodInput2), "Input with non-ASCII characters is valid.")

        // Test bad inputs
        let badInput = ""
        let badInput2 = " "
        let badInput3 = "\r\t"

        XCTAssertFalse(validation.isValid(badInput), "Emptry string input is invalid.")
        XCTAssertFalse(validation.isValid(badInput2), "Input filled with whitespace is invalid.")
        XCTAssertFalse(validation.isValid(badInput3), "Input filled with whitespace is invalid.")
    }
}
