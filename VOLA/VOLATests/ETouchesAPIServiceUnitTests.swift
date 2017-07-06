//
//  ETouchesAPIServiceUnitTests.swift
//  ETouchesAPIServiceUnitTests
//
//  Unit tests for the ETouchesAPIService. For success cases, use JSON data from files.
//
//  Created by Bruno Henriques on 31/05/2017.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import XCTest
import Mockingjay
@testable import VOLA

class ETouchesAPIServiceUnitTests: XCTestCase {

    func testSuccessEventDetailShouldReturnEvent() {
        let url = ETouchesURL.baseURL + ETouchesURL.getEventAddOn
        stub(uri(url), jsonData(JSONFileNames.eventDetail.fileData))

        let exp = expectation(description: "Retrieve event json from API")
        ETouchesAPIService.shared.getEventDetail(eventID: 1)
            .then { retrievedEvent -> Void in
                exp.fulfill()
                XCTAssertEqual(retrievedEvent.name, EventTestConstants.testEventName)
            }.catch { _ in
                exp.fulfill()
                XCTFail("Should have returned Event model")
            }

        waitForExpectations(timeout: 30, handler: nil)
    }

    func testFailureEventDetailShouldReturnFailedPromise() {
        let url = ETouchesURL.baseURL + ETouchesURL.getEventAddOn
        stub(uri(url), failure(ETouchesError.couldNotRetrieveData as NSError))

        let exp = expectation(description: "Retrieve event json from API")
        ETouchesAPIService.shared.getEventDetail(eventID: 1)
            .then { _ -> Void in
                exp.fulfill()
                XCTFail("Should have returned error from stubbed response")
            }.catch { _ in
                exp.fulfill()
            }

        waitForExpectations(timeout: 30, handler: nil)
    }

    func testSuccessAvailableEventsShouldReturnEventList() {
        let url = ETouchesURL.baseURL + ETouchesURL.listEventsAddOn
        stub(uri(url), jsonData(JSONFileNames.availableEvents.fileData))

        let exp = expectation(description: "Retrieve available events JSON from API")
        ETouchesAPIService.shared.getAvailableEvents()
            .then { retrievedEvents -> Void in
                exp.fulfill()
                XCTAssertEqual(retrievedEvents.count, EventTestConstants.availableEventsCount)
            }.catch { _ in
                exp.fulfill()
                XCTFail("Should have returned array of Event models")
            }

        waitForExpectations(timeout: 30, handler: nil)
    }

    func testFailureAvailableEventsShouldReturnFailedPromise() {
        let url = ETouchesURL.baseURL + ETouchesURL.listEventsAddOn
        stub(uri(url), failure(ETouchesError.couldNotRetrieveData as NSError))

        let exp = expectation(description: "Retrieve available events JSON from API")
        ETouchesAPIService.shared.getAvailableEvents()
            .then { _ -> Void in
                exp.fulfill()
                XCTFail("Should have return error from stubbed response")
            }.catch { _ in
                exp.fulfill()
            }

        waitForExpectations(timeout: 30, handler: nil)
    }
}
