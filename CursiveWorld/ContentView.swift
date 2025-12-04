//
//  ContentView.swift
//  CursiveWorld
//
//  Created by Benjamin Belloeil on 03/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // App icon/header
                VStack(spacing: 10) {
                    Image(systemName: "pencil.and.scribble")
                        .font(.system(size: 80))
                        .foregroundStyle(.tint)
                    
                    Text("Cursive World")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Learn beautiful cursive handwriting")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 100)
                
                Spacer()
                
                // Main action buttons
                VStack(spacing: 16) {
                    NavigationLink(destination: CursiveLearningView()) {
                        HStack {
                            Image(systemName: "hand.draw")
                                .font(.title2)
                            Text("Start Learning")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
