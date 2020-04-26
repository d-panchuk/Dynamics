//
//  BubblesMenuView.swift
//  BubblesMenu
//
//  Created by Dima Panchuk on 30.01.2020.
//  Copyright © 2020 dpanchuk. All rights reserved.
//

import UIKit

class BubblesMenuView: UIView {
    
    // MARK: Constants
    
    private let centerItemWidth = 130
    private let surroundingItemWidth = 80
    
    // MARK: Properties
    
    var centerItem: BubbleView? {
        didSet {
            centerItem.flatMap { setupBubble($0, width: centerItemWidth) }
        }
    }
    
    var surroundingItems = [BubbleView]() {
        didSet {
            surroundingItems.forEach { setupBubble($0, width: surroundingItemWidth) }
        }
    }
    
    private var isFirstTimeLayout = true
    
    private lazy var animator = UIDynamicAnimator(referenceView: self)
    private var bubbleBehaviors = [BubbleView: BubbleBehavior]()
    
    private lazy var collisionBehavior: UICollisionBehavior = {
        let collisionBehavior = UICollisionBehavior()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        return collisionBehavior
    }()
    
    private lazy var rotationBehavior: UIDynamicItemBehavior = {
        let rotationBehavior = UIDynamicItemBehavior()
        rotationBehavior.allowsRotation = false
        return rotationBehavior
    }()
    
    // MARK: Computed Properties
    
    var items: [BubbleView] {
        return [centerItem].compactMap {$0} + surroundingItems
    }
    
    var centerPoint: CGPoint { superview!.convert(center, to: self) }
    
    // MARK: Inits
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isFirstTimeLayout {
            initialLayout()
            isFirstTimeLayout.toggle()
        }

        bubbleBehaviors.values.forEach { $0.attachmentPoint = centerPoint }
    }
    
    // MARK: Actions
    
    @objc private func bubbleDidPan(recognizer: UIPanGestureRecognizer) {
        guard let bubbleView = recognizer.view as? BubbleView else { return }
        
        switch recognizer.state {
        case .began:
            bubbleBehaviors[bubbleView]?.isEnabled = false
            
        case .changed:
            let translation = recognizer.translation(in: self)
            bubbleView.center.x = bubbleView.center.x + translation.x
            bubbleView.center.y = bubbleView.center.y + translation.y
            recognizer.setTranslation(.zero, in: self)
            animator.updateItem(usingCurrentState: bubbleView)
            
        case .ended:
            bubbleBehaviors[bubbleView]?.isEnabled = true
            
        default:
            break
        }
    }
    
}

// MARK: - Private
private extension BubblesMenuView {
    
    private func commonInit() {
        animator.addBehavior(collisionBehavior)
        animator.addBehavior(rotationBehavior)
    }
    
    private func setupBubble(_ bubbleView: BubbleView, width: Int) {
        bubbleView.bounds.size = CGSize(width: width, height: width)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(bubbleDidPan))
        bubbleView.isUserInteractionEnabled = true
        bubbleView.addGestureRecognizer(panGesture)
        
        addSubview(bubbleView)
        addItemToBehaviors(bubbleView)
    }
    
    private func addItemToBehaviors(_ item: BubbleView) {
        let bubbleBehavior = BubbleBehavior(item: item, attachmentPoint: centerPoint)
        bubbleBehaviors[item] = bubbleBehavior
        collisionBehavior.addItem(item)
        rotationBehavior.addItem(item)
        animator.addBehavior(bubbleBehavior)
    }
    
    private func initialLayout() {
        layoutCenterItem()
        layoutSurroundingItems()
    }
    
    private func layoutCenterItem() {
        centerItem?.center = centerPoint
        animator.updateItem(usingCurrentState: centerItem!)
    }
    
    private func layoutSurroundingItems() {
        let center = centerPoint
        let radius = CGFloat(centerItemWidth / 2)
        let step = (2 * .pi) / CGFloat(surroundingItems.count)
        var currentAngle: CGFloat = 2 * .pi
        
        for item in surroundingItems {
            let x = cos(currentAngle) * radius + center.x
            let y = sin(currentAngle) * radius + center.y
            
            item.sizeToFit()
            item.center = CGPoint(x: x, y: y)
            
            currentAngle += step
            animator.updateItem(usingCurrentState: item)
        }
    }
    
}
