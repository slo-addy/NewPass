//
//  PasswordViewModel.swift
//  NewPass
//
//  Created by Addison Francisco on 8/23/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import Foundation
import UIKit

class PasswordViewModel {

    private let passwordGenerator = PasswordGenerator()
    private(set) var passwordLength: Int
    private(set) var passwordString: String = ""
    private(set) var passwordAttributes: [PasswordAttribute]

    var hasSelectedPasswordAttributes: Bool {
        return !passwordAttributes.isEmpty
    }

    var styledPassword: NSAttributedString {
        return attributedPasswordString(from: passwordString)
    }

    init(passwordAttributes: [PasswordAttribute], passwordLength: Int) {
        self.passwordAttributes = passwordAttributes
        self.passwordLength = passwordLength
    }

    func update(attributes: [PasswordAttribute]) {
        passwordAttributes = attributes
    }

    func update(length: Int) {
        passwordLength = length
    }

    func fetchNewPassword() {
        passwordString = passwordGenerator.generate(with: passwordAttributes, length: passwordLength)
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
