import SwiftUI

enum MoodTheme: String, CaseIterable {
    case warm
    case calm
    case heart
    case intuitive
    case none
}

struct MoodBackgroundView: View {
    
    var mood: MoodTheme = .warm
    
    @State private var move1 = false
    @State private var move2 = false
    
    var body: some View {
        
        ZStack {
            
            // 🌿 BASE COLOUR
            Color(red: 0.94, green: 0.88, blue: 0.80)
                .ignoresSafeArea()
            
            // 🔥 BLOB 1
            Circle()
                .fill(blob1Gradient)
                .frame(width: 380, height: 380)
                .blur(radius: 60)
                .offset(x: move1 ? 140 : -140, y: move1 ? -180 : 180)
                .animation(
                    .easeInOut(duration: 10)
                    .repeatForever(autoreverses: true),
                    value: move1
                )
            
            // 💗 BLOB 2
            Circle()
                .fill(blob2Gradient)
                .frame(width: 340, height: 340)
                .blur(radius: 70)
                .offset(x: move2 ? -160 : 160, y: move2 ? 200 : -200)
                .animation(
                    .easeInOut(duration: 12)
                    .repeatForever(autoreverses: true),
                    value: move2
                )
        }
        .onAppear {
            move1.toggle()
            move2.toggle()
        }
    }
    
    // MARK: - Mood Gradients  ✅ THIS MUST BE HERE
    
    private var blob1Gradient: LinearGradient {
        switch mood {
        case .warm:
            return LinearGradient(colors: [Color.orange.opacity(0.6), Color.red.opacity(0.4)], startPoint: .top, endPoint: .bottom)
        case .calm:
            return LinearGradient(colors: [Color.blue.opacity(0.5), Color.cyan.opacity(0.3)], startPoint: .top, endPoint: .bottom)
        case .heart:
            return LinearGradient(colors: [Color.green.opacity(0.5), Color.mint.opacity(0.3)], startPoint: .top, endPoint: .bottom)
        case .intuitive:
            return LinearGradient(colors: [Color.purple.opacity(0.5), Color.indigo.opacity(0.3)], startPoint: .top, endPoint: .bottom)
        case .none:
            return LinearGradient(colors: [Color.clear, Color.clear], startPoint: .top, endPoint: .bottom)
        }
    }
    
    private var blob2Gradient: LinearGradient {
        switch mood {
        case .warm:
            return LinearGradient(colors: [Color.pink.opacity(0.5), Color.purple.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .calm:
            return LinearGradient(colors: [Color.cyan.opacity(0.4), Color.blue.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .heart:
            return LinearGradient(colors: [Color.green.opacity(0.4), Color.teal.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .intuitive:
            return LinearGradient(colors: [Color.indigo.opacity(0.4), Color.purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .none:
            return LinearGradient(colors: [Color.clear, Color.clear], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}
