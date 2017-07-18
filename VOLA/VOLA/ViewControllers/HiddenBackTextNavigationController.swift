//
//  HiddenBackTextNavigationController.swift
//  VOLA
//
//  Created by Connie Nguyen on 7/18/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class HiddenBackTextNavigationController: UINavigationController {
    @IBInspectable var hideBackText: Bool = true

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        handleBackTitle()
        super.pushViewController(viewController, animated: animated)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: true)
    }

    override func show(_ vc: UIViewController, sender: Any?) {
        handleBackTitle()
        super.show(vc, sender: sender)
    }

    func handleBackTitle() {
        if hideBackText {
            topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}
