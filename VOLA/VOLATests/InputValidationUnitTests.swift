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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testValidEmail() {
        let validation: InputValidation = .email

        // Test good inputs
        let goodInput = "systers.volunteers@gmail.com"
        let goodInput2 = "syster.volunteers+1@gmail.com"

        XCTAssertTrue(validation.isValid(goodInput))
        XCTAssertTrue(validation.isValid(goodInput2))

        // Test bad inputs
        let badInput = "incomplete@email"
        let badInput2 = "syster.volunteers@gmail.com "

        XCTAssertFalse(validation.isValid(badInput))
        XCTAssertFalse(validation.isValid(badInput2))
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

        XCTAssertTrue(validation.isValid(goodInput))
        XCTAssertTrue(validation.isValid(goodInput2))
        XCTAssertTrue(validation.isValid(goodInput3))
        XCTAssertTrue(validation.isValid(goodInput4))
        XCTAssertTrue(validation.isValid(goodInput5))
        XCTAssertTrue(validation.isValid(goodInput6))

        // Test bad inputs
        let badInput = "Ca$h Money"

        XCTAssertFalse(validation.isValid(badInput))
    }

    func testValidPassword() {
        let validation: InputValidation = .password

        // Test good inputs
        let goodInput = "MyPassword1"

        XCTAssertTrue(validation.isValid(goodInput))

        // Test bad inputs
        let badInput = "mypassword"
        let badInput2 = "my passworD1"
        let badInput3 = "5maLL"

        XCTAssertFalse(validation.isValid(badInput))
        XCTAssertFalse(validation.isValid(badInput2))
        XCTAssertFalse(validation.isValid(badInput3))
    }

    func testValidRequired() {
        let validation: InputValidation = .required

        // Test good inputs
        let goodInput = "Textfield input"
        let goodInput2 = "Hur är läget?"

        XCTAssertTrue(validation.isValid(goodInput))
        XCTAssertTrue(validation.isValid(goodInput2))

        // Test bad inputs
        let badInput = ""
        let badInput2 = " "
        let badInput3 = "\r\t"

        XCTAssertFalse(validation.isValid(badInput))
        XCTAssertFalse(validation.isValid(badInput2))
        XCTAssertFalse(validation.isValid(badInput3))
    }
}
