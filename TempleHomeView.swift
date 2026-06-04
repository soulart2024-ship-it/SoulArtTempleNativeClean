import SwiftUI

struct TempleHomeView: View {

    @Environment(\.membershipTier) private var tier

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 18) {

                    headerSection

                    // 🌿 DISCOVER
                    Text("Discover")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .padding(.top, 10)

                    NavigationLink(destination: DiscoveryGroundView()) {
                        Card(
                            title: "Discovery Portal",
                            subtitle: "Map your stored emotional patterns (Start here)"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: GuidesView()) {
                        Card(
                            title: "Education Centre",
                            subtitle: "Guides in PDF and video support"
                        )
                    }
                    .buttonStyle(.plain)

                    Card(
                        title: "Oracle Cards",
                        subtitle: "Guided insight (coming soon)"
                    )
                    .opacity(0.6)

                    // 🌊 JUST RELAX
                    Text("Just Relax")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .padding(.top, 16)

                    NavigationLink(
                        destination: JournalView(
                            emotion: "General",
                            replacementWord: "",
                            affirmation: ""
                        )
                    ) {
                        Card(
                            title: "Journal",
                            subtitle: "Prompts + affirmation + music (optional)"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: FluidMeditationRoom()) {
                        Card(
                            title: "Fluid Meditation",
                            subtitle: "Calming colour flow"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: MusicLoungeView()) {
                        Card(
                            title: "Music Lounge",
                            subtitle: "Frequency library + playback"
                        )
                    }
                    .buttonStyle(.plain)

                    // ℹ️ FREE SESSION INFO
                    if tier == .none {
                        Text("Free Quick Release remaining: 3")
                            .foregroundStyle(Theme.textSecondary)
                            .padding(.top, 6)
                    }

                    footerLinks
                        .padding(.top, 10)
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: Header

    private var headerSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            HStack(spacing: 12) {

                Image("SoulArt Brand full")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)

                Text("SoulArt Temple")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Theme.textPrimary)
            }

            Text("Ancient wisdom, modern clarity — at your pace.")
                .foregroundStyle(Theme.textSecondary)
        }
    }

    // MARK: Footer Links

    private var footerLinks: some View {

        FooterLinksView(
            privacyURL: URL(string: "https://www.soularttemple.com/privacy-policy.html")!,
            medicalURL: URL(string: "https://www.soularttemple.com/medical-disclaimer.html")!,
            termsURL: URL(string: "https://www.soularttemple.com/terms-and-conditions.html")!,
            bookingsURL: URL(string: "https://www.soulartltd.com/session-booking")!
        )
    }
}
