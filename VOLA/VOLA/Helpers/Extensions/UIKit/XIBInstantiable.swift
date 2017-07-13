//
//  XIBInstantiable.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/12/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation

protocol XIBInstantiable {
    static var associatedNib: UINib { get }
}

extension XIBInstantiable {
    static var associatedNib: UINib {
        let name = String(describing: self)
        return UINib(nibName: name, bundle: Bundle.main)
    }

    static func instantiateFromXib() -> Self {
        guard let view =  associatedNib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("Could not load from nib.")
        }

        return view
    }
}
