//
//  NPBodyLabel.swift
//  NewPass
//
//  Created by Addison Francisco on 6/4/20.
//  Copyright © 2020 Addison Francisco. All rights reserved.
//

import UIKit

class NPBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
    }

    private func configure() {
        textColor = .white
        font = UIFont(name: "Menlo", size: 14)
        adjustsFontForContentSizeCategory = false // TODO: Accessibility improvements
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
