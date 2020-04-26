//
//  StickyCornersBehavior.swift
//  BubblesMenu
//
//  Created by Dima Panchuk on 04.02.2020.
//  Copyright © 2020 dpanchuk. All rights reserved.
//

import UIKit

enum StickyCorner: Int, CaseIterable {
    case topRight, bottomRight, bottomLeft, topLeft
}

class StickyCornersBehavior: UIDynamicBehavior {
    
    // MARK: Properties
    
    var isEnabled: Bool = true {
        didSet {
            if isEnabled {
                physicsBehavior.addItem(item)
                fieldBehaviors.forEach { $0.addItem(item) }
            } else {
                physicsBehavior.removeItem(item)
                fieldBehaviors.forEach { $0.removeItem(item) }
            }
        }
    }
    
    var currentCorner: StickyCorner {
        var _currentCorner = StickyCorner.topLeft
        let itemPosition = item.center
        
        fieldBehaviors.enumerated().forEach { index, fieldBehavior in
            let fieldPosition = fieldBehavior.position
            let point = CGPoint(x: itemPosition.x - fieldPosition.x, y: itemPosition.y - fieldPosition.y)
            
            let isItemInCorner = fieldBehavior.region.contains(point)
            if isItemInCorner { _currentCorner = StickyCorner(rawValue: index)! }
        }
        return _currentCorner
    }
    
    private var item: UIDynamicItem
    private var cornerInset: CGFloat
    
    private lazy var fieldBehaviors: [UIFieldBehavior] = {
        var fieldBehaviors = [UIFieldBehavior]()
        for corner in StickyCorner.allCases {
            let springBehavior = UIFieldBehavior.springField()
            springBehavior.addItem(item)
            fieldBehaviors += [springBehavior]
        }
        return fieldBehaviors
    }()
    
    private lazy var collosionBehavior: UICollisionBehavior = {
        let collosionBehavior = UICollisionBehavior(items: [item])
        collosionBehavior.translatesReferenceBoundsIntoBoundary = true
        return collosionBehavior
    }()
    
    private lazy var physicsBehavior: UIDynamicItemBehavior = {
        let physicsBehavior = UIDynamicItemBehavior(items: [item])
        physicsBehavior.allowsRotation = false
        physicsBehavior.density = 0.01
        physicsBehavior.resistance = 10
        return physicsBehavior
    }()
    
    // MARK: Inits
    
    init(item: UIDynamicItem, cornerInset: CGFloat) {
        self.item = item
        self.cornerInset = cornerInset
        
        super.init()
        
        addChildBehavior(collosionBehavior)
        addChildBehavior(physicsBehavior)
        fieldBehaviors.forEach { addChildBehavior($0) }
    }
    
    // MARK: Lifecycle
    
    override func willMove(to dynamicAnimator: UIDynamicAnimator?) {
        super.willMove(to: dynamicAnimator)
        
        guard let viewBounds = dynamicAnimator?.referenceView?.bounds else { return }
        layoutFields(in: viewBounds)
    }
    
    // MARK: Public methods
    
    func layoutFields(in bounds: CGRect) {
        guard !bounds.equalTo(.zero) else { return }

        let dx = cornerInset + item.bounds.width / 2
        let dy = cornerInset + item.bounds.height / 2
        
        func updateFieldOfStickyCorner(_ corner: StickyCorner, newPosition: CGPoint) {
            let behavior = fieldBehaviors[corner.rawValue]
            let regionWidth = (bounds.width / 2 - dx) * 2
            let regionHeight = (bounds.height / 2 - dy) * 2
            
            behavior.position = newPosition
            behavior.region = UIRegion(size: CGSize(width: regionWidth, height: regionHeight))
        }
        
        let topRightPosition = CGPoint(x: bounds.width - dx, y: dy)
        let bottomRightPosition = CGPoint(x: bounds.width - dx, y: bounds.height - dy)
        let bottomLeftPosition = CGPoint(x: dx, y: bounds.height - dy)
        let topLeftPosition = CGPoint(x: dx, y: dy)
        
        updateFieldOfStickyCorner(.topRight, newPosition: topRightPosition)
        updateFieldOfStickyCorner(.bottomRight, newPosition: bottomRightPosition)
        updateFieldOfStickyCorner(.bottomLeft, newPosition: bottomLeftPosition)
        updateFieldOfStickyCorner(.topLeft, newPosition: topLeftPosition)
    }
    
    func addLinearVelocity(_ velocity: CGPoint) {
        physicsBehavior.addLinearVelocity(velocity, for: item)
    }
    
    func position(for corner: StickyCorner) -> CGPoint {
        return fieldBehaviors[corner.rawValue].position
    }
        
}
