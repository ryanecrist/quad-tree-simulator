//
//  QuadTree.swift
//  Quad Tree Simulator
//
//  Created by Ryan Crist on 11/30/18.
//  Copyright © 2018 Ryan Crist. All rights reserved.
//

import Foundation

/// A point (x, y) in the quad tree.
struct QuadTreePoint: Equatable, Hashable {
    let x: Double
    let y: Double
}

/// The bounds of the quad tree (node).
struct QuadTreeBounds {
    
    /// The minimum point.
    let min: QuadTreePoint
    
    /// The maximum point.
    let max: QuadTreePoint
    
    /// The midpoint.
    var midpoint: QuadTreePoint {
        return QuadTreePoint(x: (min.x + max.x) / 2, y: (min.y + max.y) / 2)
    }
    
    init(minX: Double, minY: Double, maxX: Double, maxY: Double) {
        min = QuadTreePoint(x: minX, y: minY)
        max = QuadTreePoint(x: maxX, y: maxY)
    }
    
    init(min: QuadTreePoint, max: QuadTreePoint) {
        self.min = min
        self.max = max
    }
}

/// The type of a quad tree node.
///
/// - leaf: Leaf node with a set points <= to the node capacity.
/// - `internal`_: Internal node with four children.
enum QuadTreeNodeType {
    case leaf(_ points: Set<QuadTreePoint>)
    case `internal`(_ topLeftChild: QuadTreeNode,
                    _ topRightChild: QuadTreeNode,
                    _ bottomLeftChild: QuadTreeNode,
                    _ bottomRightChild: QuadTreeNode)
}

/// A quad tree (node).  Each point represented by the quad tree must be unique.
class QuadTreeNode {
    
    /// The type of the quad tree (node).
    private(set) var type = QuadTreeNodeType.leaf([])
    
    /// The bounds of the quad tree (node).
    let bounds: QuadTreeBounds
    
    /// The node capacity of the quad tree (node).
    let capacity: Int
    
    /// All points of the quad tree (node), determined by recursing over any children nodes.
    var points: Set<QuadTreePoint> {
        
        switch type {
        case let .leaf(points):
            
            return points
            
        case let .internal(topLeftChild, topRightChild, bottomLeftChild, bottomRightChild):
            
            var points = Set<QuadTreePoint>()
            
            [topLeftChild, topRightChild, bottomLeftChild, bottomRightChild].forEach {
                points = points.union($0.points)
            }
            
            return points
        }
    }
    
    init(bounds: QuadTreeBounds, capacity: Int) {
        self.bounds = bounds
        self.capacity = capacity
    }
    
    /// Adds a point to the quad tree (node).
    ///
    /// - Parameter point: The point to add.
    func add(_ point: QuadTreePoint) {
        
        switch type {
        case var .leaf(points):
            
            points.insert(point)
            type = .leaf(points)
            
            // Subdivide the quad tree node if the points count has exceeded the capacity.
            if points.count > capacity {
                
                let min = bounds.min
                let max = bounds.max
                let midpoint = bounds.midpoint
                
                let topLeftChild = QuadTreeNode(bounds: QuadTreeBounds(minX: min.x,
                                                                       minY: midpoint.y,
                                                                       maxX: midpoint.x,
                                                                       maxY: max.y),
                                                capacity: capacity)
                let topRightChild = QuadTreeNode(bounds: QuadTreeBounds(minX: midpoint.x,
                                                                        minY: midpoint.y,
                                                                        maxX: max.x,
                                                                        maxY: max.y),
                                                 capacity: capacity)
                let bottomLeftChild = QuadTreeNode(bounds: QuadTreeBounds(minX: min.x,
                                                                          minY: min.y,
                                                                          maxX: midpoint.x,
                                                                          maxY: midpoint.y),
                                                   capacity: capacity)
                let bottomRightChild = QuadTreeNode(bounds: QuadTreeBounds(minX: midpoint.x,
                                                                           minY: min.y,
                                                                           maxX: max.x,
                                                                           maxY: midpoint.y),
                                                    capacity: capacity)
                
                type = .internal(topLeftChild, topRightChild, bottomLeftChild, bottomRightChild)
                
                points.forEach {
                    add($0)
                }
            }
            
        case let .internal(topLeftChild, topRightChild, bottomLeftChild, bottomRightChild):
            
            let midpoint = bounds.midpoint
            
            if point.y > midpoint.y {
                if point.x > midpoint.x {
                    topRightChild.add(point)
                } else {
                    topLeftChild.add(point)
                }
            } else {
                if point.x > midpoint.x {
                    bottomRightChild.add(point)
                } else {
                    bottomLeftChild.add(point)
                }
            }
        }
    }
    
    /// Removes a point from the quad tree (node).
    ///
    /// - Parameter point: The point to remove.
    func remove(_ point: QuadTreePoint) {
        
        switch type {
        case var .leaf(points):
            
            points.remove(point)
            type = .leaf(points)
            
        case let .internal(topLeftChild, topRightChild, bottomLeftChild, bottomRightChild):
            
            let midpoint = bounds.midpoint
            
            if point.y > midpoint.y {
                if point.x > midpoint.x {
                    topRightChild.remove(point)
                } else {
                    topLeftChild.remove(point)
                }
            } else {
                if point.x > midpoint.x {
                    bottomRightChild.remove(point)
                } else {
                    bottomLeftChild.remove(point)
                }
            }
            
            // Merge the quad tree children nodes into a single leaf node if the total number of
            // points of the children is less than or equal to the capacity.
            if points.count <= capacity {
                type = .leaf(points)
            }
        }
    }
    
    /// Removes all points from the quad tree.
    func removeAll() {
        
        if case let .internal(topLeftChild, topRightChild, bottomLeftChild, bottomRightChild) = type {
            [topLeftChild, topRightChild, bottomLeftChild, bottomRightChild].forEach {
                $0.removeAll()
            }
        }
        
        type = .leaf([])
    }
}

