//
//  NPAttributeToggleButton.swift
//  NewPass
//
//  Created by Addison Francisco on 6/12/20.
//  Copyright © 2020 Addison Francisco. All rights reserved.
//

import UIKit

class NPAttributeToggleButton: UIButton {

    var attributeType: PasswordAttribute!

    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderColor = Constants.Colors.primaryGreen.cgColor
                setTitleColor(.white, for: .selected)
            } else {
                layer.borderColor = UIColor.lightGray.cgColor
                setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        addTarget(self, action: #selector(didTouchDown(_:)), for: .touchDown)
        layer.borderWidth = 1.5
        roundify(cornerRadius: 15)
		isSelected = false
    }

    @objc func didTouchDown(_ sender: UIButton) {
        isSelected.toggle()

        if #available(iOS 13.0, *) {
            HapticEngine().hapticTap(style: .rigid)
        } else {
            HapticEngine().hapticTap(style: .light)
        }
    }

}
