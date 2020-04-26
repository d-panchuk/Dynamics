//
//  ViewController.swift
//  BubblesMenu
//
//  Created by Dima Panchuk on 30.01.2020.
//  Copyright © 2020 dpanchuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Storyboarded {

    @IBOutlet private weak var menuView: BubblesMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.centerItem = makeBubble(imageName: "facebook")
        menuView.surroundingItems = ["instagram", "twitch", "youtube", "reddit", "pinterest", "linkedin", "twitter"].map(makeBubble)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addBottomSheetVC()
    }    
    
}

// MARK: - Private
private extension ViewController {
    
    private func makeBubble(imageName: String) -> BubbleView {
        let bubble = BubbleView()
        bubble.title = imageName
        bubble.icon = UIImage(named: imageName)!
        return bubble
    }
    
    private func addBottomSheetVC() {
        let bottomSheetVC = BottomSheetViewController.instantiate()
        
        bottomSheetVC.view.frame = CGRect(
            x: 0,
            y: view.bounds.height,
            width: view.bounds.width,
            height: view.bounds.height - bottomSheetVC.fullViewTopInset
        )
        
        addChild(bottomSheetVC)
        view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
    }
    
}
