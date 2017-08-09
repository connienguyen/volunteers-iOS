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
    static let config = Realm.Configuration(schemaVersion: 1, migrationBlock: nil)
}
