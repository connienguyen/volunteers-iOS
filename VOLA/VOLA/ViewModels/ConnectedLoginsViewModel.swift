//
//  ConnectedLoginsViewModel.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/4/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

/// View model for display information about connected logins
class ConnectedLoginViewModel {
    let availableLogins = LoginProvider.allProviders

    /**
        Check whether user has connected login to their account
     
        - Parameters:
            - provider: Login provider to check
     
        - Returns: `Bool` of whether or not login is connected to Firebase account
    */
    func loginIsConnected(_ provider: LoginProvider) -> Bool {
        guard let currentUser = DataManager.shared.currentUser else {
            Logger.error(AuthenticationError.notLoggedIn)
            return false
        }

        let foundProvider = currentUser.providers.first(where: { $0 == provider})
        return foundProvider != nil
    }

    /// Number of connected logins on current user's account
    func connectedLoginsCount() -> Int {
        guard let currentUser = DataManager.shared.currentUser else {
            Logger.error(AuthenticationError.notLoggedIn)
            return 1
        }

        return currentUser.providers.count
    }
}
