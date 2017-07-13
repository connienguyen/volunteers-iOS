//
//  String.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/14/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

extension String {
    public var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
