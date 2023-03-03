//
//  PasswordGeneratorViewModel.swift
//  NewPass
//
//  Created by Addison Francisco on 8/23/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import Foundation
import UIKit

final class PasswordGeneratorViewModel {

    private let passwordBuilder = PasswordBuilder()
    private var passwordString: String = ""
    private(set) var passwordLength: Int
    private(set) var passwordAttributes: [PasswordAttribute]

    /// Determines if the user has selected at least one attribute
    var hasSelectedPasswordAttributes: Bool {
        return !passwordAttributes.isEmpty
    }

    /// The password string with color attributes applied
    var styledPassword: NSAttributedString {
        return attributedPasswordString(from: passwordString)
    }

    init(passwordAttributes: [PasswordAttribute], passwordLength: Int) {
        self.passwordAttributes = passwordAttributes
        self.passwordLength = passwordLength
    }

    /// Updates the model's password attributes. These changes will be applied to the next
    /// password that is generated. This does not affect the currently stored password.
    func update(attributes: [PasswordAttribute]) {
        passwordAttributes = attributes
    }

    /// Updates the model's password length. These changes will be applied to the next
    /// password that is generated and will not affect the currently stored password.
    func update(length: Int) {
        passwordLength = length
    }

    /// Requests a newly built password using the stored `passwordAttributes` and `length`
    func fetchNewPassword() {
        guard hasSelectedPasswordAttributes else {
            return
        }

        passwordString = passwordBuilder.build(with: passwordAttributes, passwordLength: passwordLength)
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
