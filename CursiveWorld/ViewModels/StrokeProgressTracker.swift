//
//  StrokeProgressTracker.swift
//  CursiveWorld
//
//  Created by Benjamin Belloeil on 03/12/25.
//

import SwiftUI
import PencilKit
import Combine

/// Tracks user progress through each stroke of a letter
class StrokeProgressTracker: ObservableObject {
    @Published var currentStrokeIndex: Int = 0
    @Published var completedStrokes: Set<Int> = []
    @Published var isLetterComplete: Bool = false
    @Published var currentSegmentIndex: Int = 0
    @Published var strokeProgress: CGFloat = 0 // 0 to 1 for current stroke
    
    private var letter: String = ""
    private var canvasSize: CGSize = .zero
    private var strokes: [LetterStroke] = []
    private var checkpointsTouched: Set<Int> = []
    private var hasCompletedCurrentLetter: Bool = false // Prevents re-triggering completion
    
    /// The distance threshold to consider a checkpoint as "touched"
    private let checkpointRadius: CGFloat = 50
    
    /// Minimum points required before checking completion
    private let minimumDrawingPoints: Int = 10
    
    /// Sets up tracking for a specific letter
    func setup(for letter: String, in size: CGSize) {
        self.letter = letter
        self.canvasSize = size
        self.strokes = LetterStrokeData.strokes(for: letter)
        reset()
    }
    
    /// Resets all progress
    func reset() {
        currentStrokeIndex = 0
        completedStrokes = []
        isLetterComplete = false
        currentSegmentIndex = 0
        strokeProgress = 0
        checkpointsTouched = []
        hasCompletedCurrentLetter = false
    }
    
    /// Checks the drawing progress and updates state
    /// Returns true if the letter is now complete
    func checkProgress(drawing: PKDrawing) -> Bool {
        // Prevent re-triggering completion
        guard !hasCompletedCurrentLetter else { return false }
        guard !strokes.isEmpty, canvasSize != .zero else { return false }
        
        // Count total drawing points to ensure user actually drew something
        var totalPoints = 0
        for stroke in drawing.strokes {
            totalPoints += stroke.path.count
        }
        
        // Require minimum drawing before checking completion
        guard totalPoints >= minimumDrawingPoints else { return false }
        
        let currentStroke = strokes[currentStrokeIndex]
        let scaledCheckpoints = currentStroke.points.map { point in
            CGPoint(
                x: point.position.x * canvasSize.width,
                y: point.position.y * canvasSize.height
            )
        }
        
        // Check all strokes in the drawing
        for stroke in drawing.strokes {
            let path = stroke.path
            for point in path {
                checkPointAgainstCheckpoints(point.location, checkpoints: scaledCheckpoints)
            }
        }
        
        // Update stroke progress
        if !scaledCheckpoints.isEmpty {
            strokeProgress = CGFloat(checkpointsTouched.count) / CGFloat(scaledCheckpoints.count)
        }
        
        // Check if current stroke is complete (all checkpoints touched in order)
        if checkpointsTouched.count >= scaledCheckpoints.count {
            completeCurrentStroke()
        }
        
        return isLetterComplete
    }
    
    /// Checks if a drawn point is near any checkpoint
    private func checkPointAgainstCheckpoints(_ point: CGPoint, checkpoints: [CGPoint]) {
        // We need to touch checkpoints roughly in order
        // Allow some flexibility - can touch next checkpoint or current one
        
        let nextRequiredIndex = checkpointsTouched.count
        
        // Check if touching the next required checkpoint
        if nextRequiredIndex < checkpoints.count {
            let checkpoint = checkpoints[nextRequiredIndex]
            let distance = hypot(point.x - checkpoint.x, point.y - checkpoint.y)
            
            if distance <= checkpointRadius {
                checkpointsTouched.insert(nextRequiredIndex)
                currentSegmentIndex = nextRequiredIndex
                
                // Haptic feedback for progress
                let feedback = UIImpactFeedbackGenerator(style: .light)
                feedback.impactOccurred()
            }
        }
        
        // Also check if we're re-touching a previous checkpoint (allow some flexibility)
        for i in max(0, nextRequiredIndex - 2)..<min(checkpoints.count, nextRequiredIndex + 2) {
            if !checkpointsTouched.contains(i) {
                let checkpoint = checkpoints[i]
                let distance = hypot(point.x - checkpoint.x, point.y - checkpoint.y)
                
                if distance <= checkpointRadius {
                    // Only add if previous checkpoints are done
                    if i == 0 || checkpointsTouched.contains(i - 1) {
                        checkpointsTouched.insert(i)
                    }
                }
            }
        }
    }
    
    /// Marks current stroke as complete and moves to next
    private func completeCurrentStroke() {
        completedStrokes.insert(currentStrokeIndex)
        
        // Success haptic
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.success)
        
        if currentStrokeIndex < strokes.count - 1 {
            // Move to next stroke
            currentStrokeIndex += 1
            currentSegmentIndex = 0
            strokeProgress = 0
            checkpointsTouched = []
        } else {
            // Letter complete!
            isLetterComplete = true
            hasCompletedCurrentLetter = true // Prevent re-triggering
        }
    }
    
    /// Gets the start point of the current stroke (scaled to canvas size)
    func currentStrokeStartPoint() -> CGPoint? {
        guard currentStrokeIndex < strokes.count,
              let firstPoint = strokes[currentStrokeIndex].points.first else {
            return nil
        }
        
        return CGPoint(
            x: firstPoint.position.x * canvasSize.width,
            y: firstPoint.position.y * canvasSize.height
        )
    }
    
    /// Gets the next checkpoint to reach
    func nextCheckpoint() -> CGPoint? {
        guard currentStrokeIndex < strokes.count else { return nil }
        
        let stroke = strokes[currentStrokeIndex]
        let nextIndex = checkpointsTouched.count
        
        guard nextIndex < stroke.points.count else { return nil }
        
        let point = stroke.points[nextIndex]
        return CGPoint(
            x: point.position.x * canvasSize.width,
            y: point.position.y * canvasSize.height
        )
    }
    
    /// Returns the total number of strokes for current letter
    var totalStrokes: Int {
        strokes.count
    }
}
