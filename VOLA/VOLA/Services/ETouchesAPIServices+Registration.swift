//
//  ETouchesAPIServices+Registration.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/25/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import ObjectMapper

// MARK: - ETouchesAPIService extension for registration related API requests
extension ETouchesAPIService {
    func registerForEvent(eventID: Int, name: String, email: String, volunteering: Bool, accommodation: String?) -> Promise<Event> {
        return Promise { fulfill, reject in
            // TODO: Incomplete call, needs to work with Firebase
            let URL = ETouchesURL.baseURL + ETouchesURL.eventRegistrationAddOn
            var parameters: [String: Any] = [
                ETouchesKeys.accessToken.forURL: self.accessToken,
                ETouchesKeys.eventID.forURL: eventID,
                ETouchesKeys.email.forURL: email,
                ETouchesKeys.fullName.forURL: name
            ]
            if let accommodation = accommodation {
                parameters[ETouchesKeys.accommodation.forURL] = accommodation
            }

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
}
