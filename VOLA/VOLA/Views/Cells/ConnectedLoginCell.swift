//
//  ConnectedLoginCell.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/1/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit


fileprivate let isConnectedKey = "connected-status.title.label"
fileprivate let isNotConnectedKey = "not-connected-status.title.label"

/// Table cell which displays the current status of a connected login
class ConnectedLoginCell: UITableViewCell {
    static let estimatedCellHeight: CGFloat = 75.0
    
    @IBOutlet weak var connectedLoginImage: CircleImageView!
    @IBOutlet weak var connectedLoginStatus: TextLabel!

    /// Configure the cell to show login provider connection status
    func configureCell(_ provider: LoginProvider, connectedStatus: Bool) {
        var labelText = provider.providerID
        let statusText = connectedStatus ? isConnectedKey.localized : isNotConnectedKey.localized
        labelText += ": " + statusText
        connectedLoginStatus.text = labelText
    }
}
