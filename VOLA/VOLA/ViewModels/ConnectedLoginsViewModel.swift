//
//  ConnectedLoginsViewModel.swift
//  VOLA
//
//  Created by Connie Nguyen on 8/4/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

class ConnectedLoginViewModel {
    let availableLogins = LoginProvider.allProviders

    func loginIsConnected(_ provider: LoginProvider) -> Bool {
        guard let currentUser = DataManager.shared.currentUser else {
            Logger.error(AuthenticationError.notLoggedIn)
            return false
        }

        let foundProvider = currentUser.providers.first(where: { $0 == provider})
        return foundProvider != nil
    }

    func connectedLoginsCount() -> Int {
        guard let currentUser = DataManager.shared.currentUser else {
            Logger.error(AuthenticationError.notLoggedIn)
            return 1
        }

        return currentUser.providers.count
    }
}
