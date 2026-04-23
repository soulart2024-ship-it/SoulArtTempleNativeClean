import Foundation

struct DiscoveryItem: Identifiable, Codable {

    var id = UUID()

    let category: String
    var count: Int
    let hasLayers: Bool
}
