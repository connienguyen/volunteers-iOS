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

typealias EventCompletionBlock = (_ retrievedEvent: Event?) -> Void

class ETouchesAPIService {
    static let shared = ETouchesAPIService()

    func getEventDetail(eventID: Int) -> Promise<Event> {
        return Promise { fulfill, reject in
            let URL = "https://private-fbd097-tempetouches.apiary-mock.com/events/\(eventID)"
            Alamofire.request(URL).validate().responseObject { (response: DataResponse<Event>) in
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
}
