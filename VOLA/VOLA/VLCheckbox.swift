//
//  VLCheckbox.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/16/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class VLCheckbox: UIButton {
    // TODO set images to checked/unchecked state

    var isChecked: Bool = false {
        didSet {
            // TODO switch checked/unchecked images
            if isChecked {
                setTitle("Y", for: .normal)
            } else {
                setTitle("N", for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isChecked = false
        self.addTarget(self, action: #selector(onPress(sender:)), for: .touchUpInside)
    }

    func onPress(sender: UIButton) {
        guard sender == self else {
            return
        }

        isChecked = !isChecked
    }
}
