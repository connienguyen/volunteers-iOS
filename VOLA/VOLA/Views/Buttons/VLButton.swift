//
//  VLButton.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/7/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

fileprivate let cornerRadius: CGFloat = 5.0

/// Stylized custom button class used throughout the app
class VLButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = cornerRadius
        let fontSize = titleLabel?.font.pointSize ?? 0.0
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightSemibold)
    }
}
