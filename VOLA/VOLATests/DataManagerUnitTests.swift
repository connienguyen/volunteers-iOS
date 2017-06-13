//
//  DataManagerUnitTests.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import XCTest

class DataManagerUnitTests: XCTestCase {

    let user: User = User(name: "Anita Borg", email: "anita@anitaborg.org", userType: .manual)

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        DataManager.shared.setUser(nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testIsLoggedIn() {
        let notLoggedIn = DataManager.shared.isLoggedIn
        XCTAssertFalse(notLoggedIn)

        DataManager.shared.setUser(self.user)
        let loggedIn = DataManager.shared.isLoggedIn
        XCTAssertTrue(loggedIn)
    }

    func testCurrentUser() {
        var currentUser = DataManager.shared.currentUser
        XCTAssertTrue(currentUser == nil)

        DataManager.shared.setUser(self.user)
        currentUser = DataManager.shared.currentUser
        XCTAssertTrue(currentUser != nil)
        XCTAssertTrue(currentUser?.name == self.user.name)
        XCTAssertTrue(currentUser?.email == self.user.email)

        DataManager.shared.setUser(nil)
        currentUser = DataManager.shared.currentUser
        XCTAssertTrue(currentUser == nil)
    }
}
