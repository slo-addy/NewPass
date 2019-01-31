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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPasswordMatchesGivenLength() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.containsNumbers], length: 10)

        XCTAssertTrue(randomPass.count == 10)
    }

    func testPasswordStringContainsNumbers() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.containsNumbers], length: 10)
        let decimalCharacters = CharacterSet.decimalDigits

        XCTAssertTrue((randomPass.rangeOfCharacter(from: decimalCharacters) != nil))
    }

    func testPasswordStringContainsLowerCaseLetters() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.containsLowercaseLetters], length: 10)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil))
    }

    func testPasswordStringContainsUpperCaseLetters() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.containsUppercaseLetters], length: 10)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil))
    }

    func testPasswordStringContainsSymbols() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.containsSymbols], length: 10)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: CharacterSet.symbols) != nil))
    }

    func testPasswordStringContainsAllAttributes() {
        let passwordGenerator = PasswordGenerator()
        let randomPass = passwordGenerator.randomPassword(with: [.containsNumbers, .containsSymbols, .containsLowercaseLetters, .containsUppercaseLetters], length: 10)

        XCTAssertTrue((randomPass.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: CharacterSet.symbols) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil))
        XCTAssertTrue((randomPass.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil))
    }
}
