//
//  BubbleView.swift
//  BubblesMenu
//
//  Created by Dima Panchuk on 30.01.2020.
//  Copyright © 2020 dpanchuk. All rights reserved.
//

import UIKit

class BubbleView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .ellipse
    }
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var icon: UIImage? {
        get { iconImageView.image }
        set { iconImageView.image = newValue }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
    }
    
    private func setup() {
        loadContentView()
        setupUI()
    }
    
    private func loadContentView() {
        Bundle(for: BubbleView.self).loadNibNamed("BubbleView", owner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
    
    private func setupUI() {
        backgroundColor = UIColor.yellow
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 3
    }
    
}
