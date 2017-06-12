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
        let badInput = "incomplete@email"
        let goodInput = "systers.volunteers@gmail.com"

        XCTAssertFalse(validation.isValid(badInput))
        XCTAssertTrue(validation.isValid(goodInput))
    }

    func testValidName() {
        let validation: InputValidation = .name
        let badInput = "Name"
        let goodInput = "Anita Borg"
        let anotherGoodInput = "Anne Isabella Milbanke"

        XCTAssertFalse(validation.isValid(badInput))
        XCTAssertTrue(validation.isValid(goodInput))
        XCTAssertTrue(validation.isValid(anotherGoodInput))
    }

    func testValidPassword() {
        let validation: InputValidation = .password
        let badInput = "mypassword"
        let goodInput = "Mypassword1"

        XCTAssertFalse(validation.isValid(badInput))
        XCTAssertTrue(validation.isValid(goodInput))
    }

    func testValidRequired() {
        let validation: InputValidation = .required
        let badInput = ""
        let goodInput = "Textfield input"

        XCTAssertFalse(validation.isValid(badInput))
        XCTAssertTrue(validation.isValid(goodInput))
    }
}
