//
//  ETouchesAccessToken.swift
//  VOLA
//
//  ETouchesAccessToken is a mappable model that keeps track of the access token
//  for eTouches and will keep track of whether or not the token will need to be
//  refreshed
//
//  Created by Connie Nguyen on 7/2/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import ObjectMapper

class ETouchesAccessToken: Mappable {
    enum ETouchesMapping: String {
        case accessToken

        var mapping: String {
            return self.rawValue.lowercased()
        }
    }

    var accessToken: String = ""

    required init?(map: Map) {
        // Required to conform to Mappable; can do JSON validation here
    }
}

extension ETouchesAccessToken {
    func mapping(map: Map) {
        accessToken     <- map[ETouchesAccessToken.ETouchesMapping.accessToken.mapping]
    }
}
