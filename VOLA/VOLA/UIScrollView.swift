//
//  UIScrollView.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/12/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

extension UIScrollView {

    func loadScrollPages<T: UIView>(pageCount: Int, subviewType: T.Type) {
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        contentSize = CGSize(width: frame.width * CGFloat(pageCount), height: 0.0)
        for i in 0..<pageCount {
            let frame = CGRect(x: self.frame.width * CGFloat(i), y: 0.0, width: self.frame.width,
                               height: self.frame.height)
            let subView = T(frame: frame)
            self.addSubview(subView)
        }
    }

    func scrollToPage(page: Int) {
        var frame = self.frame
        let width = self.frame.width
        let scrollToX = width * CGFloat(page)
        guard scrollToX <= (self.contentSize.width - width) else {
            Logger.error("Attempt to scroll beyond last page.")
            return
        }
        frame.origin.x = scrollToX
        frame.origin.y = 0.0
        self.scrollRectToVisible(frame, animated: true)
    }
}
