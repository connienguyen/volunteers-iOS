//
//  UIScrollView.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/12/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

extension UIScrollView {

    func loadScrollPages(views: [UIView]) {
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        contentSize = CGSize(width: frame.width * CGFloat(views.count), height: 1.0)
        for i in 0..<views.count {
            let view = views[i]
            let frame = CGRect(x: self.frame.width * CGFloat(i), y: 0.0, width: self.frame.width,
                               height: self.frame.height)
            view.frame = frame
            self.addSubview(view)
        }
    }

    func scrollToPage(page: Int) {
        var newFrame = self.frame
        let scrollToX = self.frame.width * CGFloat(page)
        newFrame.origin.x = scrollToX
        newFrame.origin.y = 0.0
        guard scrollToX <= self.contentSize.width - self.frame.width else {
            Logger.error("Attempted to scroll beyond last page.")
            return
        }
        self.scrollRectToVisible(newFrame, animated: true)
    }

    func pageNumber() -> Int {
        let viewWidth = self.frame.width
        let pageNumber = floor((self.contentOffset.x - viewWidth * 0.5) / viewWidth) + 1
        return Int(pageNumber)
    }
}
