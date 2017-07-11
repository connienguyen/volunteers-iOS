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
        stub(uri(EventStubURI.getEventDetail), jsonData(JSONFileNames.eventDetail.fileData))

        let exp = expectation(description: "Retrieve event json from API")
        ETouchesAPIService.shared.getEventDetail(eventID: EventTestConstants.testEventID)
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
        stub(uri(EventStubURI.getEventDetail), failure(ETouchesError.couldNotRetrieveData as NSError))

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
        stub(uri(EventStubURI.getAvailableEvents), jsonData(JSONFileNames.availableEvents.fileData))

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
        stub(uri(EventStubURI.getAvailableEvents), failure(ETouchesError.couldNotRetrieveData as NSError))

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
