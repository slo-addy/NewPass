//
//  UIView+Utils.swift
//  NewPass
//
//  Created by Addison Francisco on 11/1/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func roundify(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}
