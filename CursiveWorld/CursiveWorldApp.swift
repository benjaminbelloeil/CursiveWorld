//
//  CursiveWorldApp.swift
//  CursiveWorld
//
//  Created by Benjamin Belloeil on 03/12/25.
//

import SwiftUI

@main
struct CursiveWorldApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
