//
//  PasswordCharacterSet.swift
//  NewPass
//
//  Created by Addison Francisco on 8/11/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import Foundation

enum PasswordAttribute: String {
    case containsAlphabet = "abcdefghijklmnopqrstuvwxyz"
    case containsUppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case containsNumbers = "1234567890"
    case containsSymbols = "!@#$%^&*"
}

struct PasswordCharacterSet {
    static let alphabet = CharacterSet(charactersIn: PasswordAttribute.containsAlphabet.rawValue)
    static let uppercaseAlphabet = CharacterSet(charactersIn: PasswordAttribute.containsUppercaseLetters.rawValue)
    static let numbers = CharacterSet(charactersIn: PasswordAttribute.containsNumbers.rawValue)
    static let symbols = CharacterSet(charactersIn: PasswordAttribute.containsSymbols.rawValue)
}
