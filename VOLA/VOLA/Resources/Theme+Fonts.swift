//
//  Theme+Fonts.swift
//  VOLA
//
//  Created by Bruno Henriques on 31/05/2017.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import UIKit

/**
Text sizes to use throughout app
 
 - normal: For body text
 - small: For smaller labels at the bottom of a page
*/
enum TextSize: CGFloat {
    case normal = 16.0
    case small = 14.0

    var fontSize: CGFloat {
        return rawValue
    }
}
