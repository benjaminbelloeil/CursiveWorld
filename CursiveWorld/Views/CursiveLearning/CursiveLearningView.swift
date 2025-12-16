//
//  CursiveLearningView.swift
//  CursiveWorld
//
//  Created by Benjamin Belloeil on 03/12/25.
//

import SwiftUI
import PencilKit

/// Main view for learning cursive writing with letter selection and drawing canvas
struct CursiveLearningView: View {
    @State private var selectedLetter: String = "a"
    @State private var canvasView = PKCanvasView()
    @State private var toolPicker = PKToolPicker()
    @State private var attempts: Int = 0
    @State private var completedLetters: Set<String> = []
    @State private var canvasSize: CGSize = .zero
    
    // Toast states
    @State private var showSuccessToast = false
    @State private var showErrorToast = false
    
    @StateObject private var progressTracker = StrokeProgressTracker()
    
    private let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ").map { String($0) }
    private let lowercaseLetters = Array("abcdefghijklmnopqrstuvwxyz").map { String($0) }
    
    @State private var isUppercase = false // Start with lowercase for learning
    
    var currentLetters: [String] {
        isUppercase ? letters : lowercaseLetters
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Letter case toggle
                    Picker("Case", selection: $isUppercase) {
                        Text("Lowercase").tag(false)
                        Text("Uppercase").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .onChange(of: isUppercase) { _, newValue in
                        // Reset to first letter when changing case
                        selectedLetter = newValue ? "A" : "a"
                        resetForNewLetter()
                    }
                    
                    // Letter selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(currentLetters, id: \.self) { letter in
                                LetterButton(
                                    letter: letter,
                                    isSelected: selectedLetter == letter,
                                    isCompleted: completedLetters.contains(letter)
                                ) {
                                    selectedLetter = letter
                                    resetForNewLetter()
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                    }
                    
                    // Progress indicator
                    HStack {
                        // Stroke progress
                        if progressTracker.totalStrokes > 0 {
                            HStack(spacing: 4) {
                                Text("Stroke \(progressTracker.currentStrokeIndex + 1)/\(progressTracker.totalStrokes)")
                                    .font(.caption.bold())
                                    .foregroundColor(.blue)
                                
                                // Progress bar for current stroke
                                ProgressView(value: progressTracker.strokeProgress)
                                    .frame(width: 60)
                                    .tint(.green)
                            }
                        }
                        
                        Spacer()
                        
                        Text("Attempts: \(attempts)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    
                    // Instructions
                    HStack {
                        Image(systemName: "hand.draw")
                            .foregroundColor(.green)
                        Text("Start at the green dot, follow the arrows!")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    
                    Divider()
                    
                    // Drawing area with template and arrows
                    GeometryReader { geometry in
                        ZStack {
                            // Guide lines for writing
                            WritingGuideLines()
                            
                            // Thick letter template with directional arrows
                            StrokeGuideView(
                                letter: selectedLetter,
                                currentStrokeIndex: progressTracker.currentStrokeIndex,
                                showAllStrokes: false // Only show current stroke
                            )
                            
                            // Checkpoint indicators
                            CheckpointOverlay(
                                letter: selectedLetter,
                                currentStrokeIndex: progressTracker.currentStrokeIndex,
                                completedCheckpoints: progressTracker.currentSegmentIndex,
                                size: geometry.size
                            )
                            
                            // Drawing canvas with progress tracking
                            ProgressTrackingCanvas(
                                canvasView: $canvasView,
                                letter: selectedLetter,
                                progressTracker: progressTracker,
                                onOutOfBounds: handleOutOfBounds,
                                onLetterComplete: handleLetterComplete
                            )
                        }
                        .background(Color(.systemBackground))
                        .onAppear {
                            canvasSize = geometry.size
                            progressTracker.setup(for: selectedLetter, in: geometry.size)
                        }
                        .onChange(of: geometry.size) { _, newSize in
                            canvasSize = newSize
                            progressTracker.setup(for: selectedLetter, in: newSize)
                        }
                    }
                    
                    // Bottom controls
                    HStack(spacing: 20) {
                        Button(action: resetForNewLetter) {
                            Label("Clear", systemImage: "arrow.counterclockwise")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray5))
                                .cornerRadius(10)
                        }
                        
                        Button(action: goToNextLetter) {
                            Label("Next", systemImage: "chevron.right")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(currentLetters.last == selectedLetter)
                    }
                    .padding()
                }
                
                // Toast notifications overlay
                VStack {
                    Spacer()
                    
                    // Success toast
                    if showSuccessToast {
                        SuccessToast(letter: selectedLetter)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.bottom, 100)
                    }
                    
                    // Error toast
                    if showErrorToast {
                        ErrorToast()
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.bottom, 100)
                    }
                }
                .animation(.spring(response: 0.3), value: showSuccessToast)
                .animation(.spring(response: 0.3), value: showErrorToast)
            }
            .navigationTitle("Learn Cursive")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: goToPreviousLetter) {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(currentLetters.first == selectedLetter)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: goToNextLetter) {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(currentLetters.last == selectedLetter)
                }
            }
        }
    }
    
    private func resetForNewLetter() {
        canvasView.drawing = PKDrawing()
        progressTracker.setup(for: selectedLetter, in: canvasSize)
    }
    
    private func handleOutOfBounds() {
        attempts += 1
        
        // Show error toast (auto-dismiss)
        showErrorToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showErrorToast = false
            resetForNewLetter()
        }
    }
    
    private func handleLetterComplete() {
        completedLetters.insert(selectedLetter)
        
        // Show success toast (auto-dismiss, does NOT auto-advance)
        showSuccessToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showSuccessToast = false
        }
    }
    
    private func goToNextLetter() {
        if let currentIndex = currentLetters.firstIndex(of: selectedLetter),
           currentIndex < currentLetters.count - 1 {
            selectedLetter = currentLetters[currentIndex + 1]
            resetForNewLetter()
        }
    }
    
    private func goToPreviousLetter() {
        if let currentIndex = currentLetters.firstIndex(of: selectedLetter),
           currentIndex > 0 {
            selectedLetter = currentLetters[currentIndex - 1]
            resetForNewLetter()
        }
    }
}

