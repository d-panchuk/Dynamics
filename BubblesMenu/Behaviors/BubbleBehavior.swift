//
//  BubbleBehavior.swift
//  BubblesMenu
//
//  Created by Dima Panchuk on 04.02.2020.
//  Copyright © 2020 dpanchuk. All rights reserved.
//

import UIKit

class BubbleBehavior: UIDynamicBehavior {
    
    var attachmentPoint: CGPoint {
        didSet { attachmentBehavior.anchorPoint = attachmentPoint }
    }
    
    var isEnabled: Bool = true {
        didSet {
            if isEnabled {
                addChildBehavior(attachmentBehavior)
                addChildBehavior(physicsBehavior)
            } else {
                removeChildBehavior(attachmentBehavior)
                removeChildBehavior(physicsBehavior)
            }
        }
    }
    
    private let item: UIDynamicItem
    
    private lazy var attachmentBehavior: UIAttachmentBehavior = {
        let attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: attachmentPoint)
        attachmentBehavior.length = 0
        attachmentBehavior.damping = 5
        attachmentBehavior.frequency = 4
        attachmentBehavior.frictionTorque = .infinity
        return attachmentBehavior
    }()
    
    private lazy var physicsBehavior: UIDynamicItemBehavior = {
        let physicsBehavior = UIDynamicItemBehavior(items: [item])
        physicsBehavior.allowsRotation = false
        physicsBehavior.angularResistance = .infinity
        physicsBehavior.density = 0.001 // how hard it's to move item through other items
        return physicsBehavior
    }()
    
    init(item: UIDynamicItem, attachmentPoint: CGPoint) {
        self.item = item
        self.attachmentPoint = attachmentPoint
        
        super.init()
                
        addChildBehavior(attachmentBehavior)
        addChildBehavior(physicsBehavior)
    }
        
}
