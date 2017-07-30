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

    func retrieveAccessToken() {
        let URL = ETouchesURL.baseURL + ETouchesURL.accessTokenAddOn
        var accountID: String
        var accountKey: String
        do {
            accountID = try SecretKeyManager.shared.value(for: .eTouchesAccount)
            accountKey = try SecretKeyManager.shared.value(for: .eTouchesKey)
        } catch {
            Logger.error(error)
            return
        }

        let parameters: [String: Any] = [
            ETouchesKeys.accountID.forURL: accountID,
            ETouchesKeys.key.forURL: accountKey
        ]

        Alamofire.request(URL, parameters: parameters, encoding: URLEncoding.default)
            .validate().responseObject { (response: DataResponse<ETouchesAccessToken>) in
                let accessTokenResponse = response.result.value
                guard let eTouchesToken = accessTokenResponse else {
                    Logger.error("Could not retrieve eTouches access token")
                    return
                }

                self.accessToken = eTouchesToken.accessToken
        }
    }
}
