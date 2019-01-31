//
//  Constants.swift
//  NewPass
//
//  Created by Addison Francisco on 1/30/19.
//  Copyright © 2019 Addison Francisco. All rights reserved.
//

import Foundation

struct Constants {
    static let defaultPasswordLength: Int = 10
    static let defaultPasswordAttributes: [PasswordAttribute] = [.containsLowercaseLetters, .containsUppercaseLetters, .containsNumbers]
}
