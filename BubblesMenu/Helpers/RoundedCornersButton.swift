//
//  RoundedCornersButton.swift
//  BubblesMenu
//
//  Created by Dima Panchuk on 04.02.2020.
//  Copyright © 2020 dpanchuk. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornersButton: UIButton {
}

@IBDesignable
class RoundedCornersView: UIView {
}

extension UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
}
