//
//  PasswordViewModelUnitTests.swift
//  NewPassTests
//
//  Created by Addison Francisco on 6/10/20.
//  Copyright © 2020 Addison Francisco. All rights reserved.
//

import XCTest
@testable import NewPass

class PasswordViewModelUnitTests: XCTestCase {

    func testDeterminesIfNoAttributesAreSelected() {
        let sut = PasswordGeneratorViewModel(passwordAttributes: [.uppercaseLetters], passwordLength: 32)
        XCTAssertEqual(sut.hasSelectedPasswordAttributes, true)

        sut.update(attributes: [])
        XCTAssertEqual(sut.hasSelectedPasswordAttributes, false)
    }

    func testPasswordAttributesAreUpdated() {
        let sut = PasswordGeneratorViewModel(passwordAttributes: [.lowercaseLetters], passwordLength: 32)
        XCTAssertEqual(sut.passwordAttributes, [.lowercaseLetters])

        sut.update(attributes: [.uppercaseLetters])
        XCTAssertEqual(sut.passwordAttributes, [.uppercaseLetters])
    }

    func testPasswordLengthIsUpdated() {
        let sut = PasswordGeneratorViewModel(passwordAttributes: [.lowercaseLetters], passwordLength: 32)
        XCTAssertEqual(sut.passwordLength, 32)

        sut.update(length: 8)
        XCTAssertEqual(sut.passwordLength, 8)
    }

    func testPasswordColorsAreCorrectWhenAlphabetCharactersAreUsed() {
        let sut = PasswordGeneratorViewModel(passwordAttributes: [.lowercaseLetters, .uppercaseLetters], passwordLength: 8)
        sut.fetchNewPassword()

        let result = extractColors(from: sut.styledPassword)
        XCTAssertTrue(result.contains(Constants.Colors.alphabet))
    }

    func testPasswordColorsAreCorrectWhenNumberCharactersAreUsed() {
        let sut = PasswordGeneratorViewModel(passwordAttributes: [.numbers], passwordLength: 8)
        sut.fetchNewPassword()

        let result = extractColors(from: sut.styledPassword)
        XCTAssertTrue(result.contains(Constants.Colors.number))
    }

    func testPasswordColorsAreCorrectWhenSymbolCharactersAreUsed() {
        let sut = PasswordGeneratorViewModel(passwordAttributes: [.symbols], passwordLength: 8)
        sut.fetchNewPassword()

        let result = extractColors(from: sut.styledPassword)
        XCTAssertTrue(result.contains(Constants.Colors.symbol))
    }

    func testPasswordColorsAreCorrectWhenAllCharacterTypesAreUsed() {
        let sut = PasswordGeneratorViewModel(passwordAttributes: [.uppercaseLetters, .lowercaseLetters, .numbers, .symbols],
                                             passwordLength: 8)
        sut.fetchNewPassword()

        let result = extractColors(from: sut.styledPassword)
        XCTAssertTrue(result.allSatisfy([Constants.Colors.alphabet, Constants.Colors.number, Constants.Colors.symbol].contains))
    }

}

extension PasswordViewModelUnitTests {
    
    func extractColors(from attributedString: NSAttributedString) -> [UIColor?] {
        var colorResults = [UIColor?]()

        attributedString.enumerateAttributes(in: NSRange(location: 0, length: attributedString.string.count)) { attributes, _, _ in
            attributes.forEach { key, value in
                switch key {
                case NSAttributedString.Key.foregroundColor:
                    colorResults.append(value as? UIColor)
                default:
                    assert(key == NSAttributedString.Key.paragraphStyle, "Unknown attribute found in the attributed string")
                }
            }
        }

        return colorResults
    }
}
