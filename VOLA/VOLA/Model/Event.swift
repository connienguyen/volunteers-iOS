//
//  Event.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import ObjectMapper

enum EventType: String {
    case registered
    case volunteering
    case unregistered

    var labelText: String {
        return self.rawValue.capitalized
    }
}

enum EventMapable: String {
    case eventID
    case name
    case description
    case location
    case areVolunteersNeeded = "needs_volunteers"
    case eventImageURL = "event_image_url"
    case sponsorImageURL = "sponsor_image_url"

    var mapping: String {
        return self.rawValue.lowercased()
    }
}

class Event {
    var eventID: Int = 0
    var name: String = ""
    var description: String = ""
    var location: Location = Location()
    var areVolunteersNeeded: Bool = false
    var eventImageURL: URL?
    var sponsorImageURL: URL?
    var eventType: EventType = .unregistered

    required init?(map: Map) {
        // Required to conform to Mappable; can do JSON validation here
    }

    init() { /* Used to initialized an Event with default values (i.e. in EventDetailViewController) */}
}

extension Event: Mappable {
    func mapping(map: Map) {
        eventID             <- map[EventMapable.eventID.mapping]
        name                <- map[EventMapable.name.mapping]
        description         <- map[EventMapable.description.mapping]
        location            <- map[EventMapable.location.mapping]
        areVolunteersNeeded <- map[EventMapable.areVolunteersNeeded.mapping]
        eventImageURL       <- (map[EventMapable.eventImageURL.mapping], URLTransform())
        sponsorImageURL     <- (map[EventMapable.sponsorImageURL.mapping], URLTransform())
    }
}
