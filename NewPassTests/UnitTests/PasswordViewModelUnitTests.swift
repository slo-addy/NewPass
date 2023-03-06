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
    
    func testPasswordLengthTextUpdatesWhenPasswordLengthIsUpdated() throws {
        let sut = PasswordGeneratorViewModel(passwordLength: Constants.minPasswordLength)
        XCTAssertEqual(sut.passwordLengthText, "Password Length: \(Constants.minPasswordLength)")
        
        sut.passwordLength = Constants.maxPasswordLength
        XCTAssertEqual(sut.passwordLengthText, "Password Length: \(Constants.maxPasswordLength)")
    }
    
    func testDeterminesIfNoAttributesAreSelected() throws {
        let sut = PasswordGeneratorViewModel(passwordAttributes: [.uppercaseLetters],
                                             passwordLength: Constants.defaultPasswordLength)
        XCTAssertEqual(sut.hasSelectedPasswordAttributes, true)
        
        sut.passwordAttributes = []
        XCTAssertEqual(sut.hasSelectedPasswordAttributes, false)
    }
    
    func testThrowsNoAttributesErrorWhenGeneratingPasswordWithNoAttributesSelected() throws {
        let sut = PasswordGeneratorViewModel(passwordAttributes: [],
                                             passwordLength: Constants.defaultPasswordLength)
        
        XCTAssertThrowsError(try sut.generatePassword()) { error in
            XCTAssertEqual(error as? PasswordGenerationError, .noAttributes)
        }
    }
    
    func testPasswordAttributesAreUpdated() throws {
        let sut = PasswordGeneratorViewModel(passwordAttributes: [.lowercaseLetters],
                                             passwordLength: Constants.defaultPasswordLength)
        XCTAssertEqual(sut.passwordAttributes, [.lowercaseLetters])
        
        sut.passwordAttributes = [.uppercaseLetters]
        XCTAssertEqual(sut.passwordAttributes, [.uppercaseLetters])
    }
    
    func testPasswordLengthIsUpdated() throws {
        let sut = PasswordGeneratorViewModel(passwordAttributes: [.lowercaseLetters],
                                             passwordLength: Constants.maxPasswordLength)
        XCTAssertEqual(sut.passwordLength, Constants.maxPasswordLength)
        
        sut.passwordLength = Constants.minPasswordLength
        XCTAssertEqual(sut.passwordLength, Constants.minPasswordLength)
    }
    
    func testPasswordColorsAreCorrectWhenAlphabetCharactersAreUsed() throws {
        let sut = PasswordGeneratorViewModel(passwordAttributes: [.lowercaseLetters, .uppercaseLetters],
                                             passwordLength: Constants.defaultPasswordLength)
        try sut.generatePassword()
        
        let result = extractColors(from: sut.styledPassword)
        XCTAssertTrue(result.contains(Constants.Colors.alphabet))
    }
    
    func testPasswordColorsAreCorrectWhenNumberCharactersAreUsed() throws {
        let sut = PasswordGeneratorViewModel(passwordAttributes: [.numbers],
                                             passwordLength: Constants.defaultPasswordLength)
        try sut.generatePassword()
        
        let result = extractColors(from: sut.styledPassword)
        XCTAssertTrue(result.contains(Constants.Colors.number))
    }
    
    func testPasswordColorsAreCorrectWhenSymbolCharactersAreUsed() throws {
        let sut = PasswordGeneratorViewModel(passwordAttributes: [.symbols],
                                             passwordLength: Constants.defaultPasswordLength)
        try sut.generatePassword()
        
        let result = extractColors(from: sut.styledPassword)
        XCTAssertTrue(result.contains(Constants.Colors.symbol))
    }
    
    func testPasswordColorsAreCorrectWhenAllCharacterTypesAreUsed() throws {
        let passwordAttributes: [PasswordAttribute] = [
            .uppercaseLetters,
            .lowercaseLetters,
            .numbers,
            .symbols
        ]
        let sut = PasswordGeneratorViewModel(passwordAttributes: passwordAttributes,
                                             passwordLength: Constants.defaultPasswordLength)
        try sut.generatePassword()
        
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
