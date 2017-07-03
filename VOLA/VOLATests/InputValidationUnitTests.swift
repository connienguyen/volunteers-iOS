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

    func testSuccessValidEmailShouldReturnTrue() {
        let validation: InputValidation = .email
        let input = InputConstants.validEmail
        XCTAssertTrue(validation.isValid(input), "Standard email address is valid.")
    }

    func testSuccessValidEmailSpecialCharacterShouldReturnTrue() {
        let validation: InputValidation = .email
        let input = InputConstants.validEmailSpecialCharacter
        XCTAssertTrue(validation.isValid(input), "Emails using + (available with gmail) are valid.")
    }

    func testFailureIncompleteEmailShouldReturnFalse() {
        let validation: InputValidation = .email
        let input = InputConstants.incompleteEmail
        XCTAssertFalse(validation.isValid(input),  "Emails with invalid domain strings are invalid")
    }

    func testFailureEmailWithWitespaceShouldReturnFalse() {
        let validation: InputValidation = .email
        let input = InputConstants.whitespaceEmail
        XCTAssertFalse(validation.isValid(input),  "Emails with extra whitespace are invalid.")
    }

    func testSuccessValidNameShouldReturnTrue() {
        let validation: InputValidation = .name
        let input = InputConstants.validName
        XCTAssertTrue(validation.isValid(input), "Standard first and last name should be valid.")
    }

    func testSuccessValidNameMultipleShouldReturnTrue() {
        let validation: InputValidation = .name
        let input = InputConstants.validNameMultiple
        XCTAssertTrue(validation.isValid(input), "Names with middle names are valid.")
    }

    func testSuccessValidNameSpecialCharacterShouldReturnTrue() {
        let validation: InputValidation = .name
        let input = InputConstants.validNameSpecial
        XCTAssertTrue(validation.isValid(input), "Names with non-ASCII letters are valid.")
    }

    func testSuccessValidNameApostropheShouldReturnTrue() {
        let validation: InputValidation = .name
        let input = InputConstants.validNameApostrophe
        XCTAssertTrue(validation.isValid(input), "Names with apostrophe are valid.")
    }

    func testSuccessValidNameHyphenShouldReturnTrue() {
        let validation: InputValidation = .name
        let input = InputConstants.validNameHyphen
        XCTAssertTrue(validation.isValid(input), "Hyphenated names are valid.")
    }

    func testSuccessValidNameMonoShouldReturnTrue() {
        let validation: InputValidation = .name
        let input = InputConstants.validName
        XCTAssertTrue(validation.isValid(input), "Single word names are valid.")
    }

    func testFailureInvalidNameSpecialCharacterShouldReturnFalse() {
        let validation: InputValidation = .name
        let input = InputConstants.invalidNameSpecial
        XCTAssertFalse(validation.isValid(input), "Names with special characters are not valid.")
    }

    func testSuccessValidPasswordShouldReturnTrue() {
        let validation: InputValidation = .password
        let input = InputConstants.validPassword
        XCTAssertTrue(validation.isValid(input), "Passwords with at least 8 characters, one lowercase, one uppercase, and one number are valid.")
    }

    func testFailureInvalidPasswordAllLowercaseShouldReturnFalse() {
        let validation: InputValidation = .password
        let input = InputConstants.invalidPasswordAllLowercase
        XCTAssertFalse(validation.isValid(input), "Password with no uppercase letters or numbers is invalid.")
    }

    func testFailureInvalidPasswordWhiteSpaceShouldReturnFalse() {
        let validation: InputValidation = .password
        let input = InputConstants.invalidPasswordWhitespace
        XCTAssertFalse(validation.isValid(input), "Password with whitespace is invalid.")
    }

    func testFailureInvalidPasswordTooShortShouldReturnFalse() {
        let validation: InputValidation = .password
        let input = InputConstants.invalidPasswordShort
        XCTAssertFalse(validation.isValid(input), "Password with less than 8 characters is invalid.")
    }

    func testSuccessValidRequiredInputShouldReturnTrue() {
        let validation: InputValidation = .required
        let input = InputConstants.validRequiredInput
        XCTAssertTrue(validation.isValid(input), "Input with more than one character is valid.")
    }

    func testSuccessValidRequiredInputSpecialShouldReturnTrue() {
        let validation: InputValidation = .required
        let input = InputConstants.validRequiredInputSpecial
        XCTAssertTrue(validation.isValid(input), "Input with non-ASCII characters is valid.")
    }

    func testFailureRequiredInputEmptyShouldReturnFalse() {
        let validation: InputValidation = .required
        let input = InputConstants.invalidRequiredInputEmpty
        XCTAssertFalse(validation.isValid(input), "Emptry string input is invalid.")
    }

    func testFailureRequiredInputSpaceShouldReturnFalse() {
        let validation: InputValidation = .required
        let input = InputConstants.invalidRequiredInputSpace
        XCTAssertFalse(validation.isValid(input), "Input filled with whitespace is invalid.")
    }

    func testFailureRequiredInputWhitespaceShouldReturnFalse() {
        let validation: InputValidation = .required
        let input = InputConstants.invalidRequiredInputEmpty
        XCTAssertFalse(validation.isValid(input), "Input filled with whitespace is invalid.")
    }
}
