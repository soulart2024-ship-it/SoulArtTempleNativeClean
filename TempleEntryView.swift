import SwiftUI

struct TempleEntryView: View {
    
    @State private var glow = false
    @State private var goToDiscovery = false
    @State private var showMore = false
    @State private var isBreathing = false

    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // 🌿 Background (from Theme)
                Theme.templeParchment
                    .ignoresSafeArea()
                
                ScrollView {
                    
                    VStack(spacing: 24) {
                        
                        // MARK: - HERO
                        
                        VStack(spacing: 12) {
                            
                            Image("SoulArt Brand full")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                            
                            Text("Welcome")
                                .font(.largeTitle.bold())
                                .foregroundStyle(Theme.textPrimary)
                            
                            Text("SoulArt Temple is the safe space to just settle.")
                                .foregroundStyle(Theme.textSecondary)
                        }
                        
                        .padding(.top, 20)
                        
                        
                        // MARK: - ENTRY QUESTION
                        
                        VStack(spacing: 8) {
                            
                            Text("How would you like to become today?")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundStyle(Theme.textPrimary)
                                
        
                            
                            Text("This is a safe space for you to experience you.  Discover and Release, Be Still & Seen, Journal, Doodle, Pull a Oracle Card, Breath or Just listen to music.  Whatever you do it is right")
                                .font(Theme.bodyText)
                                .foregroundStyle(Theme.textSecondary)
                            
                            
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
                }
            }
        }
    

   
    private var orbEntrySection: some View {
        
        VStack(spacing: 24) {
            
            Button {
                goToDiscovery = true
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
                
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 20
                ) {
                    
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
                    
                    NavigationLink(destination: CalmSpaceView()) {
                        doorTile(title: "Visual Calm", imageName: "visual_calm_art")
                    }
                    
                    NavigationLink(destination: MusicLoungeView()) {
                        doorTile(title: "Music", imageName: "music_art")
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
    }
    
    // MARK: - ENTRY TILE (LOCAL ONLY — NO GLOBAL IMPACT)
    
    private func doorTile(title: String, imageName: String) -> some View {
        
        
        ZStack {
            
            // 🎨 IMAGE (CLIPPED TO DOOR)
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 70))
                .opacity(0.75)
            
            // 🌿 SOFT OVERLAY (LIGHT ONLY)
            RoundedRectangle(cornerRadius: 70)
                .fill(Color.white.opacity(0.08))
            
            // 🌿 BORDER (SIGNATURE)
            RoundedRectangle(cornerRadius: 70)
                .stroke(Theme.goldSoft.opacity(0.25), lineWidth: 1)
            
            // 🌿 CONTENT
            VStack(spacing: 10) {
                
                Spacer()
                
                Text(title)
                    .foregroundStyle(.black.opacity(0.85))
                    .shadow(color: .white.opacity(0.25), radius: 2)
                
                Image(systemName: "archway")
                    .font(.system(size: 18))
                    .foregroundStyle(Theme.goldSoft.opacity(0.6))
                
                Spacer()
            }
            .padding()
        }
        .frame(height: 180)
        
        .overlay(
            RoundedRectangle(cornerRadius: 70)
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
}
