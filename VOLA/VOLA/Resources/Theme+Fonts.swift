//
//  Theme+Fonts.swift
//  VOLA
//
//  Created by Bruno Henriques on 31/05/2017.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import UIKit

enum ThemeFont: String {
    case title = "MyCustomFont"

    var identifier: String {
        return rawValue
    }
}

extension UIFont {
    convenience init(_ font: ThemeFont, size: CGFloat) {
        self.init(name: font.identifier, size: size)!
    }
}

enum TextSize: CGFloat {
    case normal = 16.0

    var fontSize: CGFloat {
        return rawValue
    }
}
