//
//  SimulatorView.swift
//  Quad Tree Simulator
//
//  Created by Ryan Crist on 12/2/18.
//  Copyright © 2018 Ryan Crist. All rights reserved.
//

import UIKit

class SimulatorView: UIView {
    
    let quadTreeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        addSubview(quadTreeView)
        addSubview(resetButton)
        
        NSLayoutConstraint.activate([
            quadTreeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            quadTreeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            quadTreeView.widthAnchor.constraint(equalTo: widthAnchor),
            quadTreeView.heightAnchor.constraint(equalTo: quadTreeView.widthAnchor),
            resetButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: quadTreeView.bottomAnchor, constant: 16)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
