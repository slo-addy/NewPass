//
//  PasswordGeneratorUnitTests.swift
//  NewPassTests
//
//  Created by Addison Francisco on 11/4/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import XCTest
@testable import NewPass

class PasswordGeneratorUnitTests: XCTestCase {

    func testPasswordMatchesGivenLength() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.numbers], length: 10)

        XCTAssertTrue(randomPass.count == 10)
    }

    func testPasswordStringContainsNumbers() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.numbers], length: 10)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet) != nil))
    }

    func testPasswordStringContainsLowerCaseLetters() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.lowercaseLetters], length: 10)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet) != nil))
    }

    func testPasswordStringContainsUpperCaseLetters() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.uppercaseLetters], length: 10)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet) != nil))
    }

    func testPasswordStringContainsSymbols() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.symbols], length: 10)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet) != nil))
    }

    func testPasswordStringContainsAllAttributes() {
        let passwordGenerator = PasswordGenerator()
        let passwordAttributes: [PasswordAttribute] = [.numbers, .symbols, .lowercaseLetters, .uppercaseLetters]
        var randomPass = passwordGenerator.randomPassword(with: passwordAttributes, length: 12)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet) != nil))

        randomPass = passwordGenerator.randomPassword(with: passwordAttributes, length: 8)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet) != nil))

        randomPass = passwordGenerator.randomPassword(with: passwordAttributes, length: 4)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet) != nil))
    }
}
