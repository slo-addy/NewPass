//
//  NPButton.swift
//  NewPass
//
//  Created by Addison Francisco on 6/4/20.
//  Copyright © 2020 Addison Francisco. All rights reserved.
//

import UIKit

class NPButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }

    private func configure() {
        roundify(cornerRadius: 6)
        titleLabel?.font = UIFont(name: "Menlo", size: 17)
        setTitleColor(.white, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }

    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}
