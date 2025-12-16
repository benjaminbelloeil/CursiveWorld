//
//  LetterStrokeData.swift
//  CursiveWorld
//
//  Created by Benjamin Belloeil on 03/12/25.
//

import SwiftUI

/// Represents a single point in a stroke with its position
struct StrokePoint: Identifiable {
    let id = UUID()
    let position: CGPoint
    let isStartPoint: Bool
    
    init(_ x: CGFloat, _ y: CGFloat, isStart: Bool = false) {
        self.position = CGPoint(x: x, y: y)
        self.isStartPoint = isStart
    }
}

/// Represents a complete stroke with multiple points and direction
struct LetterStroke: Identifiable {
    let id = UUID()
    let points: [StrokePoint]
    let strokeNumber: Int 
    
    /// Returns pairs of consecutive points for drawing arrows
    var arrowSegments: [(from: CGPoint, to: CGPoint)] {
        var segments: [(CGPoint, CGPoint)] = []
        for i in 0..<(points.count - 1) {
            segments.append((points[i].position, points[i + 1].position))
        }
        return segments
    }
}

/// Contains stroke data for all CURSIVE letters
/// Coordinates are normalized (0-1) - will be scaled to canvas size
/// Letters are designed based on D'Nealian and Zaner-Bloser cursive styles
struct LetterStrokeData {
    /// Stroke thickness for the letter template (thicker for learning)
    static let strokeWidth: CGFloat = 40
    
    /// Tolerance zone around the letter path where drawing is allowed
    static let toleranceZone: CGFloat = 80
    
    // MARK: - Lowercase Cursive Letters
    
