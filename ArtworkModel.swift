import SwiftUI

struct Artwork: Identifiable {
    let id = UUID()
    var name: String
    var image: UIImage
    var date: Date
}
