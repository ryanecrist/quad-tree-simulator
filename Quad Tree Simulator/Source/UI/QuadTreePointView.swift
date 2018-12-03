//
//  QuadTreePointView.swift
//  Quad Tree Simulator
//
//  Created by Ryan Crist on 11/30/18.
//  Copyright © 2018 Ryan Crist. All rights reserved.
//

import UIKit

class QuadTreePointView: UIView {
    
    convenience init(x: CGFloat, y: CGFloat) {
        self.init(frame: CGRect(x: x - 4, y: y - 4, width: 8, height: 8))
        
        layer.borderColor = tintColor.cgColor
        layer.borderWidth = 1
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.width / 2
    }
}
