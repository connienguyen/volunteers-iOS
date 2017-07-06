//
//  ETouchesAPIService+Events.swift
//  VOLA
//
//  Extension on ETouchesAPIService focused on event related API calls
//
//  Created by Connie Nguyen on 7/5/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import ObjectMapper

extension ETouchesAPIService {
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
                        Logger.error(error.localizedDescription)
                        reject(error)
                        return
                    }

                    fulfill(event)
            }
        }
    }

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
                        Logger.error(error.localizedDescription)
                        reject(error)
                        return
                    }
                    
                    fulfill(events)
                })
        }
    }
}
