//
//  TitleLabel.swift
//  VOLA
//
//  TitleLabel is the UILabel to be used for title elements
//
//  Created by Connie Nguyen on 7/8/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class TitleLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()

        let fontSize = font.pointSize
        font = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold)
    }
}
