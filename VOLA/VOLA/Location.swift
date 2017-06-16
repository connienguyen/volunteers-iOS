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
    case address1 = "address1"
    case address2 = "address2"
    case city
    case postCode
    case country
    case phone

    var mapping: String {
        return self.rawValue.lowercased()
    }
}

class Location {
    var name: String = ""
    var address1: String = ""
    var address2: String = ""
    var city: String = ""
    var postCode: String = ""
    var country: String = ""
    var phone: String = ""

    required init?(map: Map) {
        // Required to conform to protocol
    }

    init(name: String = "", addressOne: String = "", addressTwo: String = "", city: String = "",
         postCode: String = "", country: String = "", phone: String = "") {

        self.name = name
        self.address1 = addressOne
        self.address2 = addressTwo
        self.city = city
        self.postCode = postCode
        self.country = country
        self.phone = phone
    }

    func addressString() -> String {
        let mainAddressArray: [String] = [name, address1, address2, city].filter({ $0.trimmed != ""})
        return mainAddressArray.joined(separator: "\n").trimmed
    }
}

extension Location: Mappable {
    func mapping(map: Map) {
        name        <- map[LocationMappable.name.mapping]
        address1    <- map[LocationMappable.address1.mapping]
        address2    <- map[LocationMappable.address2.mapping]
        city        <- map[LocationMappable.city.mapping]
        postCode    <- map[LocationMappable.postCode.mapping]
        country     <- map[LocationMappable.country.mapping]
        phone       <- map[LocationMappable.phone.mapping]
    }
}
