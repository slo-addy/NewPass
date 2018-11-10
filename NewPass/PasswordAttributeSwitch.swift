//
//  PasswordSwitch.swift
//  NewPass
//
//  Created by Addison Francisco on 7/25/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import UIKit

class PasswordAttributeSwitch: UISwitch {

    // all `PasswordAttributeSwitch` must have an attributeType, so this does not need to be optional.
    // We just have to be certain that we set this value before we need it (e.g. in viewDidLoad) or we'll crash.
    var attributeType: PasswordAttribute!

    /// The state of the switch the first time the user launches the app 
    var initialState: Bool = true

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setToInitialState()
    }

    public func setToInitialState() {
        self.isOn = initialState
        self.setOn(initialState, animated: false)
    }
}
