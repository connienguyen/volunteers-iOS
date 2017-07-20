//
//  URL.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/12/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

extension URL {
    /**
    Open URL from shared application
     
    - Parameters:
        - url: URL to open
    */
    static func applicationOpen(url: URL?) {
        guard let validURL = url else {
            Logger.error("\(VLError.invalidURL.errorDescription) \(url)")
            return
        }

        UIApplication.shared.openURL(validURL)
    }
}
