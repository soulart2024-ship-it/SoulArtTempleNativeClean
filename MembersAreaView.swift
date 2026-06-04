import SwiftUI

struct MembersAreaView: View {

    @EnvironmentObject var discoveryStore: DiscoveryStore
    @EnvironmentObject var moodStore: MoodStore
    @EnvironmentObject var supabaseService: SupabaseService

    @State private var hasCompletedDiscovery = false
    @State private var discoveryCategory: String = "Unknown"
    @State private var discoveryCount: Int = 0
    @State private var discoveryHasLayers: Bool = false
    @State private var navigateToDecoder = false
    @State private var navigateToDiscovery = false
    @State private var hasUnlockedKinesiology = false
    @State private var hasUnlockedEmotionDecoder = false
    @State private var showCourse = false

    var body: some View {

        NavigationStack {

            ZStack {

                MoodBackgroundView(mood: moodStore.selectedMood)

                ScrollView {

                    VStack(spacing: 28) {

                        Spacer(minLength: 20)

                        // 🌿 TITLE
                        Text("My Journey")
                            .font(Theme.sectionTitle)
                            .foregroundStyle(Theme.textPrimary)

                        Text("Continue your process or explore your tools")
                            .font(Theme.bodyText)
                            .foregroundStyle(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)

                        // 🌸 DAILY QUOTE
                        if let quote = supabaseService.dailyQuote {
                            VStack(spacing: 6) {
                                Text("✦")
                                    .foregroundStyle(Theme.goldSoft)
                                    .font(.caption)
                                Text("\"\(quote.quote)\"")
                                    .font(Theme.smallText)
                                    .foregroundStyle(Theme.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .italic()
                                if let author = quote.author {
                                    Text("— \(author)")
                                        .font(.caption2)
                                        .foregroundStyle(Theme.textSecondary.opacity(0.6))
                                }
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.6))
                            .cornerRadius(16)
                            .padding(.horizontal, 20)
                        }

                        // 🌿 YOUR JOURNEY
                        sectionLabel("Your Journey")

                        NavigationLink(destination: JournalHistoryView()) {
                            Card(title: "Session History", subtitle: "View your past sessions")
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 20)

                        // 🎨 MOOD SELECTION
                        sectionLabel("Choose Your Space")

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(MoodTheme.allCases, id: \.self) { mood in
                                    Button {
                                        moodStore.setMood(mood)
                                    } label: {
                                        Text(mood.rawValue.capitalized)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .background(Theme.cardPrimary)
                                            .foregroundStyle(Theme.textPrimary)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }

                        // 🎨 CREATIVE SPACE
                        sectionLabel("Creative Space")

                        VStack(spacing: 12) {
                            NavigationLink(destination: DoodleLoungeHomeView()) {
                                Card(title: "Doodle Room", subtitle: "Express and create freely")
                            }
                            .buttonStyle(.plain)

                            NavigationLink(destination: JournalHistoryView()) {
                                Card(title: "Journal", subtitle: "Reflect on your journey")
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 20)

                        // 📚 LEARN
                        sectionLabel("Learn")

                        VStack(spacing: 12) {

                            Button {
                                showCourse = true
                            } label: {
                                HStack(spacing: 16) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Theme.warmParchment)
                                            .frame(width: 52, height: 52)
                                        Image(systemName: "leaf.circle")
                                            .font(.system(size: 22))
                                            .foregroundStyle(Theme.deepBrown.opacity(0.7))
                                    }
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text("Self-Testing & Kinesiology")
                                            .font(Theme.cardTitle)
                                            .foregroundStyle(Theme.textPrimary)
                                        Text("5 modules · Learn muscle testing for yourself")
                                            .font(Theme.smallText)
                                            .foregroundStyle(Theme.textSecondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(Theme.textSecondary.opacity(0.4))
                                        .font(.caption)
                                }
                                .padding(18)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .strokeBorder(Theme.goldSoft.opacity(0.4), lineWidth: 1.5)
                                )
                            }
                            .buttonStyle(.plain)

                            NavigationLink(destination: EducationView(topic: .emotionDecoding)) {
                                Card(title: "Emotional Decoding", subtitle: "Understand how emotions are identified and released")
                            }
                            .buttonStyle(.plain)

                            NavigationLink(destination: EducationView(topic: .kinesiology)) {
                                Card(title: "Kinesiology", subtitle: "Learn how the body provides feedback")
                            }
                            .buttonStyle(.plain)

                            NavigationLink(destination: EducationView(topic: .bodyAwareness)) {
                                Card(title: "Body Awareness", subtitle: "How emotion is stored and felt")
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 20)

                        // 🛍 CREATE & SHOP
                        sectionLabel("Create & Shop")

                        VStack(spacing: 12) {
                            Link(destination: URL(string: "https://soulart-studio.printify.me/")!) {
                                Card(title: "Shop Your Creations", subtitle: "Print your art on products or browse our SoulArt collection")
                            }
                        }
                        .padding(.horizontal, 20)

                        Spacer(minLength: 80)
                    }
                }
                .onAppear {
                    hasUnlockedEmotionDecoder = UserDefaults.standard.bool(forKey: "hasUnlockedEmotionDecoder")
                }
            }
            .fullScreenCover(isPresented: $showCourse) {
                KinesiologyMiniCourse()
            }
        }
    }

    func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(Theme.smallText)
            .foregroundStyle(Theme.textSecondary.opacity(0.6))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
    }
}
