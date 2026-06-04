//
//  SessionCounter.swift
//  SoulArtTempleNativeClean
//
//  Tracks Discovery Portal sessions (3 free)
//

import Foundation
import Combine

class SessionCounter: ObservableObject {
    
    static let shared = SessionCounter()
    
    // 📊 Published properties
    @Published var sessionCount: Int = 0
    @Published var hasReachedLimit: Bool = false
    
    private let maxFreeSessions = 3
    private let sessionCountKey = "discoverySessionCount"
    
    // MARK: - Initialization
    
    init() {
        loadSessionCount()
    }
    
    // MARK: - Load Session Count
    
    private func loadSessionCount() {
        sessionCount = UserDefaults.standard.integer(forKey: sessionCountKey)
        checkLimit()
        print("📊 Session count loaded: \(sessionCount) / \(maxFreeSessions)")
    }
    
    
    // MARK: - Increment Session
    
    func incrementSession() {
        // Don't increment if user has unlocked full access
        if PurchaseManager.shared.hasUnlockedFullAccess {
            return
        }
        
        sessionCount += 1
        UserDefaults.standard.set(sessionCount, forKey: sessionCountKey)
        checkLimit()
    }
    
    // MARK: - Check Limit
    
    private func checkLimit() {
        hasReachedLimit = sessionCount >= maxFreeSessions && !PurchaseManager.shared.hasUnlockedFullAccess
    }
    
    // MARK: - Get Remaining Sessions
    
    func remainingSessions() -> Int {
        if PurchaseManager.shared.hasUnlockedFullAccess {
            return Int.max // Unlimited
        }
        return max(0, maxFreeSessions - sessionCount)
    }
    
    // MARK: - Can Start New Session
    
    func canStartNewSession() -> Bool {
        // Always allow if purchased
        if PurchaseManager.shared.hasUnlockedFullAccess {
            return true
        }
        
        // Otherwise check if under limit
        return sessionCount < maxFreeSessions
    }
    
    // MARK: - Reset (for testing only)
    
    func resetForTesting() {
        sessionCount = 0
        UserDefaults.standard.set(0, forKey: sessionCountKey)
        hasReachedLimit = false
    }
    // MARK: - Refresh Status

    func refreshStatus() {
        loadSessionCount()
        objectWillChange.send()
    }

        
        
    }

