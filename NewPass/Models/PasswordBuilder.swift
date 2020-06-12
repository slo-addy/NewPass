//
//  PasswordBuilder.swift
//  NewPass
//
//  Created by Addison Francisco on 7/17/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import Foundation

final class PasswordBuilder {

    /// Returns a randomized password string containing characters matching the given attributes.
	///
    /// - parameters:
    /// 	- attributes: The type of characters that will be within constructed password
    ///		- length: length of password
    ///
    func build(with attributes: [PasswordAttribute], length: Int) -> String {
        // Create an initial string of password characters based on attributes
        let passwordString = constructPasswordString(using: attributes)
        // Randomize password string characters
        let randomPassword = randomize(string: passwordString, length: length, attributes: attributes)

        return randomPassword
    }

    private func constructPasswordString(using attributes: [PasswordAttribute]) -> String {
        var constructedPasswordString = ""

        for attribute in attributes {
            switch attribute {
            case .numbers:
                constructedPasswordString += PasswordAttribute.numbers.rawValue
            case .symbols:
                constructedPasswordString += PasswordAttribute.symbols.rawValue
            case .lowercaseLetters:
                constructedPasswordString += PasswordAttribute.lowercaseLetters.rawValue
            case .uppercaseLetters:
                constructedPasswordString += PasswordAttribute.uppercaseLetters.rawValue
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
