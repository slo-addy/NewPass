//
//  PasswordLabelViewModelTests.swift
//  NewPassTests
//
//  Created by Addison Francisco on 8/10/19.
//  Copyright © 2019 Addison Francisco. All rights reserved.
//

import XCTest
@testable import NewPass

class PasswordLabelViewModelTests: XCTestCase {

    func testHasSelectedPasswordAttributes() {
        let sut = PasswordLabelViewModel()

        sut.passwordAttributes = []
        XCTAssertEqual(sut.hasSelectedPasswordAttributes, false)

        sut.passwordAttributes = [.containsNumbers]
        XCTAssertEqual(sut.hasSelectedPasswordAttributes, true)

        sut.passwordAttributes = [.containsSymbols]
        XCTAssertEqual(sut.hasSelectedPasswordAttributes, true)

        sut.passwordAttributes = [.containsLowercaseLetters]
        XCTAssertEqual(sut.hasSelectedPasswordAttributes, true)

        sut.passwordAttributes = [.containsUppercaseLetters]
        XCTAssertEqual(sut.hasSelectedPasswordAttributes, true)

        sut.passwordAttributes = [.containsNumbers,
                                  .containsSymbols,
                                  .containsLowercaseLetters,
                                  .containsUppercaseLetters]
        XCTAssertEqual(sut.hasSelectedPasswordAttributes, true)
    }
}
