//
//  Theme+Fonts.swift
//  VOLA
//
//  Created by Bruno Henriques on 31/05/2017.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import UIKit

extension Theme {
    enum Font: String {
        case font1 = "MyCustomFontName"

        var identifier: String {
            return rawValue
        }
    }
}


extension UIFont {
    convenience init(_ font: Theme.Font, size: CGFloat) {
        self.init(name: font.identifier, size: size)!
    }
}
