//
//  Location.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/13/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import ObjectMapper

enum LocationMappable: String {
    case name
    case addressOne = "address1"
    case addressTwo = "address2"
    case city
    case postCode
    case country
    case phone

    var mapping: String {
        return self.rawValue.lowercased()
    }
}

class Location {
    var name: String?
    var addressOne: String?
    var addressTwo: String?
    var city: String?
    var postCode: String?
    var country: String?
    var phone: String?

    required init?(map: Map) {
        // Required to conform to protocol
    }

    init(name: String? = nil, addressOne: String? = nil, addressTwo: String? = nil, city: String? = nil,
         postCode: String? = nil, country: String? = nil, phone: String? = nil) {

        self.name = name
        self.addressOne = addressOne
        self.addressTwo = addressTwo
        self.city = city
        self.postCode = postCode
        self.country = country
        self.phone = phone
    }
}

extension Location: Mappable {
    func mapping(map: Map) {
        name        <- map[LocationMappable.name.mapping]
        addressOne  <- map[LocationMappable.addressOne.mapping]
        addressTwo  <- map[LocationMappable.addressTwo.mapping]
        city        <- map[LocationMappable.city.mapping]
        postCode    <- map[LocationMappable.postCode.mapping]
        country     <- map[LocationMappable.country.mapping]
        phone       <- map[LocationMappable.phone.mapping]
    }
}
