//
//  UIFont+Extensions.swift
//  NewPass
//
//  Created by Addison Francisco on 6/5/20.
//  Copyright © 2020 Addison Francisco. All rights reserved.
//

import UIKit

extension UIFont {

    var bold: UIFont {
        return with(.traitBold)
    }

    var italic: UIFont {
        return with(.traitItalic)
    }

    var boldItalic: UIFont {
        return with([.traitBold, .traitItalic])
    }

    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let symbolicTraits = UIFontDescriptor.SymbolicTraits(traits).union(fontDescriptor.symbolicTraits)

        guard let descriptor = fontDescriptor.withSymbolicTraits(symbolicTraits) else {
            return self
        }

        return UIFont(descriptor: descriptor, size: 0)
    }

}
