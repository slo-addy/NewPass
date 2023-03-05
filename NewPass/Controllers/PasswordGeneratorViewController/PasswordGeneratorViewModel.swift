//
//  PasswordGeneratorViewModel.swift
//  NewPass
//
//  Created by Addison Francisco on 8/23/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import Foundation
import UIKit

enum PasswordGenerationError: Error {
    case noAttributes
    case unknown
    
    var description: String {
        switch self {
        case .noAttributes:
            return "You need at least one attribute selected to generate a password."
        case .unknown:
            return "Something went wrong. Give it another try."
        }
    }
}

final class PasswordGeneratorViewModel {
    
    var passwordLength: Int
    var passwordAttributes: [PasswordAttribute]
    
    /// Determines if the user has selected at least one attribute
    var hasSelectedPasswordAttributes: Bool {
        passwordAttributes.isEmpty == false
    }

    /// The password string with color attributes applied
    var styledPassword: NSAttributedString {
        attributedPasswordString(from: passwordString)
    }
    
    private let passwordBuilder: RandomPasswordGenerating = PasswordBuilder()
    private var passwordString: String = ""

    init(passwordAttributes: [PasswordAttribute], passwordLength: Int) {
        self.passwordAttributes = passwordAttributes
        self.passwordLength = passwordLength
    }

    /// Requests a newly built password using the stored `passwordAttributes` and `passwordLength`
    func generatePassword() throws {
        guard hasSelectedPasswordAttributes else {
            throw PasswordGenerationError.noAttributes
        }
        
        let request = PasswordBuildRequest(passwordAttributes: passwordAttributes, passwordLength: passwordLength)
        passwordString = passwordBuilder.build(with: request)
    }

    private func attributedPasswordString(from passwordString: String) -> NSAttributedString {
        let symbolCharColor = [NSAttributedString.Key.foregroundColor: Constants.Colors.symbol]
        let numberCharColor = [NSAttributedString.Key.foregroundColor: Constants.Colors.number]
        let alphabetCharColor = [NSAttributedString.Key.foregroundColor: Constants.Colors.alphabet]
        let attributedString = NSMutableAttributedString()

        for element in passwordString.unicodeScalars {
            let char: NSAttributedString

            if PasswordAttribute.numbers.characterSet.contains(element) {
                char = NSAttributedString(string: "\(element)", attributes: numberCharColor)
            } else if PasswordAttribute.symbols.characterSet.contains(element) {
                char = NSAttributedString(string: "\(element)", attributes: symbolCharColor)
            } else {
                char = NSAttributedString(string: "\(element)", attributes: alphabetCharColor)
            }
            attributedString.append(char)
        }

        return attributedString
    }

}
