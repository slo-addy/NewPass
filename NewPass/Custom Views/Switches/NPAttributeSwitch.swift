//
//  PasswordSwitch.swift
//  NewPass
//
//  Created by Addison Francisco on 7/25/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import UIKit

class NPAttributeSwitch: UISwitch {

    // Force unwrapped because all password switches must have an attribute assigned to them
    var attributeType: PasswordAttribute!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // Make sure all switches are initially off so they can be animated on when view appears
        self.isOn = false
    }

}
