//
//  PasswordGenerator.swift
//  NewPass
//
//  Created by Addison Francisco on 7/17/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import Foundation

final class PasswordGenerator {

    func randomPassword(with attributes: [PasswordAttribute], length: Int) -> String {
        // Create an initial string of password characters based on attributes
        let passwordString = constructedPasswordString(using: attributes)
        // Randomize password string characters
        let randomPassword = randomize(string: passwordString, length: length, attributes: attributes)

        return randomPassword
    }

    private func constructedPasswordString(using attributes: [PasswordAttribute]) -> String {
        var constructedPasswordString = ""
        let lowercasedAlphabet = PasswordAttribute.lowercaseLetters.rawValue
        let uppercasedAlphabet = PasswordAttribute.uppercaseLetters.rawValue
        let numbers = PasswordAttribute.numbers.rawValue
        let symbols = PasswordAttribute.symbols.rawValue

        for attribute in attributes {
            switch attribute {
            case .numbers:
                constructedPasswordString += randomize(string: numbers)
            case .symbols:
                constructedPasswordString += randomize(string: symbols)
            case .lowercaseLetters:
                constructedPasswordString += randomize(string: lowercasedAlphabet)
            case .uppercaseLetters:
                constructedPasswordString += randomize(string: uppercasedAlphabet)
            }
        }

        return constructedPasswordString
    }

    private func randomize(string: String, length: Int = 26, attributes: [PasswordAttribute] = []) -> String {
        var randomString: String = ""

        while randomString.count < length {
            let randomizedOffset = arc4random_uniform(UInt32(string.count))
            randomString += "\(string[string.index(string.startIndex, offsetBy: Int(randomizedOffset))])"
        }

        if !allAttributeCharsPresent(for: randomString, attributes: attributes) && !attributes.isEmpty {
            randomString = randomize(string: string, length: length, attributes: attributes)
        }

        return randomString
    }

    private func allAttributeCharsPresent(for passwordString: String, attributes: [PasswordAttribute]) -> Bool {
        for attribute in attributes {
            if passwordString.rangeOfCharacter(from: attribute.characterSet) != nil {
                continue
            } else {
                return false
            }
        }

        return true
    }

}
