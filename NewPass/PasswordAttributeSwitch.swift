//
//  PasswordSwitch.swift
//  NewPass
//
//  Created by Addison Francisco on 7/25/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import UIKit

class PasswordAttributeSwitch: UISwitch {
    
    var attributeType: PasswordAttribute?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // All switches need to be off initially
        self.isOn = false
    }
}

