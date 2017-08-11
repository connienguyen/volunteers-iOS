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
    static let userUID = "someUID"
    static let userUID2 = "anotherUID"
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

struct SecretKeysConstants {
    static let fileName = "SecretTestKeys"
    static let invalidFileName = "DoesNotExist"
    static let secretKey = "TestAPI"
    static let secretValue = "testAPIkeyVaLuE123"
    static let invalidSecretKey = "testAPI"
}

struct SplitNameConstants {
    static let standardFullName = "Jane Doe"
    static let standardFirstName = "Jane"
    static let standardLastName = "Doe"
    static let oneWordFullName = "Cher"
    static let oneWordFirstName = "Cher"
    static let oneWordLastName = ""
    static let multiWordFullName = "Ann Marie Smith"
    static let multiWordFirstName = "Ann Marie"
    static let multiWordLastName = "Smith"
    static let superMultiWordFullName = "Mary Anne Smith Jones"
    static let superMultiWordFirstName = "Mary Anne"
    static let superMultiWordLastName = "Jones"
}
