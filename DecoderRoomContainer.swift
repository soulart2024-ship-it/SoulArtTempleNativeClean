import SwiftUI

struct DecoderRoomContainer<Content: View>: View {
    @State private var breathing = false
    
    let title: String
    let subtitle: String?
    let content: Content

    init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {

        ZStack {

            // Shared decoder background
            ZStack {

                Theme.decoderParchment
                    .opacity(0.25)   // 👈 THIS IS THE KEY

                Theme.rootOverlay
                    .opacity(0.2)    // 👈 soften overlay
                
                RadialGradient(
                    colors: [
                        Color.white.opacity(0.08),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: breathing ? 120 : 40,
                    endRadius: breathing ? 420 : 220
                )
                .blur(radius: 60)
                .animation(
                    .easeInOut(duration: 8)
                    .repeatForever(autoreverses: true),
                    value: breathing
                )

            }
            .ignoresSafeArea()
            .onAppear {
                breathing = true
            }

            ScrollView {

                VStack(alignment: .leading, spacing: Theme.spacingMedium) {

                    Text(title)
                        .font(Theme.templeTitle)
                        .foregroundColor(.white)

                    if let subtitle {
                        Text(subtitle)
                            .font(Theme.bodyText)
                            .foregroundColor(.white.opacity(0.85))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    content

                }
                .padding(.horizontal, Theme.spacingMedium)
                .padding(.top, Theme.spacingMedium)
                .padding(.bottom, 120)

            }
            .frame(maxWidth: .infinity)
            .scrollIndicators(.hidden)

        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
