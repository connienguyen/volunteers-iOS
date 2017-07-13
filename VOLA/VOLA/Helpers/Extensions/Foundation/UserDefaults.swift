//
//  UserDefaults.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/12/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

struct Defaults {
    static func getObject(forKey: DefaultsKey) -> Any? {
        return UserDefaults.standard.object(forKey: forKey.rawValue)
    }

    static func setObject(forKey: DefaultsKey, object: Any?) {
        UserDefaults.standard.set(object, forKey: forKey.rawValue)
    }
}
