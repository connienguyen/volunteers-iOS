//
//  ETouchesAPIService.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import PromiseKit

final class ETouchesAPIService {
    static let shared = ETouchesAPIService()
    var accessToken: String = ""

    private init() { /* Intentionally left empty */ }

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

    private func retrieveAccessToken() {
        let URL = ETouchesURL.baseURL + ETouchesURL.accessTokenAddOn
        // TODO read secret keys from plist
        /*
         let parameters: [String: Any] = [
            ETouchesParameters.accountID.forURL: //,
            ETouchesParameters.key.forURL: //
         ]
        */
        Alamofire.request(URL).validate().responseObject { (response: DataResponse<ETouchesAccessToken>) in
            let accessTokenResponse = response.result.value
            guard let eTouchesToken = accessTokenResponse else {
                Logger.error("Could not retrieve eTouches access token")
                return
            }

            self.accessToken = eTouchesToken.accessToken
        }
    }
}
