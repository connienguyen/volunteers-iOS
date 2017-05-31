//
//  Theme.swift
//  VOLA
//
//  Created by Bruno Henriques on 31/05/2017.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation


struct Theme {}

extension Theme {
    enum Colors: String {
        case color1 = "ECA650"
    }
}

///usage UIColor(.myColor)
extension UIColor {
    convenience init(_ themeColor: Theme.Colors) {
        self.init(hexString: themeColor.rawValue)
    }
}
