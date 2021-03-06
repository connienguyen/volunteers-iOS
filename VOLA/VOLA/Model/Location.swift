//
//  Location.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Enum to organize mappable fields on Location from JSON
*/
enum LocationMappable: String {
    case name
    case address1
    case address2
    case city
    case postCode
    case country
    case phone
    case latitude
    case longitude

    /// JSON key to map from
    var mapping: String {
        return self.rawValue.lowercased()
    }
}

/// Model for Location data within an Event
class Location {
    var name: String = ""
    var address1: String = ""
    var address2: String = ""
    var city: String = ""
    var postCode: String = ""
    var country: String = ""
    var phone: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0

    /// Full address as one string, separated by newlines
    var addressString: String {
        let mainAddressArray: [String] = [name, address1, address2, city].filter({ !$0.trimmed.isEmpty})
        return mainAddressArray.joined(separator: "\n").trimmed
    }

    /// Shortened address as one string, separated by newlines
    var shortAddressString: String {
        let shortAddressArray: [String] = [name, address1, address2].filter({ !$0.trimmed.isEmpty })
        return shortAddressArray.joined(separator: "\n").trimmed
    }

    var isDefaultCoords: Bool {
        return latitude == 0.0 && longitude == 0.0
    }

    required init?(map: Map) {
        // Required to conform to protocol
    }

    /// Used to initialize Location object with default values (e.g. in Event)
    init() { /* intentionally empty */ }
}

// MARK: - Conform to protocol for Mappable
extension Location: Mappable {
    func mapping(map: Map) {
        name        <- map[LocationMappable.name.mapping]
        address1    <- map[LocationMappable.address1.mapping]
        address2    <- map[LocationMappable.address2.mapping]
        city        <- map[LocationMappable.city.mapping]
        postCode    <- map[LocationMappable.postCode.mapping]
        country     <- map[LocationMappable.country.mapping]
        phone       <- map[LocationMappable.phone.mapping]
        latitude    <- map[LocationMappable.latitude.mapping]
        longitude   <- map[LocationMappable.longitude.mapping]
    }
}
