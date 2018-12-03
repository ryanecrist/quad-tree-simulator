//
//  SimulatorView.swift
//  Quad Tree Simulator
//
//  Created by Ryan Crist on 12/2/18.
//  Copyright © 2018 Ryan Crist. All rights reserved.
//

import UIKit

class SimulatorView: UIView {
    
    private(set) lazy var quadTreeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = tintColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove Last Point", for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear Quad Tree", for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let nodeCapacityStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        return stepper
    }()
    
    let nodeCapacityLabel: UILabel = {
        let label = UILabel()
        label.text = "Node Capacity: 1"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white

        let nodeCapacityStackView = UIStackView(arrangedSubviews: [nodeCapacityLabel, nodeCapacityStepper])
        
        let controlsStackView = UIStackView(arrangedSubviews: [removeButton, clearButton])
        
        let contentStackView = UIStackView(arrangedSubviews: [quadTreeView, nodeCapacityStackView, controlsStackView])
        contentStackView.axis = .vertical
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leftAnchor.constraint(equalTo: leftAnchor),
            contentStackView.rightAnchor.constraint(equalTo: rightAnchor),
            
            quadTreeView.heightAnchor.constraint(equalTo: quadTreeView.widthAnchor),
            
            clearButton.widthAnchor.constraint(equalTo: removeButton.widthAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
