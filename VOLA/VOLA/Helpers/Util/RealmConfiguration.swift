//
//  RealmConfiguration.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/3/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmConfiguration {
    static let config = Realm.Configuration(
        schemaVersion: 1,
        migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: User.className()) { oldObject, _ in
                    // Delete old objects since primary key has changed
                    if let old = oldObject {
                        migration.delete(old)
                    }
                }
            }
        }
    )
}
