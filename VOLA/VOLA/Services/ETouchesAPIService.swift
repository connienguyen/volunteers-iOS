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

/// Service wrapper for requests to the eTouches API
final class ETouchesAPIService {
    static let shared = ETouchesAPIService()
    var accessToken: String = ""

    private init() { /* Intentionally left empty */ }

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
