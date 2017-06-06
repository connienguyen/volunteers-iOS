//
//  SocialLoginManager.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

class SocialLoginManager {
    static let sharedInstance = SocialLoginManager()

    func retrieveFacebookUser(completion: @escaping ResultCompletionBlock) {
        guard FBSDKAccessToken.current() != nil else {
            let error = NSError(domain: "FacebookAccessToken", code: 1, userInfo: nil)
            completion(nil, error)
            return
        }

        let parameters = ["fields": "email, name"]
        FBSDKGraphRequest.init(graphPath: "me", parameters: parameters).start { (_, result, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let response = result as? [String:Any] else {
                let error = NSError(domain: "Bad response", code: 1, userInfo: nil)
                completion(nil, error)
                return
            }

            completion(response, nil)
        }
    }
}
