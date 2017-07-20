//
//  Intro.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/12/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

/// Data for introduction slides
struct Intro {
    struct IntroDetail {
        var title: String
        var detail: String
        var imageName: String
    }

    static let introSlides: [IntroDetail] = [
        IntroDetail(title: "slide-0.title.label".localized, detail: "slide-0.detail.label".localized, imageName: ""),
        IntroDetail(title: "slide-1.title.label".localized, detail: "slide-1.detail.label".localized, imageName: ""),
        IntroDetail(title: "slide-2.title.label".localized, detail: "slide-2.detail.label".localized, imageName: "")
    ]
}
