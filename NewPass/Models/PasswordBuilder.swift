//
//  PasswordBuilder.swift
//  NewPass
//
//  Created by Addison Francisco on 7/17/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import Foundation

struct PasswordBuildRequest {
    /// The type of characters that will be within constructed password
    let passwordAttributes: [PasswordAttribute]
    /// The amount of characters required in the built password
    let passwordLength: Int
}

protocol RandomPasswordGenerating {
    /// Returns a randomized password string containing characters matching the given attributes.
    func build(with request: PasswordBuildRequest) -> String
}

final class PasswordBuilder: RandomPasswordGenerating {
    
    func build(with request: PasswordBuildRequest) -> String {
        guard request.passwordAttributes.isEmpty == false,
              request.passwordLength >= Constants.minPasswordLength else {
            return ""
        }
        
        // Create an initial string of password characters based on attributes
        let passwordString = constructPasswordString(using: request.passwordAttributes)
        // Randomize password string characters
        let randomPassword = randomizeCharacters(in: passwordString,
                                                 passwordLength: request.passwordLength,
                                                 attributes: request.passwordAttributes)

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
    
    /// Randomizes the characters in the provided `string` to generate a password string of `passwordLength`
    /// characters that satisfies the given `attributes`. This function first generates an array of random
    /// bytes using the SecureRandom framework. It then uses each random byte to select a character from
    /// the `string`. The resulting string is checked to ensure that it contains at least one character
    /// from each attribute. If the resulting string does not satisfy the attributes, the function
    /// recursively calls itself until a valid password is generated.
    ///
    /// - Parameters:
    ///    - string: The source string containing the characters to be randomized.
    ///    - passwordLength: The desired length of the password to be generated.
    ///    - attributes: An array of `PasswordAttribute` objects defining the required character types in the password.
    /// - Returns: A randomized password string of length `passwordLength` containing characters matching the given `attributes`.
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
        attributes.allSatisfy { passwordString.rangeOfCharacter(from: $0.characterSet) != nil }
    }
}
