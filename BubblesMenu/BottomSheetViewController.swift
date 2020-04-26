//
//  BottomSheetViewController.swift
//  BubblesMenu
//
//  Created by Dima Panchuk on 04.02.2020.
//  Copyright © 2020 dpanchuk. All rights reserved.
//

import UIKit


class BottomSheetViewController: UIViewController, Storyboarded {
    
    // MARK: Views
    
    @IBOutlet private weak var translationControlView: UIView!
    @IBOutlet private weak var translationHeaderView: UIView!
    private var shape: UIView = {
        let shapeFrame = CGRect(x: 50, y: 50, width: 100, height: 150)
        let shape = UIView(frame: shapeFrame)
        shape.backgroundColor = .red
        shape.cornerRadius = 10
        return shape
    }()
    
    // MARK: Properties
    
    var fullViewTopInset: CGFloat = 45
    var partialViewContentHeight: CGFloat = 70
    
    private var partialViewTopInset: CGFloat {
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return UIScreen.main.bounds.height - (statusBarHeight + partialViewContentHeight)
    }
    private let frameTransitionAnimationTime = 0.3
    private let shapeCornerInset: CGFloat = 30
    
    private lazy var animator = UIDynamicAnimator(referenceView: view)
    private lazy var stickyCornersBehavior: StickyCornersBehavior = {
        StickyCornersBehavior(item: shape, cornerInset: shapeCornerInset)
    }()
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let frame = self.view.frame
        UIView.animate(withDuration: frameTransitionAnimationTime) {
            self.view.frame = CGRect(x: 0, y: self.partialViewTopInset, width: frame.width, height: frame.height)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let corner = stickyCornersBehavior.currentCorner

        let newSize = CGSize(width: size.width, height: size.height - fullViewTopInset)
        let newBounds = CGRect(origin: .zero, size: newSize)
        stickyCornersBehavior.layoutFields(in: newBounds)

        coordinator.animate(alongsideTransition: nil, completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.shape.center = self.stickyCornersBehavior.position(for: corner)
                self.animator.updateItem(usingCurrentState: self.shape)
            }
        })
    }
    
    // MARK: Gestures
    
    @objc private func sheetDidPan(recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: view)
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        let frame = view.frame
        
        switch recognizer.state {
        case .began:
            let isPointInsideHeader = translationHeaderView.frame.contains(point)
            if !isPointInsideHeader { recognizer.cancel() }
            
        case .changed:
            let yPosition = frame.minY + translation.y
            if yPosition >= fullViewTopInset && yPosition <= partialViewTopInset {
                view.frame = CGRect(x: 0, y: yPosition, width: frame.width, height: frame.height)
            }
            
        case .ended:
            let yPosition = velocity.y >= 0 ? partialViewTopInset : fullViewTopInset
            UIView.animate(withDuration: frameTransitionAnimationTime) {
                self.view.frame = CGRect(x: 0, y: yPosition, width: frame.width, height: frame.height)
            }
            
        default:
            break
        }
        
        recognizer.setTranslation(.zero, in: view)
    }
    
    @objc private func shapeDidPan(recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: view)
        let translation = recognizer.translation(in: view)
        
        switch recognizer.state {
        case .began:
            stickyCornersBehavior.isEnabled = false
            
        case .changed:
            shape.center.x = shape.center.x + translation.x
            shape.center.y = shape.center.y + translation.y
            recognizer.setTranslation(.zero, in: view)
            animator.updateItem(usingCurrentState: shape)
            
        case .ended:
            stickyCornersBehavior.isEnabled = true
            stickyCornersBehavior.addLinearVelocity(velocity)
            print(stickyCornersBehavior.currentCorner)
            
        default:
            break
        }
    }
    
}

// MARK: - Private

private extension BottomSheetViewController {
    
    private func setup() {
        setupHeader()
        setupShape()
        setupAnimator()
    }
        
    private func setupHeader() {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(sheetDidPan))
        view.addGestureRecognizer(gesture)
    }
    
    private func setupShape() {
        view.addSubview(shape)
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(shapeDidPan))
        shape.addGestureRecognizer(gesture)
    }
    
    private func setupAnimator() {
        animator.addBehavior(stickyCornersBehavior)
    }
    
}
