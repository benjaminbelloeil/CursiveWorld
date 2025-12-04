//
//  AppState.swift
//  CursiveWorld
//
//  Created by Benjamin Belloeil on 04/12/25.
//

import SwiftUI
import Combine

/// Global app state that persists across the application
final class AppState: ObservableObject {
    // MARK: - Published Properties
    
    /// User's progress data
    @Published var completedLetters: Set<String> = []
    @Published var totalPracticeTime: TimeInterval = 0
    @Published var currentStreak: Int = 0
    @Published var lastPracticeDate: Date?
    
    /// User preferences
    @Published var prefersDarkMode: Bool = false
    @Published var hapticFeedbackEnabled: Bool = true
    @Published var soundEffectsEnabled: Bool = true
    
    // MARK: - Computed Properties
    
    var lowercaseProgress: Double {
        let lowercase = Set("abcdefghijklmnopqrstuvwxyz".map { String($0) })
        let completed = completedLetters.intersection(lowercase)
        return Double(completed.count) / 26.0
    }
    
    var uppercaseProgress: Double {
        let uppercase = Set("ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) })
        let completed = completedLetters.intersection(uppercase)
        return Double(completed.count) / 26.0
    }
    
    var overallProgress: Double {
        Double(completedLetters.count) / 52.0
    }
    
    var formattedPracticeTime: String {
        let hours = Int(totalPracticeTime) / 3600
        let minutes = (Int(totalPracticeTime) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes) min"
        }
    }
    
    // MARK: - Persistence Keys
    
    private enum Keys {
        static let completedLetters = "completedLetters"
        static let totalPracticeTime = "totalPracticeTime"
        static let currentStreak = "currentStreak"
        static let lastPracticeDate = "lastPracticeDate"
    }
    
    // MARK: - Initialization
    
    init() {
        loadState()
        updateStreak()
    }
    
    // MARK: - Public Methods
    
    func markLetterComplete(_ letter: String) {
        completedLetters.insert(letter)
        saveState()
    }
    
    func addPracticeTime(_ time: TimeInterval) {
        totalPracticeTime += time
        lastPracticeDate = Date()
        updateStreak()
        saveState()
    }
    
    func resetProgress() {
        completedLetters.removeAll()
        totalPracticeTime = 0
        currentStreak = 0
        lastPracticeDate = nil
        saveState()
    }
    
    // MARK: - Private Methods
    
    private func loadState() {
        if let data = UserDefaults.standard.array(forKey: Keys.completedLetters) as? [String] {
            completedLetters = Set(data)
        }
        totalPracticeTime = UserDefaults.standard.double(forKey: Keys.totalPracticeTime)
        currentStreak = UserDefaults.standard.integer(forKey: Keys.currentStreak)
        lastPracticeDate = UserDefaults.standard.object(forKey: Keys.lastPracticeDate) as? Date
    }
    
    private func saveState() {
        UserDefaults.standard.set(Array(completedLetters), forKey: Keys.completedLetters)
        UserDefaults.standard.set(totalPracticeTime, forKey: Keys.totalPracticeTime)
        UserDefaults.standard.set(currentStreak, forKey: Keys.currentStreak)
        UserDefaults.standard.set(lastPracticeDate, forKey: Keys.lastPracticeDate)
    }
    
    private func updateStreak() {
        guard let lastDate = lastPracticeDate else {
            currentStreak = 0
            return
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastDay = calendar.startOfDay(for: lastDate)
        
        let daysDifference = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
        
        if daysDifference == 0 {
            // Same day, streak continues
        } else if daysDifference == 1 {
            // Consecutive day, increment streak
            currentStreak += 1
        } else {
            // Streak broken
            currentStreak = 1
        }
    }
}
