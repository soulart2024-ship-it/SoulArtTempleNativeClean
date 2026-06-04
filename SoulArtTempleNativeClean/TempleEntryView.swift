import SwiftUI

struct TempleEntryView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var supabaseService: SupabaseService
    @State private var glow = false
    @State private var goToDiscovery = false
    @State private var showMore = false
    @State private var isBreathing = false
    @State private var showHowItWorks = false
    @State private var showPaywall = false
    @ObservedObject var sessionCounter = SessionCounter.shared
    
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // 🌿 Background (from Theme)
                Theme.templeParchment
                    .ignoresSafeArea()
                
                ScrollView {
                    
                    VStack(spacing: 24) {
                        AnnouncementBanner()
                        // MARK: - HERO
                        
                        VStack(spacing: 12) {
                            
                            Image("SoulArt Brand full")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                            
                            Text("Welcome")
                                .font(.largeTitle.bold())
                                .foregroundStyle(Theme.textPrimary)
                            
                            Text("This is your safe space to settle and release.")
                                .foregroundStyle(Theme.textSecondary)
                            
                        }
                        
                        .padding(.top, 20)
                        
                        
                        // MARK: - ENTRY QUESTION

                        VStack(spacing: 12) {
                                                    
                            Text("How would you like to become today?")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundStyle(Theme.textPrimary)
                                .multilineTextAlignment(.center)
                            
                            Text("If Unsure click below to see how it works.")
                                .font(Theme.bodyText)
                                .foregroundStyle(Theme.textSecondary)
                            
                            // 📖 HOW IT WORKS TOGGLE
                            Button {
                                withAnimation(.easeInOut) {
                                    showHowItWorks.toggle()
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Text("How This Works")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(Theme.deepBrown)
                                    Image(systemName: showHowItWorks ? "chevron.up" : "chevron.down")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Theme.deepBrown.opacity(0.6))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(Theme.warmParchment.opacity(0.5))
                                )
                            }
                            .padding(.top, 8)
                            
                            // 📖 EXPANDED CONTENT
                            if showHowItWorks {
                                VStack(alignment: .leading, spacing: 10) {
                                    explanationRow(
                                        icon: "leaf",
                                        title: "Discover & Release",
                                        description: "Use your body's wisdom to identify stored emotions, then release them through simple, guided steps."
                                    )
                                    
                                    explanationRow(
                                        icon: "paintbrush.pointed",
                                        title: "Express",
                                        description: "Create art, doodle, or explore flowing visuals as a pathway for processing and expression."
                                    )
                                    
                                    explanationRow(
                                        icon: "sun.max",
                                        title: "Still",
                                        description: "A place to just be seen and heard — nothing required."
                                    )
                                    
                                    explanationRow(
                                        icon: "sparkles",
                                        title: "Aurum AI",
                                        description: "Coded specifically to support your nervous system, based on Soraya's approach."
                                    )
                                    
                                    explanationRow(
                                        icon: "moon.stars",
                                        title: "Oracle Cards",
                                        description: "She is just that — a guide to raise your vibration."
                                    )
                                    
                                    explanationRow(
                                        icon: "wind",
                                        title: "Breathe",
                                        description: "Just breathe, recalibrate."
                                    )
                                    
                                    explanationRow(
                                        icon: "waveform",
                                        title: "Visual Calm",
                                        description: "A place to listen, become, and reflect."
                                    )
                                    
                                    explanationRow(
                                        icon: "book",
                                        title: "Reflect",
                                        description: "Journal your insights, track your sessions, and witness your journey unfold."
                                    )
                                    
                                    explanationRow(
                                                                        icon: "heart",
                                                                        title: "Your Pace",
                                                                        description: "There's no rush. This is your space. Come as you are, work at your own rhythm."
                                                                    )
                                                                    
                                                                    Divider()
                                                                        .padding(.vertical, 8)
                                                                    
                                                                    NavigationLink {
                                                                        KinesiologyMiniCourse()
                                                                    } label: {
                                                                        HStack(spacing: 10) {
                                                                            Image(systemName: "graduationcap.fill")
                                                                                .font(.system(size: 14))
                                                                                .foregroundStyle(Theme.goldSoft)
                                                                            
                                                                            VStack(alignment: .leading, spacing: 2) {
                                                                                Text("Learn Self-Testing")
                                                                                    .font(.system(size: 14, weight: .semibold))
                                                                                    .foregroundStyle(Theme.textPrimary)
                                                                                Text("Complete beginner's guide to muscle testing")
                                                                                    .font(.system(size: 12))
                                                                                    .foregroundStyle(Theme.textSecondary)
                                                                            }
                                                                            
                                                                            Spacer()
                                                                            
                                                                            Image(systemName: "chevron.right")
                                                                                .font(.system(size: 12))
                                                                                .foregroundStyle(Theme.textSecondary.opacity(0.5))
                                                                        }
                                                                        .padding(12)
                                                                        .background(Theme.warmParchment.opacity(0.3))
                                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                                    }
                                                                }
                                                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.7))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Theme.goldSoft.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal, 8)
                                .padding(.top, 8)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .padding(.horizontal)
                        
                        
                        // MARK: - ORB ENTRY
                        
                        orbEntrySection
                        
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        // MARK: - FOOTER
                        
                        FooterLinksView(
                            privacyURL: URL(string: "https://www.soularttemple.com/privacy-policy.html")!,
                            medicalURL: URL(string: "https://www.soularttemple.com/medical-disclaimer.html")!,
                            termsURL: URL(string: "https://www.soularttemple.com/terms-and-conditions.html")!,
                            bookingsURL: URL(string: "https://www.soulartltd.com/session-booking")!
                        )
                        .padding(.horizontal)
                    }
                }
                .navigationDestination(isPresented: $goToDiscovery) {
                    DiscoveryCategoryView()
                }
                .sheet(isPresented: $showPaywall) {
                    NavigationStack {
                        PaywallView()
                    }
                }
            }
        }
        .onChange(of: appState.returnToHome) { _, newValue in
            if newValue {
                goToDiscovery = false
                appState.returnToHome = false
                SessionCounter.shared.refreshStatus()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ReturnToHome"))) { _ in
            goToDiscovery = false
            appState.returnToHome = false
            SessionCounter.shared.refreshStatus()
        }

    }
    
    
    
    
    private var orbEntrySection: some View {
        
        VStack(spacing: 24) {
            Color.clear
                        .frame(height: 0)
                        .onAppear {
                            SessionCounter.shared.refreshStatus()
                        }
            VStack(spacing: 8) {
                Button {
                    // Check if user can start a new session
                    if SessionCounter.shared.canStartNewSession() {
                        goToDiscovery = true
                    } else {
                        // Show paywall if limit reached
                        showPaywall = true
                    }
                } label: {
                    
                    ZStack {
                        
                        // STATIC CORE (NEVER MOVES)
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Theme.goldSoft,
                                        Theme.goldSoft.opacity(0.7),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 100
                                )
                            )
                            .frame(width: 120, height: 120)
                            .scaleEffect(isBreathing ? 1.05 : 0.95)
                            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isBreathing)
                        
                        // GLOW LAYER (ANIMATED — DOES NOT AFFECT LAYOUT)
                        Circle()
                            .fill(Theme.goldSoft)
                            .frame(width: 180, height: 180)
                            .opacity(0.25)
                            .blur(radius: 30)
                            .scaleEffect(isBreathing ? 1.1 : 0.9)
                            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isBreathing)
                            .allowsHitTesting(false)
                        
                        Text("Discover & Release")
                            .font(.headline)
                            .foregroundStyle(Theme.textPrimary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 200, height: 200)
                    .fixedSize()
                }
                
                // Show promotional message if not unlocked
                if !PurchaseManager.shared.hasUnlockedFullAccess {
                    Button {
                        showPaywall = true
                    } label: {
                        VStack(spacing: 4) {
                            Text("3 Free Sessions")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Theme.textPrimary)
                            
                            Text("Unlock unlimited for just £0.99")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.7))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.goldSoft.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .onAppear {
                isBreathing = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isBreathing = true
                }
            }
            
            Button {
                withAnimation(.easeInOut) {
                    showMore.toggle()
                }
            } label: {
                Text("More…")
                    .foregroundStyle(Theme.textSecondary)
            }
            
            if showMore {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        
                        // 🎵 MUSIC TRIGGER
                        if MusicPlayer.shared.currentTrack == nil {
                            Button {
                                MusicPlayer.shared.playTrack("432hz")
                            } label: {
                                musicTriggerTile()
                            }
                        }

                        NavigationLink(destination: StillView()) {
                            doorTile(title: "Still", imageName: "still_art")
                        }
                        
                        NavigationLink(destination: AurumCompanionView()) {
                            doorTile(title: "Aurum", imageName: "aurum_art")
                        }
                        
                        NavigationLink(destination: OracleView()) {
                            doorTile(title: "Oracle Guidance", imageName: "oracle_art")
                        }
                        
                        NavigationLink(destination: BreatheView()) {
                            doorTile(title: "Breathe", imageName: "breathe_art")
                        }
                        
                        Button {
                            // Locked - do nothing
                        } label: {
                            lockedDoorTile(title: "Visual Calm", imageName: "visual_calm_art")
                        }
                        
                        Button {
                            // Locked - do nothing
                        } label: {
                            lockedDoorTile(title: "Music", imageName: "music_art")
                        }
                    }
                    .padding(.horizontal, 24)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .safeAreaInset(edge: .leading) { Color.clear.frame(width: 0) }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
    }
    // MARK: - LOCKED ENTRY TILE

    private func lockedDoorTile(title: String, imageName: String) -> some View {
        
        ZStack {
            
            // 🎨 IMAGE (CLIPPED TO DOOR)
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .opacity(0.3)
            
            // 🌿 SOFT OVERLAY
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.black.opacity(0.4))
            
            // 🌿 BORDER
            RoundedRectangle(cornerRadius: 40)
                .stroke(Theme.goldSoft.opacity(0.15), lineWidth: 1)
            
            // 🌿 CONTENT
            VStack(spacing: 10) {
                
                Image(systemName: "door.left.hand.open")
                    .font(.system(size: 24))
                    .foregroundStyle(Theme.goldSoft.opacity(0.5))
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Theme.textPrimary.opacity(0.6))
                    .multilineTextAlignment(.center)
                
                Text("Unlocking Soon")
                    .font(.caption2)
                    .foregroundStyle(Theme.textSecondary.opacity(0.5))
            }
            .padding()
        }
        .frame(width: 160, height: 200)
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 6
        )
    }
    // MARK: - ENTRY TILE (LOCAL ONLY — NO GLOBAL IMPACT)
    
    private func doorTile(title: String, imageName: String) -> some View {
        
        ZStack {
            
            // 🎨 IMAGE (CLIPPED TO DOOR)
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .opacity(0.75)
            
            // 🌿 SOFT OVERLAY (LIGHT ONLY)
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.white.opacity(0.08))
            
            // 🌿 BORDER (SIGNATURE)
            RoundedRectangle(cornerRadius: 40)
                .stroke(Theme.goldSoft.opacity(0.25), lineWidth: 1)
            
            // 🌿 CONTENT
            VStack(spacing: 10) {
                
                Spacer()
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Theme.deepBrown.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .shadow(color: .white.opacity(0.25), radius: 2)
                
                Image(systemName: "door.left.hand.open")
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.goldSoft.opacity(0.6))
                
                Spacer()
            }
            .padding()
        }
        .frame(width: 160, height: 200)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(
                    Theme.goldSoft.opacity(glow ? 0.6 : 0.25),
                    lineWidth: glow ? 2 : 1
                )
                .blur(radius: glow ? 1.5 : 0)
        )
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 6
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                glow.toggle()
            }
        }
    }
    // MARK: - EXPLANATION ROW

    private func explanationRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Theme.goldSoft)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(description)
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    // MARK: - MUSIC TRIGGER TILE

    private func musicTriggerTile() -> some View {
        ZStack {
            Image("music_art")
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .opacity(0.75)

            RoundedRectangle(cornerRadius: 40)
                .fill(Color.white.opacity(0.08))

            RoundedRectangle(cornerRadius: 40)
                .stroke(Theme.goldSoft.opacity(0.25), lineWidth: 1)

            VStack(spacing: 10) {
                Spacer()
                Text("Frequencies")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Theme.deepBrown.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .shadow(color: .white.opacity(0.25), radius: 2)
                Image(systemName: "music.note")
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.goldSoft.opacity(0.6))
                Spacer()
            }
            .padding()
        }
        .frame(width: 160, height: 200)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
    
    }
}
