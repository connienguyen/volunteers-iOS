//
//  LoginManagerUnitTests.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/14/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import XCTest
import PromiseKit

class LoginManagerUnitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        DataManager.shared.setUser(nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGoodSocialLogin() {
        let user = User(name: "Anita Borg", email: "anita@anitaborg.org", userType: .manual)
        let userPromise: Promise<User> = Promise { fulfill, _ in
            fulfill(user)
        }

        XCTAssert(DataManager.shared.currentUser == nil)
        LoginManager.shared.login(authenticationPromise: userPromise)
            .always {
                let currentUser = DataManager.shared.currentUser
                XCTAssert(currentUser != nil)
                XCTAssert(currentUser?.email == user.email)
            }

    }

    func testBadSocialLogin() {
        // Test case where there was an error logging into a social network
        let userPromise: Promise<User> = Promise { _, reject in
            reject(AuthenticationError.notLoggedIn)
        }

        XCTAssert(DataManager.shared.currentUser == nil)
        LoginManager.shared.login(authenticationPromise: userPromise)
            .always {
                XCTAssert(DataManager.shared.currentUser == nil)
            }
    }
}
