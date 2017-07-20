//
//  Completions.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

typealias VoidCompletionBlock = () -> Void
typealias ErrorCompletionBlock = (_ error: Error?) -> Void
typealias ResultCompletionBlock = ((_ result: [String:Any]?, _ error: Error?) -> Void)
