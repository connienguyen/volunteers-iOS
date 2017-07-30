//
//  FirebaseDataManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/29/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseDataManager {
    enum FirebaseTables: String {
        case users

        var tableName: String {
            return rawValue
        }
    }

    static let shared = FirebaseDataManager()

    let reference = FIRDatabase.database().reference()

    private init() { /* intentionally left blank */ }

    func setUser(email: String) {
        let emailHash = email.sha1HexString()
        reference.child(FirebaseTables.users.tableName).child(emailHash).child("user_email_id").setValue(email)
    }
}
