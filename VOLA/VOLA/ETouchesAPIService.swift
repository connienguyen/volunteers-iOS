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

typealias EventCompletionBlock = (_ retrievedEvent: Event?) -> Void

class ETouchesAPIService {
    static let shared = ETouchesAPIService()

    func getEventDetail(eventID: Int, completion: @escaping EventCompletionBlock) {
        let URL = "https://private-fbd097-tempetouches.apiary-mock.com/events/\(eventID)"
        Alamofire.request(URL).validate().responseObject { (response: DataResponse<Event>) in
            let eventResponse = response.result.value

            guard let event = eventResponse else {
                Logger.error("Could not retrieve event for that eventID")
                completion(nil)
                return
            }

            completion(event)
        }
    }
}
