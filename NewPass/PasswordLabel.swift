//
//  PasswordLabel.swift
//  NewPass
//
//  Created by Addison Francisco on 7/21/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import Foundation
import UIKit

/// Custom UILabel class that allows copying of the label text
class PasswordLabel: UILabel {

//    override public var canBecomeFirstResponder: Bool {
//        get {
//            return true
//        }
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//
//    private func setup() {
//        isUserInteractionEnabled = true
//        addGestureRecognizer(UILongPressGestureRecognizer(
//            target: self,
//            action: #selector(showCopyMenu(sender:))
//        ))
//    }
//
//    override func copy(_ sender: Any?) {
//        UIPasteboard.general.string = text
//        UIMenuController.shared.setMenuVisible(false, animated: true)
//    }
//
//    @objc func showCopyMenu(sender: Any?) {
//        becomeFirstResponder()
//        let menu = UIMenuController.shared
//        if !menu.isMenuVisible {
//            menu.setTargetRect(bounds, in: self)
//            menu.setMenuVisible(true, animated: true)
//            HapticEngine().hapticTap(impactStyle: .light)
//        }
//    }
//
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        return (action == #selector(copy(_:)))
//    }
}
