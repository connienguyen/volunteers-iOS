//
//  Event.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import ObjectMapper

/**
    Type of event in relation to the user
 
    - registered: For events the user is registered
    - volunteering: For events the user is registered for as a volunteer
    - unregistered: For events the user is not registered for
*/
enum EventType: String {
    case registered
    case volunteering
    case unregistered

    /// Display text to be used for labels
    var labelText: String {
        return self.rawValue.capitalized
    }
}

/**
    Enum to organize mappable fields on Event from JSON
*/
enum EventMapable: String {
    case eventID
    case name
    case description
    case location
    case areVolunteersNeeded = "needs_volunteers"
    case eventImageURL = "event_image_url"
    case sponsorImageURL = "sponsor_image_url"

    /// JSON key to map from
    var mapping: String {
        return self.rawValue.lowercased()
    }
}

/// Model for Event data
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

    /// Used to initialized an Event with default values (i.e. in EventDetailViewController)
    init() { /* Intentionally empty */}
}

// MARK:- Conform to protocol for Mappable
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
