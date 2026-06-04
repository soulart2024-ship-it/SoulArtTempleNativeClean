import Foundation
import Combine

class DiscoveryStore: ObservableObject {
    
    @Published var items: [DiscoveryItem] = []
    @Published var releasedToday: Int = 0
    @Published var sessions: [SessionEntry] = []
    
    private let sessionsKey = "savedSessions"
    
    // MARK: - Save Category Data
    func save(category: String, count: Int, hasLayers: Bool) {
        
        items.removeAll { $0.category == category }
        
        let newItem = DiscoveryItem(
            category: category,
            count: count,
            hasLayers: hasLayers
        )
        
        items.append(newItem)
    }
    
    // MARK: - Reduce Count
    func reduceCount(for category: String) {
        if let index = items.firstIndex(where: { $0.category == category }) {
            if items[index].count > 0 {
                items[index].count -= 1
                releasedToday += 1
            }
        }
    }
    
    // MARK: - Session Tracking 🌿
    
    func addSession(
        emotion: String,
        replacement: String,
        category: String,
        date: Date
    ) {
        
        let newSession = SessionEntry(
            id: UUID(),
            type: "release",
            emotion: emotion,
            category: category,
            date: date,
            reflection: nil,
            replacement: replacement,
            meaning: self.replacement(for: emotion).meaning
        )
        
        sessions.insert(newSession, at: 0)
        saveSessions()
    }
    
    func addDiscoverySession(category: String, count: Int, hasLayers: Bool) {
        
        let session = SessionEntry(
            id: UUID(),
            type: "discovery", // ✅ MOVE HERE
            emotion: "\(category) - \(count) stored patterns",
            category: category,
            date: Date(),
            reflection: hasLayers ? "Layers present" : "No layers",
            replacement: "",
            meaning: "Identified emotional patterns ready for exploration"
        )
        
        sessions.insert(session, at: 0)
        saveSessions()
    }
    
    
    func saveSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
        }
    }
    func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([SessionEntry].self, from: data) {
            sessions = decoded
        }
    }
    func replacement(for emotion: String) -> (word: String, meaning: String) {
        
        switch emotion {
            
        case "Fear":
            return ("Courage", "A willingness to move forward despite uncertainty.")
            
        case "Guilt":
            return ("Self-Forgiveness", "Allowing yourself to release the weight of the past.")
            
        case "Shame":
            return ("Self-Worth", "Recognising your inherent value without condition.")
            
        case "Grief":
            return ("Acceptance", "Softening into what is, without resistance.")
            
        case "Anger":
            return ("Peace", "Choosing calm clarity over reaction.")
            
        case "Despair":
            return ("Calm Courage", "Holding steady even when things feel uncertain.")
            
        case "Abandonment":
            return ("Self-Love", "Returning to yourself as your own foundation.")
            
        case "Rejection":
            return ("Acceptance", "Allowing yourself to belong without needing approval.")
            
        case "Hopelessness":
            return ("Hope", "Opening to possibility again.")
            
        case "Powerlessness":
            return ("Inner Strength", "Reclaiming your ability to respond and choose.")
            
        case "Anxiety":
            return ("Joy", "Allowing lightness and ease to return.")
            
        case "Worthlessness":
            return ("Happiness", "Reconnecting with your natural state of being.")
            
        default:
            return ("Balance", "Returning to a centred and grounded state.")
        }
    }
}
