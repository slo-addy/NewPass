//
//  Constants.swift
//  NewPass
//
//  Created by Addison Francisco on 1/30/19.
//  Copyright © 2019 Addison Francisco. All rights reserved.
//

import Foundation
import UIKit

struct Constants {

    static let minPasswordLength: Int = 8
    static let maxPasswordLength: Int = 32
    static let defaultPasswordLength: Int = 12
    static let defaultPasswordAttributes: [PasswordAttribute] = [.lowercaseLetters, .uppercaseLetters, .numbers]

    struct Colors {
        /// Primary green color
        static let primaryGreen = UIColor(red: 93/255, green: 175/255, blue: 113/255, alpha: 1)
    	/// Color used for password symbol characters
    	static let symbol = UIColor(red: 237/255, green: 117/255, blue: 99/255, alpha: 1)
    	/// Color used for password number characters
    	static let number = UIColor(red: 74/255, green: 196/255, blue: 230/255, alpha: 1)
		/// Color used for password alphabet characters
    	static let alphabet = UIColor.white
    }

}
