//
//  DefaultManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/11/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

/// Single point to handle retrieving and synchronizing user defaults within the app
final class DefaultsManager {
    /**
    Key for value to be retrieved from UserDefaults
     
    - shownIntro: Has the app shown the Introduction slides (Bool)
    */
    enum DefaultsKey: String {
        case shownIntro
    }

    static let shared = DefaultsManager()

    private init() { /* intentionally left empty */ }

    /**
     Retrieves a Bool value from standard user defaults
    
     - Parameters:
        - forKey: Key for value in standard user defaults
     
     - Returns: Returns value saved in user defaults. If no value has yet been stored, returns false
    */
    func getBool(forKey: DefaultsKey) -> Bool {
        return UserDefaults.standard.bool(forKey: forKey.rawValue)
    }

    /**
     Sets a Bool value into standard user defautls
     
     - Parameters:
        - forKey: Key to set value for in standard user defaults
        - value: Bool to store in standard user defaults
    */
    func setBool(forKey: DefaultsKey, value: Bool) {
        UserDefaults.standard.set(value, forKey: forKey.rawValue)
    }
}
