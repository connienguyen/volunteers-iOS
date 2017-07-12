//
//  TextLabel.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/8/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/// Stylized default label to be used throughout the app
class TextLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()

        let fontSize = font.pointSize
        font = UIFont.systemFont(ofSize: fontSize)
    }
}
