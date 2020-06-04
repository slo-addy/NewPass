//
//  PasswordLabelViewModel.swift
//  NewPass
//
//  Created by Addison Francisco on 8/23/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import Foundation
import UIKit

struct PasswordLabelViewModel {

    #warning("Remove tight coupling to PasswordGenerator")
    private let passwordGenerator = PasswordGenerator()
    // Initial password attributes match default attributes
    var passwordAttributes: [PasswordAttribute]
    var hasSelectedPasswordAttributes: Bool {
        return !passwordAttributes.isEmpty
    }

    init(passwordAttributes: [PasswordAttribute] = Constants.defaultPasswordAttributes) {
        self.passwordAttributes = passwordAttributes
    }

    func getRandomPassword(length: Int) -> NSAttributedString {
        let randomPassword = passwordGenerator.randomPassword(with: passwordAttributes, length: length)

        return attributedPasswordString(from: randomPassword)
    }

    private func attributedPasswordString(from passwordString: String) -> NSAttributedString {
        let symbolCharColor = [NSAttributedStringKey.foregroundColor: UIColor(red: 237/255, green: 117/255, blue: 99/255, alpha: 1)]
        let numberCharColor = [NSAttributedStringKey.foregroundColor: UIColor(red: 74/255, green: 196/255, blue: 230/255, alpha: 1)]
        let alphabetCharColor = [NSAttributedStringKey.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]

        let attributedString = NSMutableAttributedString()
        for s in passwordString.unicodeScalars {
            let char: NSAttributedString
            
            if PasswordAttribute.numbers.characterSet.contains(s) {
                char = NSAttributedString(string: "\(s)", attributes: numberCharColor)
            }
            else if PasswordAttribute.symbols.characterSet.contains(s) {
                char = NSAttributedString(string: "\(s)", attributes: symbolCharColor)
            }
            else {
                char = NSAttributedString(string: "\(s)", attributes: alphabetCharColor)
            }
            attributedString.append(char)
        }
        return attributedString
    }
    
}
