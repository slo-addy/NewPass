//
//  HapticEngine.swift
//  NewPass
//
//  Created by Addison Francisco on 8/26/18.
//  Copyright © 2018 Addison Francisco. All rights reserved.
//

import UIKit

class HapticEngine {
    
    static func hapticWarning() {
        let warningNotificationFeedbackGenerator = UINotificationFeedbackGenerator()
        warningNotificationFeedbackGenerator.notificationOccurred(.error)
    }
    
    static func hapticTap(impactStyle: UIImpactFeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: impactStyle)
        generator.impactOccurred()
    }
}
