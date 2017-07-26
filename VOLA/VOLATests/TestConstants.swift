//
//  TestConstants.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/29/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
@testable import VOLA

struct InputConstants {
    static let validEmail = "systers.volunteers@gmail.com"
    static let validEmailSpecialCharacter = "systers.volunteers+1@gmail.com"
    static let incompleteEmail = "incomplete@gmail"
    static let whitespaceEmail = "systers.volunteers@gmail.com "
    static let validName = "Anita Borg"
    static let validNameMultiple = "Anne Isabella Milbanke"
    static let validNameSpecial = "Åsa Blomström"
    static let validNameApostrophe = "Jerry O'Connell"
    static let validNameHyphen = "Joseph Gordon-Levitt"
    static let validNameMono = "Cher"
    static let invalidNameSpecial = "Ca$h Money"
    static let validPassword = "MyPassword1"
    static let invalidPasswordAllLowercase = "mypassword"
    static let invalidPasswordWhitespace = "My password1"
    static let invalidPasswordShort = "5maLL"
    static let validRequiredInput = "Textfield input"
    static let validRequiredInputSpecial = "Hur är läget?"
    static let invalidRequiredInputEmpty = ""
    static let invalidRequiredInputSpace = " "
    static let invalidRequiredInputWhitespace = "\r\t"
}

struct EventTestConstants {
    static let testEventID = 1
    static let testEventName = "Test Event Name - from JSON"
    static let availableEventsCount = 3
}

struct EventStubURI {
    static let getEventDetail = ETouchesURL.baseURL + ETouchesURL.getEventAddOn +
            "{?\(ETouchesKeys.accessToken.forURL),\(ETouchesKeys.eventID.forURL),\(ETouchesKeys.customFields.forURL)}"
    static let getAvailableEvents = ETouchesURL.baseURL + ETouchesURL.listEventsAddOn +
            "{?\(ETouchesKeys.accessToken.forURL),\(ETouchesKeys.fields.forURL)}"
}
