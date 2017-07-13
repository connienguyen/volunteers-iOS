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
            //  TODO switch checked/unchecked images. Y/N are used temporarily to show
            //  Yes/No
            if isChecked {
                setTitle(UIDisplay.yes.localized, for: .normal)
            } else {
                setTitle(UIDisplay.no.localized, for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isChecked = false
        self.addTarget(self, action: #selector(onPress(sender:)), for: .touchUpInside)
    }

    func onPress(sender: UIButton) {
        isChecked = !isChecked
    }
}
