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
    case streetAddress = "street_address"
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
    var streetAddress: String = ""
    var city: String = ""
    var postCode: String = ""
    var country: String = ""
    var phone: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0

    /// Full address as one string, separated by newlines
    var addressString: String {
        let mainAddressArray: [String] = [name, streetAddress, city].filter({ !$0.trimmed.isEmpty})
        return mainAddressArray.joined(separator: "\n").trimmed
    }

    /// Shortened address as one string, separated by newlines
    var shortAddressString: String {
        let shortAddressArray: [String] = [name, streetAddress].filter({ !$0.trimmed.isEmpty })
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
        name            <- map[LocationMappable.name.mapping]
        streetAddress   <- map[LocationMappable.streetAddress.mapping]
        city            <- map[LocationMappable.city.mapping]
        postCode        <- map[LocationMappable.postCode.mapping]
        country         <- map[LocationMappable.country.mapping]
        phone           <- map[LocationMappable.phone.mapping]
        latitude        <- map[LocationMappable.latitude.mapping]
        longitude       <- map[LocationMappable.longitude.mapping]
    }
}
