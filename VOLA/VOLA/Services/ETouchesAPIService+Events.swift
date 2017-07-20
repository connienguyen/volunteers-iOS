//
//  ETouchesAPIService+Events.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/5/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import ObjectMapper

// MARK: - ETouchesAPIService extension for event releated API requests
extension ETouchesAPIService {
    /**
    Get complete details for an event
     
    - Parameters:
        - eventID: Identifier for event to retrieve details for
     
    - Returns: Event promise if successful
    */
    func getEventDetail(eventID: Int) -> Promise<Event> {
        return Promise { fulfill, reject in
            let URL = ETouchesURL.baseURL + ETouchesURL.getEventAddOn
            let parameters: [String: Any] = [
                ETouchesKeys.accessToken.forURL: self.accessToken,
                ETouchesKeys.eventID.forURL: eventID,
                ETouchesKeys.customFields.forURL: true
            ]

            Alamofire.request(URL, parameters: parameters, encoding: URLEncoding.default)
                .validate().responseObject { (response: DataResponse<Event>) in
                    let eventResponse = response.result.value

                    guard let event = eventResponse else {
                        let error = ETouchesError.couldNotRetrieveData
                        Logger.error(error)
                        reject(error)
                        return
                    }

                    fulfill(event)
            }
        }
    }

    /**
    Get list of available events
     
    - Returns: Promise for array of Event objects if successful
    */
    func getAvailableEvents() -> Promise<[Event]> {
        return Promise { fulfill, reject in
            let URL = ETouchesURL.baseURL + ETouchesURL.listEventsAddOn
            let parameters: [String: Any] = [
                ETouchesKeys.accessToken.forURL: self.accessToken,
                ETouchesKeys.fields.forURL: ETouchesParameters.listEvents
            ]

            Alamofire.request(URL, parameters: parameters, encoding: URLEncoding.default)
                .validate().responseArray(completionHandler: { (response: DataResponse<[Event]>) in
                    let eventsResponse = response.result.value

                    guard let events = eventsResponse else {
                        let error = ETouchesError.couldNotRetrieveData
                        Logger.error(error)
                        reject(error)
                        return
                    }
                    
                    fulfill(events)
                })
        }
    }
}
