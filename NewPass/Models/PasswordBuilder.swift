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
    ///		- passwordLength: length of password
    ///
    func build(with attributes: [PasswordAttribute], passwordLength: Int) -> String {
        // Create an initial string of password characters based on attributes
        let passwordString = constructPasswordString(using: attributes)
        // Randomize password string characters
        let randomPassword = randomizeCharacters(in: passwordString, passwordLength: passwordLength, attributes: attributes)

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
    
    private func randomizeCharacters(in string: String, passwordLength: Int, attributes: [PasswordAttribute]) -> String {
        var randomBytes = [UInt8](repeating: 0, count: passwordLength)
        let status = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)

        guard status == errSecSuccess else {
            return ""
        }

        var randomString = ""

        for byte in randomBytes {
            let randomIndex = Int(byte) % string.count
            let index = string.index(string.startIndex, offsetBy: randomIndex)
            randomString += String(string[index])
        }

        if allAttributeCharsPresent(for: randomString, attributes: attributes) == false {
            randomString = randomizeCharacters(in: string, passwordLength: passwordLength, attributes: attributes)
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
