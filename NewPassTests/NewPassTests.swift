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
        let randomPass = Password.randomPassword(with: [.containsNumbers], length: 10)
        
        XCTAssertTrue(randomPass.count == 10)
    }
    
    func testPasswordStringContainsNumbers() {
        let randomPass = Password.randomPassword(with: [.containsNumbers], length: 10)
        let decimalCharacters = CharacterSet.decimalDigits
        
        XCTAssertTrue((randomPass.rangeOfCharacter(from: decimalCharacters) != nil))
    }
    
    func testPasswordStringContainsAlphanumerics() {
        let randomPass = Password.randomPassword(with: [.containsLowercaseLetters], length: 10)
        let alphanumericCharacters = CharacterSet.alphanumerics
        
        XCTAssertTrue((randomPass.rangeOfCharacter(from: alphanumericCharacters) != nil))
    }
    
    func testPasswordStringContainsSymbols() {
        let randomPass = Password.randomPassword(with: [.containsSymbols], length: 10)
        let symbolCharacters = CharacterSet.symbols
        
        XCTAssertTrue((randomPass.rangeOfCharacter(from: symbolCharacters) != nil))
    }
    
}
