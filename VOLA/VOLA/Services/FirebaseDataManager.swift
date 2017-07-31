//
//  FirebaseDataManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/29/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import FirebaseDatabase

/// Class for managing reading from and writing to Firebase realtime database
class FirebaseDataManager {
    enum UserTableField: String {
        case email

        var key: String {
            return rawValue
        }
    }

    static let shared = FirebaseDataManager()

    let reference = FIRDatabase.database().reference()

    private init() { /* intentionally left blank */ }

    /**
    Save user to users table on Firebase and set email value to user's email
     https://github.com/systers/volunteers-android/wiki/Firebase-Documentation---Volunteers-Android
     
    - Parameters:
        - email: Email address of user to save to database
    */
    func setUser(email: String) {
        let emailHash = email.sha1HexString()
        reference.table(.users).child(emailHash).child(UserTableField.email.key).setValue(email)
    }
}
