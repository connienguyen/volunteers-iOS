//
//  VLButton.swift
//  VOLA
//
//  VLButton is the custom button class that will be used throughout the app
//
//  Created by Connie Nguyen on 7/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class VLButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5.0
        let fontSize = titleLabel?.font.pointSize ?? 0.0
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold)
    }
}
