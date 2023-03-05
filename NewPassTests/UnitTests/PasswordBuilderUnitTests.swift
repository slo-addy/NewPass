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
    
    let sut = PasswordBuilder()
    
    func testBuildWithEmptyAttributesReturnsEmptyString() {
        let passwordRequest = PasswordBuildRequest(passwordAttributes: [],
                                                   passwordLength: Constants.defaultPasswordLength)
        let passwordString = sut.build(with: passwordRequest)
        
        XCTAssertTrue(passwordString.isEmpty)
    }
    
    func testBuildWithShortPasswordLengthReturnsEmptyString() {
        let passwordRequest = PasswordBuildRequest(passwordAttributes: [.lowercaseLetters],
                                                   passwordLength: Constants.minPasswordLength - 1)
        let passwordString = sut.build(with: passwordRequest)
        
        XCTAssertTrue(passwordString.isEmpty)
    }
    
    func testBuildWithValidAttributesAndLengthReturnsNonEmptyString() {
        let passwordRequest = PasswordBuildRequest(passwordAttributes: [.lowercaseLetters],
                                                   passwordLength: Constants.minPasswordLength)
        let passwordString = sut.build(with: passwordRequest)
        
        XCTAssertFalse(passwordString.isEmpty)
    }
    
    func testPasswordMatchesGivenLength() {
        let passwordRequest = PasswordBuildRequest(passwordAttributes: [.numbers], passwordLength: 10)
        let passwordString = sut.build(with: passwordRequest)
        
        XCTAssertEqual(passwordString.count, 10)
    }
    
    func testPasswordStringContainsNumbers() {
        let passwordRequest = PasswordBuildRequest(passwordAttributes: [.numbers],
                                                   passwordLength: Constants.defaultPasswordLength)
        let passwordString = sut.build(with: passwordRequest)
        
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet), nil)
    }
    
    func testPasswordStringContainsLowerCaseLetters() {
        let passwordRequest = PasswordBuildRequest(passwordAttributes: [.lowercaseLetters],
                                                   passwordLength: Constants.defaultPasswordLength)
        let passwordString = sut.build(with: passwordRequest)
        
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet), nil)
    }
    
    func testPasswordStringContainsUpperCaseLetters() {
        let passwordRequest = PasswordBuildRequest(passwordAttributes: [.uppercaseLetters],
                                                   passwordLength: Constants.defaultPasswordLength)
        let passwordString = sut.build(with: passwordRequest)
        
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet), nil)
    }
    
    func testPasswordStringContainsSymbols() {
        let passwordRequest = PasswordBuildRequest(passwordAttributes: [.symbols],
                                                   passwordLength: Constants.defaultPasswordLength)
        let passwordString = sut.build(with: passwordRequest)
        
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet), nil)
    }
    
    func testPasswordStringContainsAllAttributes() {
        let passwordAttributes: [PasswordAttribute] = [
            .numbers,
            .symbols,
            .lowercaseLetters,
            .uppercaseLetters
        ]
        let passwordRequest = PasswordBuildRequest(passwordAttributes: passwordAttributes,
                                                   passwordLength: Constants.maxPasswordLength)
        
        var passwordString = sut.build(with: passwordRequest)
        
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet), nil)
        
        passwordString = sut.build(with: PasswordBuildRequest(passwordAttributes: passwordAttributes,
                                                              passwordLength: Constants.defaultPasswordLength))
        
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet), nil)
        
        passwordString = sut.build(with: PasswordBuildRequest(passwordAttributes: passwordAttributes,
                                                              passwordLength: Constants.minPasswordLength))
        
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.numbers.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.symbols.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.lowercaseLetters.characterSet), nil)
        XCTAssertNotEqual(passwordString.rangeOfCharacter(from: PasswordAttribute.uppercaseLetters.characterSet), nil)
    }

}
