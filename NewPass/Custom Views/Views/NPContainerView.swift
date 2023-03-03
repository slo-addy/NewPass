//
//  NPContainerView.swift
//  NewPass
//
//  Created by Addison Francisco on 6/4/20.
//  Copyright © 2020 Addison Francisco. All rights reserved.
//

import UIKit

class NPAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        roundify(cornerRadius: 16)
        translatesAutoresizingMaskIntoConstraints = false
    }

}
