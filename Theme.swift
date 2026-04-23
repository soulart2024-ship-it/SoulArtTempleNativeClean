import SwiftUI

struct Theme {

    
    // MARK: - Core Palette
    static let taupe = Color(hex: "#B9A590")
    static let deepBrown = Color(hex: "#574C3F")
    static let softCream = Color(hex: "#F6F3EC")
    static let warmParchment = Color(hex: "#ECE4DA")
    // MARK: - Backgrounds

    static let templeBackground = softCream
    static let templeParchment = warmParchment
    static let backgroundDark = Color(red: 0.10, green: 0.12, blue: 0.20)
    // MARK: - Card Colours

    static let cardPrimary = Color(red: 0.98, green: 0.97, blue: 0.95)
    static let cardSecondary = Color(red: 0.18, green: 0.20, blue: 0.32)

    // MARK: - Accent Colours

    static let accentSoft = Color(red: 0.82, green: 0.74, blue: 0.55)
    static let accentCalm = Color(red: 0.60, green: 0.65, blue: 0.80)
    static let buttonPrimary = Color(red: 0.22, green: 0.30, blue: 0.55)

    // MARK: - Text Colours

    static let textPrimary = deepBrown
    static let textSecondary = taupe
    static let textOnDark = Color.white

    // MARK: - Corner Radius

    static let cardRadius: CGFloat = 20
    static let buttonRadius: CGFloat = 26

    // MARK: - Spacing

    static let spacingSmall: CGFloat = 8
    static let spacingMedium: CGFloat = 16
    static let spacingLarge: CGFloat = 24
}

// MARK: - Typography

extension Theme {

    static let templeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let sectionTitle = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let cardTitle = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let cardSubtitle = Font.system(size: 15, weight: .regular, design: .rounded)
    static let bodyText = Font.system(size: 16, weight: .regular, design: .rounded)
    static let smallText = Font.system(size: 13, weight: .regular, design: .rounded)
}

// MARK: - Emotion Decoder (Root Chakra Theme)

extension Theme {

    // Background

    static let decoderParchment = templeParchment

    static let rootOverlay = LinearGradient(
        colors: [
            Color.red.opacity(0.18),
            Color.clear
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    // Buttons

    static let releaseFill = Color.red.opacity(0.22)
    static let releaseStroke = Color.red.opacity(0.35)

    static let completeFill = Color.black.opacity(0.08)
    static let completeStroke = Color.black.opacity(0.18)

    // ✅ FIXED (these were missing)
    static let success = Color.green
    static let rootActive = Color.red
    static let rootSoft = Color.red.opacity(0.2)
}

// MARK: - Brand Blue System

extension Theme {
    
    static let brandBlue = deepBrown
    
    static let brandBlueGradient = LinearGradient(
        colors: [
            Color(red: 0.22, green: 0.30, blue: 0.55).opacity(0.25),
            Color.clear
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Sacred Gold Accent/Overlays

extension Theme {
    
    static let goldSoft = Color(red: 0.82, green: 0.74, blue: 0.55)
    
    static let goldGlow = Color(red: 0.82, green: 0.74, blue: 0.55).opacity(0.25)
    
    static let warmOverlay = Color(red: 0.25, green: 0.20, blue: 0.15)
    static let warmOverlaySoft = Color(red: 0.22, green: 0.18, blue: 0.14)
    static let warmOverlayDeep = Color(red: 0.30, green: 0.22, blue: 0.16)
}

// MARK: - Emotion Grid

extension Theme {
    
    static let emotionInactive = Color.orange.opacity(0.15)
    
    static let emotionActive = LinearGradient(
        colors: [
            Color.red.opacity(0.85),
            Color.red
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Primary Action Button

extension Theme {
    
    static let primaryButtonFill = LinearGradient(
        colors: [
            brandBlue,
            brandBlue.opacity(0.85)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
// MARK: - Burn / Release Theme

extension Theme {
    
    static let burnGradient = LinearGradient(
        colors: [
            Color(red: 0.85, green: 0.65, blue: 0.30).opacity(0.25), // warm gold
            Color(red: 0.75, green: 0.40, blue: 0.20).opacity(0.18), // burnt orange
            Color.clear
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
// MARK: - Premium Button Style

struct GoldGlowButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        ZStack {
            
            // ✨ GOLD GLOW (always visible)
            RoundedRectangle(cornerRadius: Theme.buttonRadius)
                .fill(Theme.goldSoft.opacity(configuration.isPressed ? 0.35 : 0.25))
                .blur(radius: configuration.isPressed ? 10 : 30)
            
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
        }
    }
}
// MARK: - Card Elevation

extension Theme {
    
    static let cardBackground = warmParchment
    
    static let cardShadowLight = Color.white.opacity(0.6)
    static let cardShadowDark = Color.black.opacity(0.12)
    
    static let cardGlow = goldSoft.opacity(0.08)
}

// MARK: Gradient edge for page
extension View {
    
    func soulArtGlowEdge() -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Theme.brandBlue.opacity(0.3),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                    .opacity(0.6)
            )
    }
}
// MARK: Gradient animation version for page edges
extension View {
    
    func soulArtAnimatedGlow() -> some View {
        self.modifier(SoulArtGlowModifier())
    }
}

struct SoulArtGlowModifier: ViewModifier {
    
    @State private var glow = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(glow ? 0.35 : 0.15),
                                Theme.brandBlue.opacity(glow ? 0.35 : 0.15),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                    .opacity(0.7)
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                    glow.toggle()
                }
            }
    }
}
// 🌿 MOOD MANAGER (ADD BELOW THEME — NOT INSIDE)

struct MoodManager {
    
    private static let key = "selectedMood"
    
    static func save(_ mood: MoodTheme) {
        UserDefaults.standard.set(mood.rawValue, forKey: key)
    }
    
    static func load() -> MoodTheme {
        let raw = UserDefaults.standard.string(forKey: key)
        return MoodTheme(rawValue: raw ?? "") ?? .warm
    }
}
