//
//  VLHyperLabel.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import FRHyperLabel

class VLHyperLabel: FRHyperLabel {
    func setAttributedString(_ string: String, fontSize: CGFloat) {
        let labelAttributes = [NSForegroundColorAttributeName: UIColor.black,
                               NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)]
        attributedText = NSAttributedString(string: string, attributes: labelAttributes)
    }
}
