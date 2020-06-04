//
//  UIView+Utils.swift
//  NewPass
//
//  Created by Addison Francisco on 11/1/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import UIKit

extension UIView {

    func roundify(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }

}
