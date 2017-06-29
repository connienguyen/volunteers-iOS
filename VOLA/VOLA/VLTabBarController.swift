//
//  VLTabBarController.swift
//  VOLA
//
//  VLTabBarController handles the tab bar navigation of the app
//  and set the default page to be shown.
//
//  Created by Connie Nguyen on 6/10/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

class VLTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        selectedIndex = 1       // Set "Home" as default
    }
}
