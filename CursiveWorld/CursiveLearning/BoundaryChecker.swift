//
//  BoundaryChecker.swift
//  CursiveWorld
//
//  Created by Benjamin Belloeil on 03/12/25.
//

import SwiftUI
import PencilKit
import Combine

/// Checks if drawing points stay within the allowed letter boundaries
class BoundaryChecker: ObservableObject {
    @Published var isOutOfBounds = false
    @Published var outOfBoundsPoint: CGPoint?
    
    private var letterPath: Path?
    private var expandedPath: Path?
    private var canvasSize: CGSize = .zero
    private var currentLetter: String = "a"
    
    // Much more generous tolerance - 80pt allows natural handwriting variance
    private let tolerance: CGFloat = 80
    
    // Minimum strokes before checking boundaries (allow initial pen placement)
    private var strokeCount: Int = 0
    private let minStrokesBeforeChecking: Int = 1
    
    /// Sets up the boundary checker for a specific letter
    func setup(for letter: String, in size: CGSize) {
        self.canvasSize = size
        self.currentLetter = letter
        self.letterPath = LetterStrokeData.path(for: letter, in: size)
        self.isOutOfBounds = false
        self.outOfBoundsPoint = nil
        self.strokeCount = 0
    }
    
    /// Checks if a point is within the allowed drawing zone
    func isPointWithinBounds(_ point: CGPoint) -> Bool {
        guard canvasSize != .zero else { return true }
        
        // Get the strokes for distance checking
        let strokes = LetterStrokeData.strokes(for: currentLetter)
        guard !strokes.isEmpty else { return true }
        
        // Check distance to nearest stroke point or line segment
        var minDistance: CGFloat = .infinity
        
        for stroke in strokes {
            // Check distance to each checkpoint directly
            for strokePoint in stroke.points {
                let p = CGPoint(
                    x: strokePoint.position.x * canvasSize.width,
                    y: strokePoint.position.y * canvasSize.height
                )
                let distance = hypot(point.x - p.x, point.y - p.y)
                minDistance = min(minDistance, distance)
            }
            
            // Also check line segments between points
            for i in 0..<(stroke.points.count - 1) {
                let p1 = CGPoint(
                    x: stroke.points[i].position.x * canvasSize.width,
                    y: stroke.points[i].position.y * canvasSize.height
                )
                let p2 = CGPoint(
                    x: stroke.points[i + 1].position.x * canvasSize.width,
                    y: stroke.points[i + 1].position.y * canvasSize.height
                )
                
                let distance = distanceFromPointToLineSegment(point: point, lineStart: p1, lineEnd: p2)
                minDistance = min(minDistance, distance)
            }
        }
        
        return minDistance <= tolerance
    }
    
    /// Checks all points in a PKDrawing and returns true if any point is out of bounds
    func checkDrawing(_ drawing: PKDrawing, for letter: String, in size: CGSize) -> Bool {
        if currentLetter != letter || canvasSize != size {
            setup(for: letter, in: size)
        }
        
        strokeCount = drawing.strokes.count
        
        // Don't check boundaries until user has made some strokes
        guard strokeCount >= minStrokesBeforeChecking else {
            return false
        }
        
        // Only check the last few points of the most recent stroke for performance
        // and to avoid false positives from initial pen placement
        guard let lastStroke = drawing.strokes.last else { return false }
        
        let path = lastStroke.path
        let pointsToCheck = min(10, path.count)
        let startIndex = max(0, path.count - pointsToCheck)
        
        for i in startIndex..<path.count {
            let point = path[i]
            if !isPointWithinBounds(point.location) {
                isOutOfBounds = true
                outOfBoundsPoint = point.location
                return true
            }
        }
        
        isOutOfBounds = false
        outOfBoundsPoint = nil
        return false
    }
    
    /// Checks the last stroke point added
    func checkLastPoint(in drawing: PKDrawing, for letter: String, in size: CGSize) -> Bool {
        guard let lastStroke = drawing.strokes.last else { return false }
        
        if currentLetter != letter || canvasSize != size {
            setup(for: letter, in: size)
        }
        
        let path = lastStroke.path
        guard let lastPoint = path.last else { return false }
        
        if !isPointWithinBounds(lastPoint.location) {
            isOutOfBounds = true
            outOfBoundsPoint = lastPoint.location
            return true
        }
        
        return false
    }
    
    /// Calculates the distance from a point to a line segment
    private func distanceFromPointToLineSegment(point: CGPoint, lineStart: CGPoint, lineEnd: CGPoint) -> CGFloat {
        let dx = lineEnd.x - lineStart.x
        let dy = lineEnd.y - lineStart.y
        
        if dx == 0 && dy == 0 {
            // Line segment is a point
            return hypot(point.x - lineStart.x, point.y - lineStart.y)
        }
        
        // Calculate the t that minimizes the distance
        let t = max(0, min(1, ((point.x - lineStart.x) * dx + (point.y - lineStart.y) * dy) / (dx * dx + dy * dy)))
        
        // Calculate the closest point on the line segment
        let closestPoint = CGPoint(
            x: lineStart.x + t * dx,
            y: lineStart.y + t * dy
        )
        
        return hypot(point.x - closestPoint.x, point.y - closestPoint.y)
    }
    
    /// Resets the boundary checker state
    func reset() {
        isOutOfBounds = false
        outOfBoundsPoint = nil
    }
}

/// View modifier that shows a red flash when out of bounds
struct OutOfBoundsFlash: ViewModifier {
    let isOutOfBounds: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Color.red.opacity(isOutOfBounds ? 0.3 : 0)
                    .animation(.easeInOut(duration: 0.2), value: isOutOfBounds)
                    .allowsHitTesting(false)
            )
    }
}

extension View {
    func outOfBoundsFlash(_ isOutOfBounds: Bool) -> some View {
        modifier(OutOfBoundsFlash(isOutOfBounds: isOutOfBounds))
    }
}
