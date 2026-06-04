import UIKit

struct Haptics {
    
    // 🌬 Gentle presence (breathing, guided steps)
    static func soft() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    // ✨ Light interaction (taps, selections)
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    // ⚖️ Awareness moment (emotion reveal)
    static func medium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    // 🔥 Strong release moment
    static func release() {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
    
    // 💥 Intense (rare use)
    static func heavy() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
    // ✨ Completion / alignment
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    // ⚠️ Resistance / misalignment
    static func warning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
}
