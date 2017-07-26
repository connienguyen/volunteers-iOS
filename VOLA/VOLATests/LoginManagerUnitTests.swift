//
//  LoginManagerUnitTests.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/14/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import XCTest
import PromiseKit
@testable import VOLA

class LoginManagerUnitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        DataManager.shared.setUser(nil)
    }

    func testSuccessSocialLoginShouldReturnSetCurrentUser() {
        let user = User(name: InputConstants.validName, email: InputConstants.validEmail, userType: .manual)
        let userPromise: Promise<User> = Promise { fulfill, _ in
            fulfill(user)
        }

        XCTAssertNil(DataManager.shared.currentUser, "Start state: current user should be nil.")
        LoginManager.shared.login(.custom(userPromise))
            .always {
                let currentUser = DataManager.shared.currentUser
                XCTAssertNotNil(currentUser, "Successful should set the current user to a not nil value.")
                XCTAssertEqual(currentUser?.email, user.email)
                XCTAssertEqual(currentUser?.name, user.name)
                XCTAssertEqual(currentUser?.userType, user.userType)
                XCTAssertEqual(currentUser?.imageURL, user.imageURL)
            }

    }

    func testFailureSocialLoginShouldReturnNilCurrentUser() {
        // Test case where there was an error logging into a social network
        let userPromise: Promise<User> = Promise { _, reject in
            reject(AuthenticationError.notLoggedIn)
        }

        XCTAssertNil(DataManager.shared.currentUser, "Start state: current user should be nil.")
        LoginManager.shared.login(.custom(userPromise))
            .always {
                XCTAssertNil(DataManager.shared.currentUser, "After failed login, current user should still be nil.")
            }
    }
}
