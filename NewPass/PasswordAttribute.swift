//
//  PasswordAttribute.swift
//  NewPass
//
//  Created by Addison Francisco on 8/11/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import Foundation

enum PasswordAttribute: String {

    case lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
    case uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case numbers = "1234567890"
    case symbols = "!@#$%^&*()[]{};?"

    var characterSet: CharacterSet {
        return CharacterSet(charactersIn: self.rawValue)
    }

}
