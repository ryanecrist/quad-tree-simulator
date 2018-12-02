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
    
    let nodeCapacityStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.tintColor = .black
        return stepper
    }()
    
    let nodeCapacityLabel: UILabel = {
        let label = UILabel()
        label.text = "Node Capacity: 1"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray

        let nodeCapacityStackView = UIStackView(arrangedSubviews: [nodeCapacityLabel, nodeCapacityStepper])
        nodeCapacityStackView.isLayoutMarginsRelativeArrangement = true
        nodeCapacityStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        nodeCapacityStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(quadTreeView)
        addSubview(resetButton)
        addSubview(nodeCapacityStackView)
        
        NSLayoutConstraint.activate([
            
            quadTreeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            quadTreeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            quadTreeView.widthAnchor.constraint(equalTo: widthAnchor),
            quadTreeView.heightAnchor.constraint(equalTo: quadTreeView.widthAnchor),
            
            resetButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: quadTreeView.bottomAnchor, constant: 16),
            
            nodeCapacityStackView.leftAnchor.constraint(equalTo: leftAnchor),
            nodeCapacityStackView.rightAnchor.constraint(equalTo: rightAnchor),
            nodeCapacityStackView.bottomAnchor.constraint(equalTo: quadTreeView.topAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
