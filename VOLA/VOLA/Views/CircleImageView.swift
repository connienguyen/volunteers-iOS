//
//  CircleImageView.swift
//  VOLA
//
//  CircleImageView display an image in a circular view
//
//  Created by Connie Nguyen on 7/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = false
        layer.cornerRadius = frame.height/2.0
        clipsToBounds = true
    }
}
