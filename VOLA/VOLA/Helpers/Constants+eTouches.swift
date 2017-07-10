//
//  Constants+eTouches.swift
//  VOLA
//
//  Constants to be used by ETouches related files
//
//  Created by Connie Nguyen on 7/2/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

typealias EventCompletionBlock = (_ retrievedEvent: Event?) -> Void

struct ETouchesURL {
    static let baseURL = "https://private-fbd097-tempetouches.apiary-mock.com/"

    // Add-ons to base URLs
    static let accessTokenAddOn = "global/authorize.json"
    static let getEventAddOn = "ereg/getEvent.json"
    static let listEventsAddOn = "global/listEvents.json"
}

enum ETouchesKeys: String {
    case accountID
    case key
    case accessToken
    case eventID
    case customFields
    case fields

    var forURL: String {
        return self.rawValue.lowercased()
    }
}

struct ETouchesParameters {
    static let listEvents = "location,eventid,name,event_image,url"
}
