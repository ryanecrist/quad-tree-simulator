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
    
    var lineViews = [UIView]()
    
    var quadTree: QuadTreeNode!
    
    var points: [QuadTreePoint] = []
    var pointViews: [QuadTreePoint:PointView] = [:] {
        didSet {
            simulatorView.instructionsLabel.isHidden = !pointViews.isEmpty
        }
    }
    
    override func loadView() {
        view = simulatorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(tapGestureRecognized))
        simulatorView.quadTreeView.addGestureRecognizer(tapGestureRecognizer)
        
        simulatorView.removeButton.addTarget(self, action: #selector(removeLastPoint), for: .touchUpInside)
        simulatorView.clearButton.addTarget(self, action: #selector(clearQuadTree), for: .touchUpInside)
        
        simulatorView.nodeCapacityStepper.addTarget(self, action: #selector(nodeCapacityStepperChanged), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard quadTree == nil, simulatorView.quadTreeView.frame != .zero else { return }
        
        let width = Double(simulatorView.quadTreeView.frame.width)
        
        quadTree = QuadTreeNode(bounds: QuadTreeBounds(minX: 0, minY: 0, maxX: width, maxY: width),
                                capacity: 1)
    }
    
    @objc
    func nodeCapacityStepperChanged(_ sender: UIStepper) {
        
        simulatorView.nodeCapacityLabel.text = "Node Capacity: \(Int(sender.value))"
        
        let width = Double(simulatorView.quadTreeView.frame.width)
        
        quadTree = QuadTreeNode(bounds: QuadTreeBounds(minX: 0, minY: 0, maxX: width, maxY: width),
                                capacity: Int(sender.value))
        
        
        simulatorView.quadTreeView.subviews.forEach {
            $0.removeFromSuperview()
        }
        lineViews.removeAll()
        
    }
    
    @objc
    func removeLastPoint(_ sender: UIButton) {
        
        guard !points.isEmpty else { return }
        
        let point = points.removeLast()
        
        quadTree.remove(point)
        
        pointViews[point]?.removeFromSuperview()
        pointViews[point] = nil
        
        drawQuadTree()
    }
    
    @objc
    func clearQuadTree(_ sender: UIButton) {
        
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
    
        
        let qPoint = QuadTreePoint(x: Double(point.x), y: Double(point.y))
        pointViews[qPoint] = pointView
        
        points.append(qPoint)
        quadTree.add(qPoint)
     
        drawQuadTree()
    }
    
    func drawQuadTree() {
        
        lineViews.forEach {
            $0.removeFromSuperview()
        }
        lineViews.removeAll()
        
        drawQuadTree(quadTree)
    }
    
    func drawQuadTree(_ quadTree: QuadTreeNode) {
        
        if case let .internal(topLeftChild, topRightChild, bottomLeftChild, bottomRightChild) = quadTree.type {
            
            let min = quadTree.bounds.min
            let max = quadTree.bounds.max
            let midpoint = quadTree.bounds.midpoint
            
            let horizontalLineView = UIView(frame: CGRect(x: min.x, y: midpoint.y, width: (max.x - min.x), height: 1))
            horizontalLineView.backgroundColor = view.tintColor
            
            let verticalLineView = UIView(frame: CGRect(x: midpoint.x, y: min.y, width: 1, height: (max.y - min.y)))
            verticalLineView.backgroundColor = view.tintColor
            
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

