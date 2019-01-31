//
//  NewPassTests.swift
//  NewPassTests
//
//  Created by Addison Francisco on 11/4/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import XCTest
@testable import NewPass

class NewPassTests: XCTestCase {

    func testPasswordMatchesGivenLength() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.containsNumbers], length: 10)

        XCTAssertTrue(randomPass.count == 10)
    }

    func testPasswordStringContainsNumbers() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.containsNumbers], length: 10)
        let decimalCharacters = PasswordCharacterSet.numbers

        XCTAssertTrue((randomPass.rangeOfCharacter(from: decimalCharacters) != nil))
    }

    func testPasswordStringContainsLowerCaseLetters() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.containsLowercaseLetters], length: 10)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.alphabet) != nil))
    }

    func testPasswordStringContainsUpperCaseLetters() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.containsUppercaseLetters], length: 10)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.uppercaseAlphabet) != nil))
    }

    func testPasswordStringContainsSymbols() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.containsSymbols], length: 10)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.symbols) != nil))
    }

    func testPasswordStringContainsAllAttributes() {
        let passwordGenerator = PasswordGenerator()
        let passwordAttributes: [PasswordAttribute] = [.containsNumbers, .containsSymbols, .containsLowercaseLetters, .containsUppercaseLetters]
        var randomPass = passwordGenerator.randomPassword(with: passwordAttributes, length: 12)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.numbers) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.symbols) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.alphabet) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.uppercaseAlphabet) != nil))

        randomPass = passwordGenerator.randomPassword(with: passwordAttributes, length: 8)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.numbers) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.symbols) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.alphabet) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.uppercaseAlphabet) != nil))

        randomPass = passwordGenerator.randomPassword(with: passwordAttributes, length: 4)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.numbers) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.symbols) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.alphabet) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordCharacterSet.uppercaseAlphabet) != nil))
    }
}
