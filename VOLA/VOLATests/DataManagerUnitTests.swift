//
//  DataManagerUnitTests.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import XCTest
@testable import VOLA

class DataManagerUnitTests: XCTestCase {

    let user: User = User(name: InputConstants.validName, email: InputConstants.validEmail, userType: .manual)

    override func setUp() {
        super.setUp()
        DataManager.shared.setUser(nil)
    }

    func testSuccessUserSetNilShouldReturnFalse() {
        let notLoggedIn = DataManager.shared.isLoggedIn
        XCTAssertFalse(notLoggedIn, "Start state: user should not be logged in.")
    }

    func testSuccessSetUserShouldReturnTrue() {
        DataManager.shared.setUser(self.user)
        let loggedIn = DataManager.shared.isLoggedIn
        XCTAssertTrue(loggedIn, "User should be logged in after setting user.")
    }

    func testSuccessSetUserShouldReturnMatchingCurrentUser() {
        var currentUser = DataManager.shared.currentUser
        XCTAssertNil(currentUser, "Start state: no currentUser since no user is logged in.")

        DataManager.shared.setUser(self.user)
        currentUser = DataManager.shared.currentUser
        XCTAssertNotNil(currentUser, "Current user model should be updated to new user.")
        XCTAssertEqual(currentUser?.name, self.user.name)
        XCTAssertEqual(currentUser?.email, self.user.email)
        XCTAssertEqual(currentUser?.userType, self.user.userType)

        DataManager.shared.setUser(nil)
        currentUser = DataManager.shared.currentUser
        XCTAssertNil(currentUser, "Current user should be unset to nil.")
    }
}
