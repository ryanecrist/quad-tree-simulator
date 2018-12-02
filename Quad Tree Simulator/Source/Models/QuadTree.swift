//
//  QuadTree.swift
//  Quad Tree Simulator
//
//  Created by Ryan Crist on 11/30/18.
//  Copyright © 2018 Ryan Crist. All rights reserved.
//

import Foundation

struct QuadTreePoint: Equatable, Hashable {
    let x: Double
    let y: Double
}

struct QuadTreeBounds {
    let min: QuadTreePoint
    let max: QuadTreePoint
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

enum QuadTreeNodeType {
    case leaf(_ points: Set<QuadTreePoint>)
    case `internal`(_ topLeftChild: QuadTreeNode,
                    _ topRightChild: QuadTreeNode,
                    _ bottomLeftChild: QuadTreeNode,
                    _ bottomRightChild: QuadTreeNode)
}

class QuadTreeNode {
    
    private(set) var type = QuadTreeNodeType.leaf([])
    let bounds: QuadTreeBounds
    var points: Set<QuadTreePoint>? {
        guard case .leaf(let points) = type else { return nil }
        return points
    }
    
    init(bounds: QuadTreeBounds) {
        self.bounds = bounds
    }
    
    func add(_ point: QuadTreePoint) {
        
        switch type {
        case var .leaf(points):
            
            points.insert(point)
            type = .leaf(points)
            
            if points.count > 1 { // todo
                
                let min = bounds.min
                let max = bounds.max
                let midpoint = bounds.midpoint
                
                let topLeftChild = QuadTreeNode(bounds: QuadTreeBounds(minX: min.x,
                                                                       minY: midpoint.y,
                                                                       maxX: midpoint.x,
                                                                       maxY: max.y))
                let topRightChild = QuadTreeNode(bounds: QuadTreeBounds(minX: midpoint.x,
                                                                        minY: midpoint.y,
                                                                        maxX: max.x,
                                                                        maxY: max.y))
                let bottomLeftChild = QuadTreeNode(bounds: QuadTreeBounds(minX: min.x,
                                                                          minY: min.y,
                                                                          maxX: midpoint.x,
                                                                          maxY: midpoint.y))
                let bottomRightChild = QuadTreeNode(bounds: QuadTreeBounds(minX: midpoint.x,
                                                                           minY: min.y,
                                                                           maxX: max.x,
                                                                           maxY: midpoint.y))
                
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
            
            var childPoints = Set<QuadTreePoint>()
            
            [topLeftChild, topRightChild, bottomLeftChild, bottomRightChild].forEach {
                if case let .leaf(points) = $0.type {
                    childPoints = childPoints.union(points)
                }
            }
            
            if childPoints.count <= 1 {
                type = .leaf(childPoints)
            }
        }
    }
    
    func removeAll() {
        
        if case let .internal(topLeftChild, topRightChild, bottomLeftChild, bottomRightChild) = type {
            [topLeftChild, topRightChild, bottomLeftChild, bottomRightChild].forEach {
                $0.removeAll()
            }
        }
        
        type = .leaf([])
    }
}

