//
//  LetterTemplateView.swift
//  CursiveWorld
//
//  Created by Benjamin Belloeil on 03/12/25.
//

import SwiftUI

/// Displays a cursive letter template for users to trace
struct LetterTemplateView: View {
    let letter: String
    let fontSize: CGFloat
    
    init(letter: String, fontSize: CGFloat = 200) {
        self.letter = letter
        self.fontSize = fontSize
    }
    
    var body: some View {
        Text(letter)
            .font(.custom("Snell Roundhand", size: fontSize))
            .foregroundColor(.gray.opacity(0.3))
    }
}

/// A view showing guide lines for writing practice
struct WritingGuideLines: View {
    let lineSpacing: CGFloat
    let lineColor: Color
    
    init(lineSpacing: CGFloat = 60, lineColor: Color = .gray.opacity(0.2)) {
        self.lineSpacing = lineSpacing
        self.lineColor = lineColor
    }
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let numberOfLines = Int(geometry.size.height / lineSpacing)
                
                for i in 0...numberOfLines {
                    let y = CGFloat(i) * lineSpacing
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(lineColor, lineWidth: 1)
        }
    }
}

/// Combined template view with guidelines and letter
struct TracingTemplateView: View {
    let letter: String
    
    var body: some View {
        ZStack {
            WritingGuideLines()
            LetterTemplateView(letter: letter)
        }
    }
}

#Preview {
    TracingTemplateView(letter: "A")
}
