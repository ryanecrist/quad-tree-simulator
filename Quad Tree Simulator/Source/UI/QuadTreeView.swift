//
//  QuadTreeView.swift
//  Quad Tree Simulator
//
//  Created by Ryan Crist on 12/2/18.
//  Copyright © 2018 Ryan Crist. All rights reserved.
//

import UIKit

class QuadTreeView: UIView {
    
    lazy var boxView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = tintColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let instructionsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Tap anywhere in the box to create a point."
        label.textAlignment = .center
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nodeCapacityLabel: UILabel = {
        let label = UILabel()
        label.text = "Node Capacity: 1"
        return label
    }()
    
    let nodeCapacityStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        return stepper
    }()
    
    let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove Last Point", for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.text = "Quad Tree Simulator"
        titleLabel.textAlignment = .center

        let nodeCapacityStackView = UIStackView(arrangedSubviews: [nodeCapacityLabel,
                                                                   nodeCapacityStepper])
        
        let controlsStackView = UIStackView(arrangedSubviews: [removeButton, clearButton])
        
        let contentStackView = UIStackView(arrangedSubviews: [titleLabel,
                                                              boxView,
                                                              nodeCapacityStackView,
                                                              controlsStackView])
        contentStackView.axis = .vertical
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentStackView)
        addSubview(instructionsLabel)
        
        NSLayoutConstraint.activate([
            
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leftAnchor.constraint(equalTo: leftAnchor),
            contentStackView.rightAnchor.constraint(equalTo: rightAnchor),
            
            boxView.heightAnchor.constraint(equalTo: boxView.widthAnchor),
            
            clearButton.widthAnchor.constraint(equalTo: removeButton.widthAnchor),
            
            instructionsLabel.leftAnchor.constraint(equalTo: boxView.leftAnchor,
                                                    constant: 16),
            instructionsLabel.rightAnchor.constraint(equalTo: boxView.rightAnchor,
                                                     constant: -16),
            instructionsLabel.centerYAnchor.constraint(equalTo: boxView.centerYAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
