//
//  VLCheckbox.swift
//  VOLA
//
//  VLCheckbox is a custom UIButton that displays a checked and not checked state
//
//  Created by Connie Nguyen on 6/16/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class VLCheckbox: UIButton {
    // TODO set images to checked/unchecked state

    var isChecked: Bool = false {
        didSet {
            //  TODO switch checked/unchecked images. Y/N are used temporarily to show
            //  Yes/No
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
