//
//  ThinLabel.swift
//  VOLA
//
//  ThinLabel is a stylized custom label to use a lighter weight font
//
//  Created by Connie Nguyen on 7/8/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class ThinLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()

        let fontSize = font.pointSize
        font = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightLight)
    }
}
