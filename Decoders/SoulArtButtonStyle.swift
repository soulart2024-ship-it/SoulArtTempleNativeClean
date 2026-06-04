import SwiftUI

struct SoulArtButtonStyle: ButtonStyle {
    var isEnabled: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: isEnabled
                        ? [Theme.cardPrimary, Theme.cardSecondary]
                        : [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundStyle(.white.opacity(isEnabled ? 1.0 : 0.5))
            .cornerRadius(14)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .shadow(
                color: Color.black.opacity(configuration.isPressed ? 0.08 : 0.15),
                radius: configuration.isPressed ? 3 : 8,
                y: configuration.isPressed ? 1 : 4
            )
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
