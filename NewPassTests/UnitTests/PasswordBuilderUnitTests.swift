//
//  PasswordBuilderUnitTests.swift
//  NewPassTests
//
//  Created by Addison Francisco on 11/4/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import XCTest
@testable import NewPass

class PasswordBuilderUnitTests: XCTestCase {

    func testPasswordMatchesGivenLength() {
        let sut = PasswordBuilder()
        let passwordString = sut.build(with: [.numbers], passwordLength: 10)

        XCTAssertEqual(passwordString.count, 10)
    }

    func testPasswordStringContainsNumbers() {
        let sut = PasswordBuilder()
        let passwordString = sut.build(with: [.numbers], passwordLength: 10)

        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet), nil)
    }

    func testPasswordStringContainsLowerCaseLetters() {
        let sut = PasswordBuilder()
        let passwordString = sut.build(with: [.lowercaseLetters], passwordLength: 10)

        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet), nil)
    }

    func testPasswordStringContainsUpperCaseLetters() {
        let sut = PasswordBuilder()
        let passwordString = sut.build(with: [.uppercaseLetters], passwordLength: 10)

        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet), nil)
    }

    func testPasswordStringContainsSymbols() {
        let sut = PasswordBuilder()
        let passwordString = sut.build(with: [.symbols], passwordLength: 10)

        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet), nil)
    }

    func testPasswordStringContainsAllAttributes() {
        let sut = PasswordBuilder()
        let passwordAttributes: [PasswordAttribute] = [.numbers, .symbols, .lowercaseLetters, .uppercaseLetters]
        var passwordString = sut.build(with: passwordAttributes, passwordLength: 12)

        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet), nil)

        passwordString = sut.build(with: passwordAttributes, passwordLength: 8)

        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet), nil)

        passwordString = sut.build(with: passwordAttributes, passwordLength: 4)

        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet), nil)
    }

}
