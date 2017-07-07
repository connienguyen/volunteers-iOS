//
//  Constants.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

struct NotificationName {
    static let googleDidSignIn = Notification.Name("googleDidSignIn")
}

enum DefaultsKey: String {
    case shownIntro
    case selectedTheme
}

enum Segue: String {
    case showLoginManual
    case showEditProfile

    var identifier: String {
        return rawValue
    }
}

enum DictKeys: String {
    case fields
    case user
    case ok = "OK"
}

enum UserNumbers: UInt {
    case twiceImageIcon = 200
}

struct FBRequest {
    static let graphPath = "me"
    static let graphParameters = "email, name"
    static let readPermissions = ["public_profile", "email"]
    static let imageURLFormat = "https://graph.facebook.com/%@/picture?type=large"
}

struct ABIURL {
    // TODO set to real URL values
    static let termsOfService = URL(string: "https://anitaborg.org")
    static let privacyPolicy = URL(string: "https://anitaborg.org")
}
