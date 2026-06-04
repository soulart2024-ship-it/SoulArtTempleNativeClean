//
import Foundation

struct SessionEntry: Identifiable, Codable {
    
    let id: UUID
    let emotion: String
    let category: String   // ✅ ADD THIS
    let date: Date
    var reflection: String?
    var replacement: String
    var meaning: String
    var imageData: Data?
    var stage: String?
    var type: String
    var calibratedFrequency: Int? // ✅ KEEP THIS
    
    init(
        id: UUID = UUID(),
        type: String,                // ✅ NEW
        emotion: String,
        category: String,
        date: Date,
        reflection: String?,
        replacement: String,
        meaning: String,
        imageData: Data? = nil,
        stage: String? = nil,
        calibratedFrequency: Int? = nil                // ✅ KEEP DEFAULT
    ) {
        self.id = id
        self.type = type            // ✅ NEW
        self.emotion = emotion
        self.category = category
        self.date = date
        self.reflection = reflection
        self.replacement = replacement
        self.meaning = meaning
        self.imageData = imageData
        self.stage = stage
        self.calibratedFrequency = calibratedFrequency
    }
}