    /// Returns the strokes for a given CURSIVE letter (normalized 0-1 coordinates)
    static func strokes(for letter: String) -> [LetterStroke] {
        switch letter {
            
        // ═══════════════════════════════════════════════════════════════
        // LOWERCASE CURSIVE LETTERS (a-z)
        // These start from the baseline and use proper cursive forms
        // ═══════════════════════════════════════════════════════════════
            
        case "a":
            // Lowercase cursive 'a': oval starting from top, down around, up and exit
            return [
                LetterStroke(points: [
                    StrokePoint(0.55, 0.4, isStart: true),  // Start at top right of oval
                    StrokePoint(0.45, 0.38),
                    StrokePoint(0.35, 0.42),
                    StrokePoint(0.30, 0.52),
                    StrokePoint(0.32, 0.62),
                    StrokePoint(0.40, 0.70),
                    StrokePoint(0.52, 0.70),
                    StrokePoint(0.60, 0.62),
                    StrokePoint(0.60, 0.50),                // Back to top
                    StrokePoint(0.62, 0.62),
                    StrokePoint(0.68, 0.72)                 // Exit stroke
                ], strokeNumber: 1)
            ]
            
        case "b":
            // Lowercase cursive 'b': tall loop up, down, bump out
            return [
                LetterStroke(points: [
                    StrokePoint(0.30, 0.70, isStart: true), // Start at baseline
                    StrokePoint(0.32, 0.55),
                    StrokePoint(0.35, 0.35),
                    StrokePoint(0.38, 0.22),                // Top of loop
                    StrokePoint(0.35, 0.20),
                    StrokePoint(0.30, 0.25),
                    StrokePoint(0.32, 0.40),
                    StrokePoint(0.35, 0.55),
                    StrokePoint(0.38, 0.68),                // Base of bump
                    StrokePoint(0.48, 0.72),
                    StrokePoint(0.58, 0.65),
                    StrokePoint(0.58, 0.55),
                    StrokePoint(0.52, 0.50),
                    StrokePoint(0.42, 0.52),
                    StrokePoint(0.55, 0.70),                // Exit
                    StrokePoint(0.65, 0.72)
                ], strokeNumber: 1)
            ]
            
        case "c":
            // Lowercase cursive 'c': simple open curve
            return [
                LetterStroke(points: [
                    StrokePoint(0.60, 0.42, isStart: true),
                    StrokePoint(0.50, 0.38),
                    StrokePoint(0.38, 0.42),
                    StrokePoint(0.32, 0.52),
                    StrokePoint(0.32, 0.62),
                    StrokePoint(0.40, 0.70),
                    StrokePoint(0.52, 0.72),
                    StrokePoint(0.65, 0.68)
                ], strokeNumber: 1)
            ]
            
        case "d":
            // Lowercase cursive 'd': oval then tall upstroke loop
            return [
                LetterStroke(points: [
                    StrokePoint(0.55, 0.45, isStart: true),
                    StrokePoint(0.45, 0.40),
                    StrokePoint(0.35, 0.45),
                    StrokePoint(0.30, 0.55),
                    StrokePoint(0.35, 0.65),
                    StrokePoint(0.48, 0.70),
                    StrokePoint(0.58, 0.62),
                    StrokePoint(0.58, 0.45),
                    StrokePoint(0.55, 0.28),
                    StrokePoint(0.58, 0.22),
                    StrokePoint(0.62, 0.25),
                    StrokePoint(0.60, 0.40),
                    StrokePoint(0.62, 0.60),
                    StrokePoint(0.70, 0.72)
                ], strokeNumber: 1)
            ]
            
        case "e":
            // Lowercase cursive 'e': loop in the middle
            return [
                LetterStroke(points: [
                    StrokePoint(0.32, 0.55, isStart: true),
                    StrokePoint(0.42, 0.50),
                    StrokePoint(0.55, 0.48),
                    StrokePoint(0.58, 0.42),
                    StrokePoint(0.52, 0.38),
                    StrokePoint(0.40, 0.40),
                    StrokePoint(0.32, 0.50),
                    StrokePoint(0.32, 0.62),
                    StrokePoint(0.42, 0.70),
                    StrokePoint(0.55, 0.70),
                    StrokePoint(0.68, 0.65)
                ], strokeNumber: 1)
            ]
            
        case "f":
            // Lowercase cursive 'f': tall loop down, descender loop
            return [
                LetterStroke(points: [
                    StrokePoint(0.55, 0.22, isStart: true),
                    StrokePoint(0.48, 0.20),
                    StrokePoint(0.40, 0.25),
                    StrokePoint(0.38, 0.40),
                    StrokePoint(0.40, 0.55),
                    StrokePoint(0.42, 0.70),
                    StrokePoint(0.40, 0.82),
                    StrokePoint(0.35, 0.85),
                    StrokePoint(0.30, 0.80)
                ], strokeNumber: 1),
                LetterStroke(points: [
                    StrokePoint(0.30, 0.50, isStart: true),
                    StrokePoint(0.42, 0.48),
                    StrokePoint(0.55, 0.50)
                ], strokeNumber: 2)
            ]
            
        case "g":
            // Lowercase cursive 'g': oval with descending loop
            return [
                LetterStroke(points: [
                    StrokePoint(0.58, 0.42, isStart: true),
                    StrokePoint(0.48, 0.38),
                    StrokePoint(0.38, 0.42),
                    StrokePoint(0.32, 0.52),
                    StrokePoint(0.35, 0.62),
                    StrokePoint(0.48, 0.68),
                    StrokePoint(0.58, 0.60),
                    StrokePoint(0.58, 0.70),
                    StrokePoint(0.55, 0.80),
                    StrokePoint(0.45, 0.85),
                    StrokePoint(0.35, 0.82),
                    StrokePoint(0.32, 0.75)
                ], strokeNumber: 1)
            ]
            
        case "h":
            // Lowercase cursive 'h': tall loop then hump
            return [
                LetterStroke(points: [
                    StrokePoint(0.28, 0.70, isStart: true),
                    StrokePoint(0.30, 0.50),
                    StrokePoint(0.33, 0.32),
                    StrokePoint(0.35, 0.22),
                    StrokePoint(0.32, 0.20),
                    StrokePoint(0.28, 0.25),
                    StrokePoint(0.30, 0.45),
                    StrokePoint(0.33, 0.60),
                    StrokePoint(0.38, 0.70),
                    StrokePoint(0.48, 0.55),
                    StrokePoint(0.58, 0.48),
                    StrokePoint(0.62, 0.55),
                    StrokePoint(0.65, 0.68),
                    StrokePoint(0.72, 0.72)
                ], strokeNumber: 1)
            ]
            
        case "i":
            // Lowercase cursive 'i': simple upstroke with dot
            return [
                LetterStroke(points: [
                    StrokePoint(0.38, 0.45, isStart: true),
                    StrokePoint(0.42, 0.55),
                    StrokePoint(0.48, 0.65),
                    StrokePoint(0.55, 0.72),
                    StrokePoint(0.65, 0.72)
                ], strokeNumber: 1),
                LetterStroke(points: [
                    StrokePoint(0.48, 0.32, isStart: true),
                    StrokePoint(0.50, 0.34)
                ], strokeNumber: 2)
            ]
            
        case "j":
            // Lowercase cursive 'j': descending curve with dot
            return [
                LetterStroke(points: [
                    StrokePoint(0.42, 0.45, isStart: true),
                    StrokePoint(0.48, 0.58),
                    StrokePoint(0.50, 0.70),
                    StrokePoint(0.48, 0.80),
                    StrokePoint(0.40, 0.85),
                    StrokePoint(0.32, 0.82)
                ], strokeNumber: 1),
                LetterStroke(points: [
                    StrokePoint(0.50, 0.32, isStart: true),
                    StrokePoint(0.52, 0.34)
                ], strokeNumber: 2)
            ]
            
        case "k":
            // Lowercase cursive 'k': tall loop with arm and leg
            return [
                LetterStroke(points: [
                    StrokePoint(0.28, 0.70, isStart: true),
                    StrokePoint(0.30, 0.50),
                    StrokePoint(0.33, 0.32),
                    StrokePoint(0.35, 0.22),
                    StrokePoint(0.32, 0.20),
                    StrokePoint(0.28, 0.25),
                    StrokePoint(0.30, 0.45),
                    StrokePoint(0.33, 0.60),
                    StrokePoint(0.38, 0.70)
                ], strokeNumber: 1),
                LetterStroke(points: [
                    StrokePoint(0.58, 0.42, isStart: true),
                    StrokePoint(0.48, 0.52),
                    StrokePoint(0.38, 0.58),
                    StrokePoint(0.50, 0.65),
                    StrokePoint(0.62, 0.72),
                    StrokePoint(0.70, 0.72)
                ], strokeNumber: 2)
            ]
            
        case "l":
            // Lowercase cursive 'l': tall loop
            return [
                LetterStroke(points: [
                    StrokePoint(0.35, 0.70, isStart: true),
                    StrokePoint(0.38, 0.50),
                    StrokePoint(0.42, 0.32),
                    StrokePoint(0.45, 0.22),
                    StrokePoint(0.42, 0.20),
                    StrokePoint(0.38, 0.25),
                    StrokePoint(0.40, 0.45),
                    StrokePoint(0.45, 0.62),
                    StrokePoint(0.52, 0.72),
                    StrokePoint(0.62, 0.72)
                ], strokeNumber: 1)
            ]
            
        case "m":
            // Lowercase cursive 'm': entry stroke, two humps
            return [
                LetterStroke(points: [
                    StrokePoint(0.18, 0.70, isStart: true),
                    StrokePoint(0.22, 0.55),
                    StrokePoint(0.28, 0.45),
                    StrokePoint(0.35, 0.52),
                    StrokePoint(0.38, 0.65),
                    StrokePoint(0.42, 0.52),
                    StrokePoint(0.50, 0.45),
                    StrokePoint(0.55, 0.52),
                    StrokePoint(0.58, 0.65),
                    StrokePoint(0.62, 0.52),
                    StrokePoint(0.68, 0.45),
                    StrokePoint(0.72, 0.55),
                    StrokePoint(0.75, 0.68),
                    StrokePoint(0.80, 0.72)
                ], strokeNumber: 1)
            ]
            
        case "n":
            // Lowercase cursive 'n': entry stroke, one hump
            return [
                LetterStroke(points: [
                    StrokePoint(0.28, 0.70, isStart: true),
                    StrokePoint(0.32, 0.55),
                    StrokePoint(0.38, 0.45),
                    StrokePoint(0.45, 0.50),
                    StrokePoint(0.52, 0.45),
                    StrokePoint(0.58, 0.52),
                    StrokePoint(0.62, 0.65),
                    StrokePoint(0.70, 0.72)
                ], strokeNumber: 1)
            ]
            
        case "o":
            // Lowercase cursive 'o': oval with connector
            return [
                LetterStroke(points: [
                    StrokePoint(0.52, 0.42, isStart: true),
                    StrokePoint(0.42, 0.40),
                    StrokePoint(0.32, 0.48),
                    StrokePoint(0.30, 0.58),
                    StrokePoint(0.35, 0.68),
                    StrokePoint(0.48, 0.72),
                    StrokePoint(0.58, 0.65),
                    StrokePoint(0.58, 0.52),
                    StrokePoint(0.55, 0.45),
                    StrokePoint(0.60, 0.58),
                    StrokePoint(0.68, 0.72)
                ], strokeNumber: 1)
            ]
            
        case "p":
            // Lowercase cursive 'p': descending stem with bump
            return [
                LetterStroke(points: [
                    StrokePoint(0.32, 0.45, isStart: true),
                    StrokePoint(0.35, 0.58),
                    StrokePoint(0.38, 0.72),
                    StrokePoint(0.38, 0.82),
                    StrokePoint(0.35, 0.85),
                    StrokePoint(0.30, 0.82)
                ], strokeNumber: 1),
                LetterStroke(points: [
                    StrokePoint(0.35, 0.52, isStart: true),
                    StrokePoint(0.45, 0.45),
                    StrokePoint(0.55, 0.48),
                    StrokePoint(0.60, 0.55),
                    StrokePoint(0.55, 0.65),
                    StrokePoint(0.45, 0.68),
                    StrokePoint(0.38, 0.62)
                ], strokeNumber: 2)
            ]
            
        case "q":
            // Lowercase cursive 'q': oval with descending tail
            return [
                LetterStroke(points: [
                    StrokePoint(0.55, 0.45, isStart: true),
                    StrokePoint(0.45, 0.42),
                    StrokePoint(0.35, 0.48),
                    StrokePoint(0.32, 0.58),
                    StrokePoint(0.38, 0.68),
                    StrokePoint(0.50, 0.70),
                    StrokePoint(0.58, 0.62),
                    StrokePoint(0.58, 0.75),
                    StrokePoint(0.55, 0.85),
                    StrokePoint(0.60, 0.82),
                    StrokePoint(0.68, 0.78)
                ], strokeNumber: 1)
            ]
            
        case "r":
            // Lowercase cursive 'r': uptroke with small shoulder
            return [
                LetterStroke(points: [
                    StrokePoint(0.32, 0.70, isStart: true),
                    StrokePoint(0.38, 0.55),
                    StrokePoint(0.42, 0.45),
                    StrokePoint(0.50, 0.48),
                    StrokePoint(0.58, 0.45),
                    StrokePoint(0.62, 0.50)
                ], strokeNumber: 1)
            ]
            
        case "s":
            // Lowercase cursive 's': flowing curve
            return [
                LetterStroke(points: [
                    StrokePoint(0.32, 0.55, isStart: true),
                    StrokePoint(0.40, 0.45),
                    StrokePoint(0.52, 0.42),
                    StrokePoint(0.58, 0.48),
                    StrokePoint(0.52, 0.55),
                    StrokePoint(0.42, 0.62),
                    StrokePoint(0.48, 0.70),
                    StrokePoint(0.58, 0.72),
                    StrokePoint(0.68, 0.68)
                ], strokeNumber: 1)
            ]
            
        case "t":
            // Lowercase cursive 't': tall stroke with cross
            return [
                LetterStroke(points: [
                    StrokePoint(0.38, 0.25, isStart: true),
                    StrokePoint(0.42, 0.42),
                    StrokePoint(0.48, 0.58),
                    StrokePoint(0.55, 0.70),
                    StrokePoint(0.65, 0.72)
                ], strokeNumber: 1),
                LetterStroke(points: [
                    StrokePoint(0.30, 0.42, isStart: true),
                    StrokePoint(0.45, 0.40),
                    StrokePoint(0.58, 0.42)
                ], strokeNumber: 2)
            ]
            
        case "u":
            // Lowercase cursive 'u': dip and upstroke
            return [
                LetterStroke(points: [
                    StrokePoint(0.30, 0.45, isStart: true),
                    StrokePoint(0.35, 0.58),
                    StrokePoint(0.42, 0.68),
                    StrokePoint(0.52, 0.70),
                    StrokePoint(0.60, 0.62),
                    StrokePoint(0.60, 0.50),
                    StrokePoint(0.62, 0.62),
                    StrokePoint(0.70, 0.72)
                ], strokeNumber: 1)
            ]
            
        case "v":
            // Lowercase cursive 'v': pointed dip
            return [
                LetterStroke(points: [
                    StrokePoint(0.28, 0.45, isStart: true),
                    StrokePoint(0.38, 0.58),
                    StrokePoint(0.48, 0.70),
                    StrokePoint(0.58, 0.58),
                    StrokePoint(0.68, 0.45)
                ], strokeNumber: 1)
            ]
            
        case "w":
            // Lowercase cursive 'w': double pointed dip
            return [
                LetterStroke(points: [
                    StrokePoint(0.18, 0.45, isStart: true),
                    StrokePoint(0.28, 0.60),
                    StrokePoint(0.35, 0.70),
                    StrokePoint(0.42, 0.58),
                    StrokePoint(0.50, 0.70),
                    StrokePoint(0.58, 0.58),
                    StrokePoint(0.65, 0.70),
                    StrokePoint(0.72, 0.58),
                    StrokePoint(0.80, 0.48)
                ], strokeNumber: 1)
            ]
            
        case "x":
            // Lowercase cursive 'x': crossing strokes
            return [
                LetterStroke(points: [
                    StrokePoint(0.30, 0.45, isStart: true),
                    StrokePoint(0.42, 0.55),
                    StrokePoint(0.55, 0.68),
                    StrokePoint(0.68, 0.72)
                ], strokeNumber: 1),
                LetterStroke(points: [
                    StrokePoint(0.65, 0.45, isStart: true),
                    StrokePoint(0.52, 0.55),
                    StrokePoint(0.38, 0.68),
                    StrokePoint(0.28, 0.72)
                ], strokeNumber: 2)
            ]
            
        case "y":
            // Lowercase cursive 'y': dip with descender
            return [
                LetterStroke(points: [
                    StrokePoint(0.28, 0.45, isStart: true),
                    StrokePoint(0.38, 0.58),
                    StrokePoint(0.48, 0.68),
                    StrokePoint(0.58, 0.55),
                    StrokePoint(0.62, 0.45),
                    StrokePoint(0.60, 0.62),
                    StrokePoint(0.55, 0.78),
                    StrokePoint(0.45, 0.85),
                    StrokePoint(0.35, 0.82)
                ], strokeNumber: 1)
            ]
            
        case "z":
            // Lowercase cursive 'z': horizontal zig-zag
            return [
                LetterStroke(points: [
                    StrokePoint(0.30, 0.45, isStart: true),
                    StrokePoint(0.45, 0.45),
                    StrokePoint(0.62, 0.45),
                    StrokePoint(0.45, 0.58),
                    StrokePoint(0.30, 0.72),
                    StrokePoint(0.48, 0.72),
                    StrokePoint(0.68, 0.72)
                ], strokeNumber: 1)
            ]
            
        // ═══════════════════════════════════════════════════════════════
        // UPPERCASE CURSIVE LETTERS (A-Z)
        // These have decorative entry strokes and proper cursive forms
        // ═══════════════════════════════════════════════════════════════
            
        case "A":
            // Uppercase cursive 'A': decorative loop, up stroke, down stroke
            return [
                LetterStroke(points: [
                    StrokePoint(0.18, 0.72, isStart: true),
                    StrokePoint(0.25, 0.55),
                    StrokePoint(0.38, 0.32),
                    StrokePoint(0.50, 0.20),
                    StrokePoint(0.62, 0.35),
                    StrokePoint(0.72, 0.55),
                    StrokePoint(0.80, 0.72)
                ], strokeNumber: 1),
                LetterStroke(points: [
                    StrokePoint(0.30, 0.52, isStart: true),
                    StrokePoint(0.50, 0.48),
                    StrokePoint(0.70, 0.52)
                ], strokeNumber: 2)
            ]
            
        case "B":
            // Uppercase cursive 'B': tall stem with two bumps
            return [
                LetterStroke(points: [
                    StrokePoint(0.22, 0.72, isStart: true),
                    StrokePoint(0.28, 0.50),
                    StrokePoint(0.32, 0.30),
                    StrokePoint(0.35, 0.20),
                    StrokePoint(0.52, 0.22),
                    StrokePoint(0.62, 0.30),
                    StrokePoint(0.58, 0.42),
                    StrokePoint(0.42, 0.48),
                    StrokePoint(0.35, 0.50),
                    StrokePoint(0.55, 0.55),
                    StrokePoint(0.68, 0.65),
                    StrokePoint(0.62, 0.75),
                    StrokePoint(0.45, 0.78),
                    StrokePoint(0.32, 0.72)
                ], strokeNumber: 1)
            ]
            
        case "C":
            // Uppercase cursive 'C': open curve with entry flourish
            return [
                LetterStroke(points: [
                    StrokePoint(0.68, 0.28, isStart: true),
                    StrokePoint(0.55, 0.20),
                    StrokePoint(0.40, 0.22),
                    StrokePoint(0.28, 0.35),
                    StrokePoint(0.25, 0.50),
                    StrokePoint(0.28, 0.65),
                    StrokePoint(0.42, 0.75),
                    StrokePoint(0.58, 0.72),
                    StrokePoint(0.72, 0.65)
                ], strokeNumber: 1)
            ]
            
        case "D":
            // Uppercase cursive 'D': tall loop with curved body
            return [
                LetterStroke(points: [
                    StrokePoint(0.22, 0.72, isStart: true),
                    StrokePoint(0.28, 0.50),
                    StrokePoint(0.32, 0.28),
                    StrokePoint(0.38, 0.20),
                    StrokePoint(0.55, 0.22),
                    StrokePoint(0.68, 0.35),
                    StrokePoint(0.72, 0.52),
                    StrokePoint(0.68, 0.68),
                    StrokePoint(0.52, 0.78),
                    StrokePoint(0.35, 0.72)
                ], strokeNumber: 1)
            ]
            
        case "E":
            // Uppercase cursive 'E': decorative loop with horizontal strokes
            return [
                LetterStroke(points: [
                    StrokePoint(0.58, 0.25, isStart: true),
                    StrokePoint(0.42, 0.20),
                    StrokePoint(0.30, 0.28),
                    StrokePoint(0.28, 0.42),
                    StrokePoint(0.38, 0.48),
                    StrokePoint(0.55, 0.50),
                    StrokePoint(0.38, 0.52),
                    StrokePoint(0.28, 0.62),
                    StrokePoint(0.32, 0.75),
                    StrokePoint(0.48, 0.78),
                    StrokePoint(0.68, 0.72)
                ], strokeNumber: 1)
            ]
            
        case "F":
            // Uppercase cursive 'F': tall decorative stem with cross
            return [
                LetterStroke(points: [
                    StrokePoint(0.58, 0.25, isStart: true),
                    StrokePoint(0.45, 0.20),
                    StrokePoint(0.32, 0.28),
                    StrokePoint(0.30, 0.42),
                    StrokePoint(0.35, 0.58),
                    StrokePoint(0.40, 0.72),
                    StrokePoint(0.48, 0.78)
                ], strokeNumber: 1),
                LetterStroke(points: [
                    StrokePoint(0.25, 0.50, isStart: true),
                    StrokePoint(0.42, 0.48),
                    StrokePoint(0.58, 0.50)
                ], strokeNumber: 2)
            ]
            
        case "G":
            // Uppercase cursive 'G': open curve with inner bar
            return [
                LetterStroke(points: [
                    StrokePoint(0.70, 0.28, isStart: true),
                    StrokePoint(0.55, 0.20),
                    StrokePoint(0.38, 0.22),
                    StrokePoint(0.25, 0.38),
                    StrokePoint(0.25, 0.55),
                    StrokePoint(0.32, 0.70),
                    StrokePoint(0.50, 0.78),
                    StrokePoint(0.65, 0.72),
                    StrokePoint(0.68, 0.58),
                    StrokePoint(0.62, 0.50),
                    StrokePoint(0.48, 0.52)
                ], strokeNumber: 1)
            ]
            
        case "H":
            // Uppercase cursive 'H': two tall stems with connector
            return [
                LetterStroke(points: [
                    StrokePoint(0.18, 0.72, isStart: true),
                    StrokePoint(0.22, 0.50),
                    StrokePoint(0.28, 0.28),
                    StrokePoint(0.32, 0.20),
                    StrokePoint(0.35, 0.35),
                    StrokePoint(0.38, 0.50),
                    StrokePoint(0.55, 0.48),
                    StrokePoint(0.68, 0.50),
                    StrokePoint(0.70, 0.32),
                    StrokePoint(0.72, 0.20),
                    StrokePoint(0.75, 0.40),
                    StrokePoint(0.78, 0.60),
                    StrokePoint(0.82, 0.72)
                ], strokeNumber: 1)
            ]
            
        case "I":
            // Uppercase cursive 'I': decorative top and bottom
            return [
                LetterStroke(points: [
                    StrokePoint(0.35, 0.22, isStart: true),
                    StrokePoint(0.45, 0.20),
                    StrokePoint(0.55, 0.22),
                    StrokePoint(0.50, 0.38),
                    StrokePoint(0.52, 0.55),
                    StrokePoint(0.55, 0.72),
                    StrokePoint(0.62, 0.78)
                ], strokeNumber: 1)
            ]
            
        case "J":
            // Uppercase cursive 'J': decorative top with curved bottom
            return [
                LetterStroke(points: [
                    StrokePoint(0.35, 0.22, isStart: true),
                    StrokePoint(0.48, 0.20),
                    StrokePoint(0.62, 0.22),
                    StrokePoint(0.58, 0.40),
                    StrokePoint(0.55, 0.58),
                    StrokePoint(0.50, 0.72),
                    StrokePoint(0.40, 0.78),
                    StrokePoint(0.30, 0.75),
                    StrokePoint(0.28, 0.65)
                ], strokeNumber: 1)
            ]
            
        case "K":
            // Uppercase cursive 'K': tall stem with arm and leg
            return [
                LetterStroke(points: [
                    StrokePoint(0.22, 0.72, isStart: true),
                    StrokePoint(0.28, 0.50),
                    StrokePoint(0.32, 0.28),
                    StrokePoint(0.35, 0.20)
                ], strokeNumber: 1),
                LetterStroke(points: [
                    StrokePoint(0.68, 0.22, isStart: true),
                    StrokePoint(0.55, 0.38),
                    StrokePoint(0.40, 0.50),
                    StrokePoint(0.55, 0.62),
                    StrokePoint(0.72, 0.75)
                ], strokeNumber: 2)
            ]
            
        case "L":
            // Uppercase cursive 'L': tall loop with base flourish
            return [
                LetterStroke(points: [
                    StrokePoint(0.32, 0.22, isStart: true),
                    StrokePoint(0.35, 0.40),
                    StrokePoint(0.38, 0.58),
                    StrokePoint(0.42, 0.72),
                    StrokePoint(0.52, 0.78),
                    StrokePoint(0.65, 0.75),
                    StrokePoint(0.75, 0.72)
                ], strokeNumber: 1)
            ]
            
        case "M":
            // Uppercase cursive 'M': decorative entry, two peaks
            return [
                LetterStroke(points: [
                    StrokePoint(0.12, 0.72, isStart: true),
                    StrokePoint(0.18, 0.50),
                    StrokePoint(0.22, 0.28),
                    StrokePoint(0.25, 0.20),
                    StrokePoint(0.35, 0.45),
                    StrokePoint(0.45, 0.65),
                    StrokePoint(0.55, 0.45),
                    StrokePoint(0.65, 0.25),
                    StrokePoint(0.72, 0.45),
                    StrokePoint(0.78, 0.65),
                    StrokePoint(0.85, 0.75)
                ], strokeNumber: 1)
            ]
            
        case "N":
            // Uppercase cursive 'N': decorative entry, diagonal, exit
            return [
                LetterStroke(points: [
                    StrokePoint(0.18, 0.72, isStart: true),
                    StrokePoint(0.22, 0.50),
                    StrokePoint(0.28, 0.28),
                    StrokePoint(0.32, 0.20),
                    StrokePoint(0.50, 0.50),
                    StrokePoint(0.65, 0.72),
                    StrokePoint(0.70, 0.50),
                    StrokePoint(0.72, 0.28),
                    StrokePoint(0.75, 0.20),
                    StrokePoint(0.78, 0.40),
                    StrokePoint(0.82, 0.72)
                ], strokeNumber: 1)
            ]
            
        case "O":
            // Uppercase cursive 'O': oval with entry and exit
            return [
                LetterStroke(points: [
                    StrokePoint(0.50, 0.22, isStart: true),
                    StrokePoint(0.35, 0.28),
                    StrokePoint(0.25, 0.42),
                    StrokePoint(0.25, 0.58),
                    StrokePoint(0.32, 0.72),
                    StrokePoint(0.48, 0.78),
                    StrokePoint(0.62, 0.72),
                    StrokePoint(0.72, 0.55),
                    StrokePoint(0.70, 0.38),
                    StrokePoint(0.58, 0.25),
                    StrokePoint(0.50, 0.22)
                ], strokeNumber: 1)
            ]
            
        case "P":
            // Uppercase cursive 'P': tall stem with loop
            return [
                LetterStroke(points: [
                    StrokePoint(0.22, 0.72, isStart: true),
                    StrokePoint(0.28, 0.50),
                    StrokePoint(0.32, 0.28),
                    StrokePoint(0.38, 0.20),
                    StrokePoint(0.55, 0.22),
                    StrokePoint(0.65, 0.32),
                    StrokePoint(0.62, 0.45),
                    StrokePoint(0.48, 0.52),
                    StrokePoint(0.35, 0.50)
                ], strokeNumber: 1)
            ]
            
        case "Q":
            // Uppercase cursive 'Q': oval with decorative tail
            return [
                LetterStroke(points: [
                    StrokePoint(0.50, 0.22, isStart: true),
                    StrokePoint(0.35, 0.28),
                    StrokePoint(0.25, 0.42),
                    StrokePoint(0.25, 0.58),
                    StrokePoint(0.32, 0.72),
                    StrokePoint(0.48, 0.78),
                    StrokePoint(0.62, 0.72),
                    StrokePoint(0.72, 0.55),
                    StrokePoint(0.70, 0.38),
                    StrokePoint(0.58, 0.25),
                    StrokePoint(0.50, 0.22)
                ], strokeNumber: 1),
                LetterStroke(points: [
                    StrokePoint(0.55, 0.62, isStart: true),
                    StrokePoint(0.65, 0.72),
                    StrokePoint(0.78, 0.82)
                ], strokeNumber: 2)
            ]
            
        case "R":
            // Uppercase cursive 'R': tall stem with loop and leg
            return [
                LetterStroke(points: [
                    StrokePoint(0.22, 0.72, isStart: true),
                    StrokePoint(0.28, 0.50),
                    StrokePoint(0.32, 0.28),
                    StrokePoint(0.38, 0.20),
                    StrokePoint(0.55, 0.22),
                    StrokePoint(0.65, 0.32),
                    StrokePoint(0.60, 0.45),
                    StrokePoint(0.45, 0.52),
                    StrokePoint(0.35, 0.50),
                    StrokePoint(0.52, 0.62),
                    StrokePoint(0.72, 0.78)
                ], strokeNumber: 1)
            ]
            
        case "S":
            // Uppercase cursive 'S': flowing double curve
            return [
                LetterStroke(points: [
                    StrokePoint(0.65, 0.28, isStart: true),
                    StrokePoint(0.52, 0.20),
                    StrokePoint(0.38, 0.25),
                    StrokePoint(0.30, 0.38),
                    StrokePoint(0.38, 0.50),
                    StrokePoint(0.55, 0.55),
                    StrokePoint(0.68, 0.65),
                    StrokePoint(0.65, 0.78),
                    StrokePoint(0.48, 0.82),
                    StrokePoint(0.32, 0.75)
                ], strokeNumber: 1)
            ]
            
        case "T":
            // Uppercase cursive 'T': horizontal with stem
            return [
                LetterStroke(points: [
                    StrokePoint(0.25, 0.25, isStart: true),
                    StrokePoint(0.42, 0.22),
                    StrokePoint(0.58, 0.22),
                    StrokePoint(0.75, 0.25)
                ], strokeNumber: 1),
                LetterStroke(points: [
                    StrokePoint(0.50, 0.22, isStart: true),
                    StrokePoint(0.52, 0.42),
                    StrokePoint(0.55, 0.60),
                    StrokePoint(0.60, 0.75)
                ], strokeNumber: 2)
            ]
            
        case "U":
            // Uppercase cursive 'U': curved bottom
            return [
                LetterStroke(points: [
                    StrokePoint(0.22, 0.22, isStart: true),
                    StrokePoint(0.28, 0.42),
                    StrokePoint(0.32, 0.58),
                    StrokePoint(0.40, 0.72),
                    StrokePoint(0.55, 0.78),
                    StrokePoint(0.68, 0.70),
                    StrokePoint(0.72, 0.52),
                    StrokePoint(0.75, 0.32),
                    StrokePoint(0.78, 0.22)
                ], strokeNumber: 1)
            ]
            
        case "V":
            // Uppercase cursive 'V': pointed bottom
            return [
                LetterStroke(points: [
                    StrokePoint(0.22, 0.22, isStart: true),
                    StrokePoint(0.35, 0.45),
                    StrokePoint(0.48, 0.68),
                    StrokePoint(0.52, 0.75),
                    StrokePoint(0.62, 0.55),
                    StrokePoint(0.72, 0.35),
                    StrokePoint(0.80, 0.22)
                ], strokeNumber: 1)
            ]
            
        case "W":
            // Uppercase cursive 'W': double pointed
            return [
                LetterStroke(points: [
                    StrokePoint(0.10, 0.22, isStart: true),
                    StrokePoint(0.20, 0.48),
                    StrokePoint(0.28, 0.70),
                    StrokePoint(0.38, 0.48),
                    StrokePoint(0.48, 0.28),
                    StrokePoint(0.55, 0.50),
                    StrokePoint(0.62, 0.70),
                    StrokePoint(0.72, 0.45),
                    StrokePoint(0.82, 0.25),
                    StrokePoint(0.88, 0.48),
                    StrokePoint(0.92, 0.70)
                ], strokeNumber: 1)
            ]
            
        case "X":
            // Uppercase cursive 'X': crossing strokes
            return [
                LetterStroke(points: [
                    StrokePoint(0.25, 0.22, isStart: true),
                    StrokePoint(0.40, 0.42),
                    StrokePoint(0.52, 0.55),
                    StrokePoint(0.68, 0.72),
                    StrokePoint(0.78, 0.78)
                ], strokeNumber: 1),
                LetterStroke(points: [
                    StrokePoint(0.78, 0.22, isStart: true),
                    StrokePoint(0.62, 0.42),
                    StrokePoint(0.52, 0.55),
                    StrokePoint(0.38, 0.70),
                    StrokePoint(0.25, 0.78)
                ], strokeNumber: 2)
            ]
            
        case "Y":
            // Uppercase cursive 'Y': two arms meeting in descender
            return [
                LetterStroke(points: [
                    StrokePoint(0.22, 0.22, isStart: true),
                    StrokePoint(0.35, 0.38),
                    StrokePoint(0.48, 0.52),
                    StrokePoint(0.52, 0.65),
                    StrokePoint(0.55, 0.78)
                ], strokeNumber: 1),
                LetterStroke(points: [
                    StrokePoint(0.78, 0.22, isStart: true),
                    StrokePoint(0.62, 0.38),
                    StrokePoint(0.52, 0.52)
                ], strokeNumber: 2)
            ]
            
        case "Z":
            // Uppercase cursive 'Z': horizontal zig-zag
            return [
                LetterStroke(points: [
                    StrokePoint(0.28, 0.25, isStart: true),
                    StrokePoint(0.48, 0.22),
                    StrokePoint(0.72, 0.25),
                    StrokePoint(0.55, 0.48),
                    StrokePoint(0.35, 0.72),
                    StrokePoint(0.52, 0.78),
                    StrokePoint(0.72, 0.75),
                    StrokePoint(0.80, 0.72)
                ], strokeNumber: 1)
            ]
            
        default:
            // Fallback for any undefined character
            return [
                LetterStroke(points: [
                    StrokePoint(0.30, 0.70, isStart: true),
                    StrokePoint(0.50, 0.50),
                    StrokePoint(0.70, 0.70)
                ], strokeNumber: 1)
            ]
        }
    }
    
    // MARK: - Path Generation
    
    /// Creates a smooth curved path from strokes scaled to a given size
    static func path(for letter: String, in size: CGSize) -> Path {
        let strokes = strokes(for: letter)
        var path = Path()
        
        for stroke in strokes {
            guard stroke.points.count >= 2 else { continue }
            
            let scaledPoints = stroke.points.map { point in
                CGPoint(
                    x: point.position.x * size.width,
                    y: point.position.y * size.height
                )
            }
            
            // Use smooth curve through points
            path.move(to: scaledPoints[0])
            
            if scaledPoints.count == 2 {
                path.addLine(to: scaledPoints[1])
            } else {
                // Create smooth curve using quadratic bezier
                for i in 1..<scaledPoints.count {
                    let current = scaledPoints[i]
                    let previous = scaledPoints[i - 1]
                    let midPoint = CGPoint(
                        x: (previous.x + current.x) / 2,
                        y: (previous.y + current.y) / 2
                    )
                    
                    if i == 1 {
                        path.addLine(to: midPoint)
                    } else {
                        path.addQuadCurve(to: midPoint, control: previous)
                    }
                    
                    if i == scaledPoints.count - 1 {
                        path.addLine(to: current)
                    }
                }
            }
        }
        
        return path
    }
}
