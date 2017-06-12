//
//  IntroSlideView.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/10/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class IntroSlideView: UIView, XIBInstantiable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupView() {
        let view = IntroSlideView.instantiateFromXib()
        view.frame = bounds
        addSubview(view)
    }
}
