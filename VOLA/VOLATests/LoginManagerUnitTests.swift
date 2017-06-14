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

    func testGoodSocialLogin() {
        let user = User(name: "Anita Borg", email: "anita@anitaborg.org", userType: .manual)
        let userPromise: Promise<User> = Promise { fulfill, _ in
            fulfill(user)
        }

        XCTAssertNil(DataManager.shared.currentUser, "Start state: current user should be nil.")
        LoginManager.shared.login(authenticationPromise: userPromise)
            .always {
                let currentUser = DataManager.shared.currentUser
                XCTAssertNotNil(currentUser, "Successful should set the current user to a not nil value.")
                XCTAssertEqual(currentUser?.email, user.email)
                XCTAssertEqual(currentUser?.name, user.name)
                XCTAssertEqual(currentUser?.userType, user.userType)
                XCTAssertEqual(currentUser?.imageURL, user.imageURL)
            }

    }

    func testBadSocialLogin() {
        // Test case where there was an error logging into a social network
        let userPromise: Promise<User> = Promise { _, reject in
            reject(AuthenticationError.notLoggedIn)
        }

        XCTAssertNil(DataManager.shared.currentUser, "Start state: current user should be nil.")
        LoginManager.shared.login(authenticationPromise: userPromise)
            .always {
                XCTAssertNil(DataManager.shared.currentUser, "After failed login, current user should still be nil.")
            }
    }
}
