//
//  UIKitDynamics+.swift
//  BubblesMenu
//
//  Created by Dima Panchuk on 04.02.2020.
//  Copyright © 2020 dpanchuk. All rights reserved.
//

import UIKit

extension UIDynamicAnimator {
    
    func addBehaviors(_ behaviors: [UIDynamicBehavior]) {
        behaviors.forEach(addBehavior)
    }
    
}
