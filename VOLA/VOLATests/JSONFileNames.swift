//
//  JSONFilesNAmes.swift
//  VOLA
//
//  JSONFileNames will load specific JSON files for unit testing (mocking API responses)
//
//  Created by Connie Nguyen on 7/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

enum JSONFileNames: String {
    case eventDetail = "GetEventDetail"
    case availableEvents = "GetAvailableEvents"

    var fileData: Data {
        guard let path = Bundle(for: ETouchesAPIServiceUnitTests.self).url(forResource: self.rawValue, withExtension: "json") else {
            fatalError(VLError.loadJSONData.localizedDescription)
        }

        do {
            let data = try Data(contentsOf: path)
            return data
        } catch {
            Logger.error(error)
        }

        // If it has reached this point, throw an error
        fatalError(VLError.loadJSONData.localizedDescription)
    }
}
