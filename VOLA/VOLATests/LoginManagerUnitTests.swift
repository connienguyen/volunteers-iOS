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
        DataManager.shared.setUserUpdateStoredUser(nil)
    }

    func testSuccessSocialLoginShouldReturnSetCurrentUser() {
        let user = User(uid: InputConstants.userUID, firstName: SplitNameConstants.standardFirstName, lastName: SplitNameConstants.standardLastName, email: InputConstants.validEmail)
        let userPromise: Promise<User> = Promise { fulfill, _ in
            fulfill(user)
        }

        XCTAssertNil(DataManager.shared.currentUser, "Start state: current user should be nil.")
        LoginManager.shared.login(.custom(userPromise))
            .always {
                let currentUser = DataManager.shared.currentUser
                XCTAssertNotNil(currentUser, "Successful should set the current user to a not nil value.")
                XCTAssertEqual(currentUser?.email, user.email)
                XCTAssertEqual(currentUser?.firstName, user.firstName)
                XCTAssertEqual(currentUser?.lastName, user.lastName)
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

    /// Test that user successfully connects a login to their Firebase account
    func testSuccessConnectLoginShouldReturnTrue() {
        let boolPromise: Promise<Bool> = Promise { fulfill, _ in
            fulfill(true)
        }

        let exp = expectation(description: "Should connect login to Firebase account")
        LoginManager.shared.addConnectedLogin(.custom(boolPromise))
            .then { success -> Void in
                exp.fulfill()
                XCTAssertTrue(success, "Account should have been connected successfully")
            }.catch { _ in
                exp.fulfill()
                XCTFail("Should have successfully connected login on Firebase")
            }

        waitForExpectations(timeout: 10, handler: nil)
    }

    /// Test case where user cannot connect login to Firebase account
    func testFailureConnectLoginShouldReturnError() {
        let boolPromise: Promise<Bool> = Promise { _, reject in
            reject(VLError.invalidFirebaseAction)
        }

        let exp = expectation(description: "Attempt to connect login to Firebase account")
        LoginManager.shared.addConnectedLogin(.custom(boolPromise))
            .then { _ -> Void in
                exp.fulfill()
                XCTFail("Should have returned error from connecting login.")
            }.catch { error in
                exp.fulfill()
                XCTAssertTrue(error as? VLError == .invalidFirebaseAction, "Error should be regarding Firebase")
            }

        waitForExpectations(timeout: 10, handler: nil)
    }
}
