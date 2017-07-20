//
//  Constants+Realm.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/20/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmConfigs {
    static let defaultConfig = Realm.Configuration(
        schemaVersion: 0
        // TODO: in future have migration block
    )
}
