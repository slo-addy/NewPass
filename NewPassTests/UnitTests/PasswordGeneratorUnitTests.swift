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
        let sut = PasswordGenerator()
        let passwordString = sut.generate(with: [.numbers], length: 10)

        XCTAssertTrue(passwordString.count == 10)
    }

    func testPasswordStringContainsNumbers() {
        let sut = PasswordGenerator()
        let passwordString = sut.generate(with: [.numbers], length: 10)

        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet) != nil))
    }

    func testPasswordStringContainsLowerCaseLetters() {
        let sut = PasswordGenerator()
        let passwordString = sut.generate(with: [.lowercaseLetters], length: 10)

        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet) != nil))
    }

    func testPasswordStringContainsUpperCaseLetters() {
        let sut = PasswordGenerator()
        let passwordString = sut.generate(with: [.uppercaseLetters], length: 10)

        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet) != nil))
    }

    func testPasswordStringContainsSymbols() {
        let sut = PasswordGenerator()
        let passwordString = sut.generate(with: [.symbols], length: 10)

        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet) != nil))
    }

    func testPasswordStringContainsAllAttributes() {
        let sut = PasswordGenerator()
        let passwordAttributes: [PasswordAttribute] = [.numbers, .symbols, .lowercaseLetters, .uppercaseLetters]
        var passwordString = sut.generate(with: passwordAttributes, length: 12)

        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet) != nil))
        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet) != nil))
        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet) != nil))
        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet) != nil))

        passwordString = sut.generate(with: passwordAttributes, length: 8)

        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet) != nil))
        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet) != nil))
        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet) != nil))
        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet) != nil))

        passwordString = sut.generate(with: passwordAttributes, length: 4)

        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet) != nil))
        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet) != nil))
        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet) != nil))
        XCTAssertTrue((passwordString.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet) != nil))
    }

}
