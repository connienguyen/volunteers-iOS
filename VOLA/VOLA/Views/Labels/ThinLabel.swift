//
//  ThinLabel.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/8/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/// Stylized label with a lighter weight font
class ThinLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()

        let fontSize = font.pointSize
        font = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightLight)
    }
}
