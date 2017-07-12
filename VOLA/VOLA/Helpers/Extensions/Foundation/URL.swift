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
        - error: Error in case URL could not be opened
    */
    static func applicationOpen(url: URL?, error: Error) {
        guard let url = url else {
            Logger.error(error.localizedDescription)
            return
        }

        UIApplication.shared.openURL(url)
    }
}