// MARK: - Toast Views

/// Minimalist success toast
struct SuccessToast: View {
    let letter: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title2)
            
            Text("Great! '\(letter)' completed")
                .font(.subheadline.weight(.medium))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        )
    }
}

/// Minimalist error toast
struct ErrorToast: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
                .font(.title2)
            
            Text("Oops! Stay inside the lines")
                .font(.subheadline.weight(.medium))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        )
    }
}

/// Canvas that tracks drawing progress
struct ProgressTrackingCanvas: View {
    @Binding var canvasView: PKCanvasView
    let letter: String
    @ObservedObject var progressTracker: StrokeProgressTracker
    let onOutOfBounds: () -> Void
    let onLetterComplete: () -> Void
    
    @State private var toolPicker = PKToolPicker()
    @StateObject private var boundaryChecker = BoundaryChecker()
    
    var body: some View {
        GeometryReader { geometry in
            CursiveCanvasView(
                canvasView: $canvasView,
                toolPicker: $toolPicker,
                onDrawingChanged: { drawing in
                    handleDrawingChanged(drawing: drawing, in: geometry.size)
                },
                strokeColor: .systemBlue,
                strokeWidth: learningStrokeWidth,
                showToolPicker: false
            )
            .onAppear {
                progressTracker.setup(for: letter, in: geometry.size)
            }
            .onChange(of: letter) { _, newLetter in
                progressTracker.setup(for: newLetter, in: geometry.size)
            }
        }
        .outOfBoundsFlash(boundaryChecker.isOutOfBounds)
    }
    
    private func handleDrawingChanged(drawing: PKDrawing, in size: CGSize) {
        // Check boundary
        if boundaryChecker.checkDrawing(drawing, for: letter, in: size) {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onOutOfBounds()
            }
            return
        }
        
        // Check progress
        if progressTracker.checkProgress(drawing: drawing) {
            // Letter is complete!
            onLetterComplete()
        }
    }
}

/// Shows checkpoints as dots that light up when touched
struct CheckpointOverlay: View {
    let letter: String
    let currentStrokeIndex: Int
    let completedCheckpoints: Int
    let size: CGSize
    
    var body: some View {
        let strokes = LetterStrokeData.strokes(for: letter)
        
        if currentStrokeIndex < strokes.count {
            let stroke = strokes[currentStrokeIndex]
            
            ForEach(Array(stroke.points.enumerated()), id: \.offset) { index, point in
                let position = CGPoint(
                    x: point.position.x * size.width,
                    y: point.position.y * size.height
                )
                
                Circle()
                    .fill(checkpointColor(for: index))
                    .frame(width: checkpointSize(for: index), height: checkpointSize(for: index))
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .shadow(radius: 2)
                    .position(position)
                    .animation(.easeInOut(duration: 0.3), value: completedCheckpoints)
            }
        }
    }
    
    private func checkpointColor(for index: Int) -> Color {
        if index < completedCheckpoints {
            return .green // Completed
        } else if index == completedCheckpoints {
            return .orange // Current target
        } else if index == 0 {
            return .green.opacity(0.8) // Start point
        } else {
            return .gray.opacity(0.4) // Future
        }
    }
    
    private func checkpointSize(for index: Int) -> CGFloat {
        if index == completedCheckpoints {
            return 20 // Current target is larger
        } else if index == 0 && completedCheckpoints == 0 {
            return 24 // Start point is largest
        } else {
            return 12
        }
    }
}

/// A button representing a letter in the letter selector
struct LetterButton: View {
    let letter: String
    let isSelected: Bool
    var isCompleted: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Text(letter)
                    .font(.custom("Snell Roundhand", size: 28))
                    .fontWeight(.medium)
                    .frame(width: 50, height: 50)
                    .background(backgroundColor)
                    .foregroundColor(foregroundColor)
                    .clipShape(Circle())
                
                if isCompleted && !isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                        .offset(x: 18, y: -18)
                }
            }
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color.accentColor
        } else if isCompleted {
            return Color.green.opacity(0.2)
        } else {
            return Color(.systemGray5)
        }
    }
    
    private var foregroundColor: Color {
        isSelected ? .white : .primary
    }
}

#Preview {
    CursiveLearningView()
}
