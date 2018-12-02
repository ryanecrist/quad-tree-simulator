//
//  SimulatorViewController.swift
//  Quad Tree Simulator
//
//  Created by Ryan Crist on 11/30/18.
//  Copyright © 2018 Ryan Crist. All rights reserved.
//

import UIKit

class SimulatorViewController: UIViewController {
    
    lazy var simulatorView = SimulatorView()
    
    var quadTree: QuadTreeNode!
    
    override func loadView() {
        view = simulatorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(tapGestureRecognized))
        simulatorView.quadTreeView.addGestureRecognizer(tapGestureRecognizer)
        
        simulatorView.resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        simulatorView.nodeCapacityStepper.addTarget(self, action: #selector(nodeCapacityStepperChanged), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard quadTree == nil, view.frame != .zero else { return }
        
        let width = Double(view.frame.width)
        
        quadTree = QuadTreeNode(bounds: QuadTreeBounds(minX: 0, minY: 0, maxX: width, maxY: width),
                                capacity: 1)
    }
    
    @objc
    func nodeCapacityStepperChanged(_ sender: UIStepper) {
        simulatorView.nodeCapacityLabel.text = "Node Capacity: \(Int(sender.value))"
        let width = Double(view.frame.width)
        quadTree = QuadTreeNode(bounds: QuadTreeBounds(minX: 0, minY: 0, maxX: width, maxY: width),
                                capacity: Int(sender.value))
        simulatorView.quadTreeView.subviews.forEach {
            $0.removeFromSuperview()
        }
        lineViews.removeAll()
        
    }
    
    @objc
    func resetButtonTapped(_ sender: UIButton) {
        
        simulatorView.quadTreeView.subviews.forEach {
            $0.removeFromSuperview()
        }
        lineViews.removeAll()
        
        quadTree.removeAll()
    }
    
    @objc
    func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: simulatorView.quadTreeView)
        
        // TODO flip y axis
        let pointView = PointView(frame: CGRect(x: point.x - 5, y: point.y - 5, width: 10, height: 10))
        simulatorView.quadTreeView.addSubview(pointView)
        quadTree.add(QuadTreePoint(x: Double(point.x), y: Double(point.y)))
     
        lineViews.forEach {
            $0.removeFromSuperview()
        }
        lineViews.removeAll()
        
        drawQuadTree(quadTree)
    }
    
    var lineViews = [UIView]()
    
    func drawQuadTree(_ quadTree: QuadTreeNode) {
        if case let .internal(topLeftChild, topRightChild, bottomLeftChild, bottomRightChild) = quadTree.type {
            
            let min = quadTree.bounds.min
            let max = quadTree.bounds.max
            let midpoint = quadTree.bounds.midpoint
            
            let horizontalLineView = UIView(frame: CGRect(x: min.x, y: midpoint.y, width: (max.x - min.x), height: 1))
            horizontalLineView.backgroundColor = .blue
            
            let verticalLineView = UIView(frame: CGRect(x: midpoint.x, y: min.y, width: 1, height: (max.y - min.y)))
            verticalLineView.backgroundColor = .blue
            
            simulatorView.quadTreeView.addSubview(horizontalLineView)
            simulatorView.quadTreeView.addSubview(verticalLineView)
            
            lineViews.append(horizontalLineView)
            lineViews.append(verticalLineView)
            
            drawQuadTree(topLeftChild)
            drawQuadTree(topRightChild)
            drawQuadTree(bottomLeftChild)
            drawQuadTree(bottomRightChild)
        }
    }
}

