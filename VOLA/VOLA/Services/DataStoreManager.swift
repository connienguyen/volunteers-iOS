//
//  DataStoreManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/20/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import RealmSwift

final class DataStoreManager {
    static let shared = DataStoreManager()

    let realm = try! Realm()

    func save<T: Object>(_ object: T) {
        try! realm.write {
            realm.add(object)
        }
    }
}
