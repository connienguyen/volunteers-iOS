//
//  Event.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import ObjectMapper

enum EventType {
    case registered
    case volunteering
    case unregistered
}

enum EventMapable: String {
    case eventID
    case name
    case description
    case location
    case sponsorImageURL = "sponsor_image_url"

    var mapping: String {
        return self.rawValue.lowercased()
    }
}

class Event {
    var eventID: Int = 0
    var name: String?
    var description: String?
    var location: Location?
    var sponsorImageURL: URL?
    var eventType: EventType = .unregistered

    required init?(map: Map) {
        // Required to conform to Mappable; can do JSON validation here
    }

    convenience init(eventID: Int = 0, name: String = "", description: String = "", location: Location? = nil,
         sponsorImage: URL? = nil) {

        self.init()
        
        self.eventID = eventID
        self.name = name
        self.description = description
        if let foundLocation = location {
            self.location = foundLocation
        } else {
            self.location = Location()
        }
        self.sponsorImageURL = sponsorImage
    }
}

extension Event: Mappable {
    func mapping(map: Map) {
        eventID         <- map[EventMapable.eventID.mapping]
        name            <- map[EventMapable.name.mapping]
        description     <- map[EventMapable.description.mapping]
        location        <- map[EventMapable.location.mapping]
        sponsorImageURL <- (map[EventMapable.sponsorImageURL.mapping], URLTransform())
    }
}
