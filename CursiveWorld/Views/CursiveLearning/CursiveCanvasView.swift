//
//  CursiveCanvasView.swift
//  CursiveWorld
//
//  Created by Benjamin Belloeil on 03/12/25.
//

import SwiftUI
import PencilKit

/// Thick stroke width for learning mode - easier for beginners
let learningStrokeWidth: CGFloat = 15

/// A SwiftUI wrapper for PKCanvasView that enables drawing with Apple Pencil or finger
/// Includes boundary checking and thick strokes for learning
struct CursiveCanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var toolPicker: PKToolPicker
    var onDrawingChanged: ((PKDrawing) -> Void)?
    var strokeColor: UIColor = .systemBlue
    var strokeWidth: CGFloat = learningStrokeWidth
    var showToolPicker: Bool = false
    
    func makeUIView(context: Context) -> PKCanvasView {
        // Set thick pen tool for learning
        canvasView.tool = PKInkingTool(.pen, color: strokeColor, width: strokeWidth)
        canvasView.drawingPolicy = .anyInput // Allows both Apple Pencil and finger drawing
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.delegate = context.coordinator
        
        // Only show tool picker if requested
        if showToolPicker {
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
        }
        canvasView.becomeFirstResponder()
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Update tool if color or width changed
        uiView.tool = PKInkingTool(.pen, color: strokeColor, width: strokeWidth)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CursiveCanvasView
        
        init(_ parent: CursiveCanvasView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.onDrawingChanged?(canvasView.drawing)
        }
    }
}

/// A container view that manages the PencilKit canvas state with boundary checking
struct CursiveDrawingCanvas: View {
    @Binding var canvasView: PKCanvasView
    @Binding var toolPicker: PKToolPicker
    let letter: String
    let onOutOfBounds: () -> Void
    
    @StateObject private var boundaryChecker = BoundaryChecker()
    @State private var canvasSize: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            CursiveCanvasView(
                canvasView: $canvasView,
                toolPicker: $toolPicker,
                onDrawingChanged: { drawing in
                    checkBoundary(drawing: drawing, in: geometry.size)
                },
                strokeColor: .systemBlue,
                strokeWidth: learningStrokeWidth,
                showToolPicker: false
            )
            .background(Color.clear)
            .onAppear {
                canvasSize = geometry.size
                boundaryChecker.setup(for: letter, in: geometry.size)
            }
            .onChange(of: letter) { _, newLetter in
                boundaryChecker.setup(for: newLetter, in: geometry.size)
            }
        }
        .outOfBoundsFlash(boundaryChecker.isOutOfBounds)
    }
    
    private func checkBoundary(drawing: PKDrawing, in size: CGSize) {
        if boundaryChecker.checkDrawing(drawing, for: letter, in: size) {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
            
            // Notify parent to handle restart
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onOutOfBounds()
            }
        }
    }
}

#Preview {
    CursiveDrawingCanvas(
        canvasView: .constant(PKCanvasView()),
        toolPicker: .constant(PKToolPicker()),
        letter: "A",
        onOutOfBounds: {}
    )
}
