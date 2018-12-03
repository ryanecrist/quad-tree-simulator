//
//  QuadTreeViewController.swift
//  Quad Tree Simulator
//
//  Created by Ryan Crist on 11/30/18.
//  Copyright © 2018 Ryan Crist. All rights reserved.
//

import UIKit

class QuadTreeViewController: UIViewController {
    
    /// The quad tree view.
    lazy var quadTreeView = QuadTreeView()

    /// The quad tree.
    var quadTree: QuadTreeNode!
    
    /// List of historical points in the quad tree (so they can be removed in the order they were
    /// added).
    var historicalPoints: [QuadTreePoint] = [] {
        didSet {
            quadTreeView.instructionsLabel.isHidden = !historicalPoints.isEmpty
        }
    }
    
    override func loadView() {
        view = quadTreeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup visualizer controls.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(addPoint))
        quadTreeView.boxView.addGestureRecognizer(tapGestureRecognizer)
        quadTreeView.nodeCapacityStepper.addTarget(self,
                                                    action: #selector(changeNodeCapacity),
                                                    for: .valueChanged)
        quadTreeView.removeButton.addTarget(self,
                                             action: #selector(removeLastPoint),
                                             for: .touchUpInside)
        quadTreeView.clearButton.addTarget(self,
                                            action: #selector(clear),
                                            for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard quadTree == nil, quadTreeView.boxView.frame != .zero else { return }
        
        // Lazily create the quad tree when the view has finishing layout out.
        let max = Double(quadTreeView.boxView.frame.width)
        quadTree = QuadTreeNode(bounds: QuadTreeBounds(minX: 0, minY: 0, maxX: max, maxY: max),
                                capacity: 1)
    }
    
    /// Changes the node capacity of the quad tree (1 - 10).
    ///
    /// - Parameter sender: The stepper control with the new capacity.
    @objc
    func changeNodeCapacity(_ sender: UIStepper) {
        
        quadTreeView.nodeCapacityLabel.text = "Node Capacity: \(Int(sender.value))"
        
        // Re-create the quad tree with the new capacity.
        let max = Double(quadTreeView.boxView.frame.width)
        quadTree = QuadTreeNode(bounds: QuadTreeBounds(minX: 0, minY: 0, maxX: max, maxY: max),
                                capacity: Int(sender.value))
        
        
        redrawQuadTree()
    }
    
    /// Removes the last point from the quad tree.
    ///
    /// - Parameter sender: The "Remove Last Point" button.
    @objc
    func removeLastPoint(_ sender: UIButton) {
        
        guard !historicalPoints.isEmpty else { return }
        
        let point = historicalPoints.removeLast()
        
        quadTree.remove(point)
        redrawQuadTree()
    }
    
    /// Clears the quad tree.
    ///
    /// - Parameter sender: The "Clear" button.
    @objc
    func clear(_ sender: UIButton) {
        historicalPoints.removeAll()
        quadTree.removeAll()
        redrawQuadTree()
    }
    
    /// Adds a point to the quad tree.
    ///
    /// - Parameter sender: The tap gesture recognizer with the new point location.
    @objc
    func addPoint(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: quadTreeView.boxView)
        let point = QuadTreePoint(x: Double(location.x), y: Double(location.y))
        
        historicalPoints.append(point)
        quadTree.add(point)
        redrawQuadTree()
    }
    
    /// Redraws the quad tree.  This could be made more efficient by only (re)drawing sections of
    /// the quad tree at a time, but is sufficient enough for demonstrational purposes.
    func redrawQuadTree() {
        
        quadTreeView.boxView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        drawQuadTree(quadTree)
    }
    
    /// Draws a quad tree node points to the screen (in the case of a leaf node) or recursively
    /// draws its children (in the case of an internal node).
    ///
    /// - Parameter quadTree: The quad tree node to draw.
    func drawQuadTree(_ quadTree: QuadTreeNode) {
        
        switch quadTree.type {
        case let .leaf(points):
            
            points.forEach {
                let pointView = QuadTreePointView(x: CGFloat($0.x), y: CGFloat($0.y))
                quadTreeView.boxView.addSubview(pointView)
            }
            
        case let .internal(topLeftChild, topRightChild, bottomLeftChild, bottomRightChild):
            
            let min = quadTree.bounds.min
            let max = quadTree.bounds.max
            let midpoint = quadTree.bounds.midpoint
            
            let horizontalLineView = UIView(frame: CGRect(x: min.x,
                                                          y: midpoint.y,
                                                          width: (max.x - min.x),
                                                          height: 1))
            horizontalLineView.backgroundColor = view.tintColor
            
            let verticalLineView = UIView(frame: CGRect(x: midpoint.x,
                                                        y: min.y,
                                                        width: 1,
                                                        height: (max.y - min.y)))
            verticalLineView.backgroundColor = view.tintColor
            
            quadTreeView.boxView.addSubview(horizontalLineView)
            quadTreeView.boxView.addSubview(verticalLineView)
            
            [topLeftChild, topRightChild, bottomLeftChild, bottomRightChild].forEach {
                drawQuadTree($0)
            }
        }
    }
}

