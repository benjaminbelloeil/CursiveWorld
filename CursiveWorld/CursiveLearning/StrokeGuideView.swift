//
//  StrokeGuideView.swift
//  CursiveWorld
//
//  Created by Benjamin Belloeil on 03/12/25.
//

import SwiftUI

/// Displays the thick cursive letter template with directional arrows
struct StrokeGuideView: View {
    let letter: String
    let currentStrokeIndex: Int
    let showAllStrokes: Bool
    
    @State private var arrowAnimationProgress: CGFloat = 0
    
    init(letter: String, currentStrokeIndex: Int = 0, showAllStrokes: Bool = true) {
        self.letter = letter
        self.currentStrokeIndex = currentStrokeIndex
        self.showAllStrokes = showAllStrokes
    }
    
    var body: some View {
        GeometryReader { geometry in
            let strokes = LetterStrokeData.strokes(for: letter)
            
            ZStack {
                // Draw ALL strokes as light gray background (so user sees full letter)
                ForEach(Array(strokes.enumerated()), id: \.element.id) { index, stroke in
                    SmoothStrokePath(stroke: stroke, size: geometry.size)
                        .stroke(
                            Color.gray.opacity(0.15),
                            style: StrokeStyle(
                                lineWidth: LetterStrokeData.strokeWidth,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                }
                
                // Draw current stroke more prominently
                if currentStrokeIndex < strokes.count {
                    SmoothStrokePath(stroke: strokes[currentStrokeIndex], size: geometry.size)
                        .stroke(
                            Color.blue.opacity(0.25),
                            style: StrokeStyle(
                                lineWidth: LetterStrokeData.strokeWidth,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                }
                
                // Draw arrows for current stroke only
                if currentStrokeIndex < strokes.count {
                    StrokeArrowsView(
                        stroke: strokes[currentStrokeIndex],
                        size: geometry.size,
                        isActive: true,
                        strokeNumber: currentStrokeIndex + 1
                    )
                }
                
                // Start point indicator for current stroke
                if currentStrokeIndex < strokes.count,
                   let startPoint = strokes[currentStrokeIndex].points.first {
                    StartPointIndicator(
                        position: CGPoint(
                            x: startPoint.position.x * geometry.size.width,
                            y: startPoint.position.y * geometry.size.height
                        )
                    )
                }
            }
        }
    }
}

/// Draws a smooth curved path for a single stroke
struct SmoothStrokePath: Shape {
    let stroke: LetterStroke
    let size: CGSize
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard stroke.points.count >= 2 else { return path }
        
        let scaledPoints = stroke.points.map { point in
            CGPoint(
                x: point.position.x * size.width,
                y: point.position.y * size.height
            )
        }
        
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
        
        return path
    }
}

/// Draws the thick letter path (legacy - for full letter)
struct ThickLetterPath: Shape {
    let letter: String
    let size: CGSize
    
    func path(in rect: CGRect) -> Path {
        LetterStrokeData.path(for: letter, in: size)
    }
}

/// Displays animated arrows along a stroke path
struct StrokeArrowsView: View {
    let stroke: LetterStroke
    let size: CGSize
    let isActive: Bool
    let strokeNumber: Int
    
    @State private var animationPhase: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Stroke number indicator at start
            if let firstPoint = stroke.points.first {
                StrokeNumberBadge(
                    number: strokeNumber,
                    position: CGPoint(
                        x: firstPoint.position.x * size.width,
                        y: firstPoint.position.y * size.height
                    ),
                    isActive: isActive
                )
            }
            
            // Draw arrows along the path
            ForEach(Array(stroke.arrowSegments.enumerated()), id: \.offset) { index, segment in
                ArrowShape(
                    from: CGPoint(
                        x: segment.from.x * size.width,
                        y: segment.from.y * size.height
                    ),
                    to: CGPoint(
                        x: segment.to.x * size.width,
                        y: segment.to.y * size.height
                    )
                )
                .stroke(
                    isActive ? Color.blue : Color.gray.opacity(0.5),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .opacity(isActive ? pulsingOpacity(for: index) : 0.5)
            }
        }
        .onAppear {
            if isActive {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    animationPhase = 1
                }
            }
        }
    }
    
    private func pulsingOpacity(for index: Int) -> Double {
        let baseOpacity = 0.6
        let pulseAmount = 0.4
        let offset = Double(index) * 0.2
        return baseOpacity + pulseAmount * sin((animationPhase + offset) * .pi * 2)
    }
}

/// Arrow shape pointing from one point to another
struct ArrowShape: Shape {
    let from: CGPoint
    let to: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Calculate direction
        let dx = to.x - from.x
        let dy = to.y - from.y
        let length = sqrt(dx * dx + dy * dy)
        
        guard length > 0 else { return path }
        
        // Normalized direction
        let nx = dx / length
        let ny = dy / length
        
        // Arrow head size
        let arrowSize: CGFloat = 12
        
        // Calculate arrow head points
        let arrowPoint = to
        let arrowBase1 = CGPoint(
            x: to.x - arrowSize * nx - arrowSize * 0.5 * ny,
            y: to.y - arrowSize * ny + arrowSize * 0.5 * nx
        )
        let arrowBase2 = CGPoint(
            x: to.x - arrowSize * nx + arrowSize * 0.5 * ny,
            y: to.y - arrowSize * ny - arrowSize * 0.5 * nx
        )
        
        // Draw line
        path.move(to: from)
        path.addLine(to: CGPoint(x: to.x - arrowSize * 0.8 * nx, y: to.y - arrowSize * 0.8 * ny))
        
        // Draw arrow head
        path.move(to: arrowBase1)
        path.addLine(to: arrowPoint)
        path.addLine(to: arrowBase2)
        
        return path
    }
}

/// Indicates the starting point of a stroke
struct StartPointIndicator: View {
    let position: CGPoint
    
    @State private var isPulsing = false
    
    var body: some View {
        Circle()
            .fill(Color.green)
            .frame(width: 24, height: 24)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 3)
            )
            .overlay(
                Text("●")
                    .font(.caption2)
                    .foregroundColor(.white)
            )
            .scaleEffect(isPulsing ? 1.2 : 1.0)
            .position(position)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
    }
}

/// Badge showing the stroke number
struct StrokeNumberBadge: View {
    let number: Int
    let position: CGPoint
    let isActive: Bool
    
    var body: some View {
        Text("\(number)")
            .font(.caption.bold())
            .foregroundColor(.white)
            .frame(width: 20, height: 20)
            .background(isActive ? Color.blue : Color.gray)
            .clipShape(Circle())
            .position(x: position.x - 25, y: position.y - 25)
    }
}

#Preview {
    StrokeGuideView(letter: "A", currentStrokeIndex: 0)
        .frame(width: 300, height: 400)
        .background(Color.white)
}
