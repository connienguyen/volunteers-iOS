//
//  ConnectedLoginCell.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/1/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

/**
Table cell which displays the current status of a connected login
*/
class ConnectedLoginCell: UITableViewCell {
    static let estimatedCellHeight: CGFloat = 75.0
    
    @IBOutlet weak var connectedLoginImage: CircleImageView!
    @IBOutlet weak var connectedLoginStatus: TextLabel!
}