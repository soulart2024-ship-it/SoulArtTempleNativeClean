import SwiftUI

struct DecodersHomeView: View {

    @State private var hasUnlockedEmotionDecoder = true
    @EnvironmentObject var moodStore: MoodStore
    @EnvironmentObject var appState: AppState          // 👈 ADD THIS
    @ObservedObject var purchaseManager = PurchaseManager.shared
    @State private var navigateToDiscovery = false
    @State private var showPaywall = false           // 👈 ADD
    
    var body: some View {
        
        ZStack {
            
            MoodBackgroundView(mood: moodStore.selectedMood)
                .ignoresSafeArea()
            
            ScrollView {
                // ADD THIS:
                Color.clear.onAppear {
                    SessionCounter.shared.refreshStatus()
                }
                
                VStack(spacing: 24) {
                    
                    // 🌿 HEADER
                    VStack(spacing: 8) {
                        Text("Decoders")
                            .font(Theme.sectionTitle)
                            .foregroundStyle(Theme.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Choose a pathway for energetic reflection and gentle release.")
                            .font(Theme.bodyText)
                            .foregroundStyle(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.top, 20)
                    
                    // 🌿 START HERE
                    sectionLabel("Start Here")
                    
                    Button {
                        if SessionCounter.shared.canStartNewSession() {
                            navigateToDiscovery = true
                        } else {
                            showPaywall = true
                        }
                    } label: {
                        VStack(spacing: 0) {
                            decoderCard(
                                icon: "leaf",
                                title: "Discovery Portal",
                                subtitle: "Identify what is ready to be seen"
                            )
                            
                            // Show session counter if not unlocked
                            if !PurchaseManager.shared.hasUnlockedFullAccess {
                                Text("\(SessionCounter.shared.remainingSessions()) free sessions remaining")
                                    .font(.caption2)
                                    .foregroundStyle(Theme.textSecondary.opacity(0.6))
                                    .padding(.top, 4)
                                    .padding(.leading, 80)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        hasUnlockedEmotionDecoder = UserDefaults.standard.bool(forKey: "hasUnlockedEmotionDecoder")
                        Task { await PurchaseManager.shared.loadProducts() }
                        
                    }
                    
                    
                    
                    
                    // 🌿 QUICK ACCESS
                    sectionLabel("Quick Access")
                    
                    if PurchaseManager.shared.hasUnlockedFullAccess {
                        NavigationLink(destination: QuickReleaseView(category: "General")) {
                            decoderCard(
                                icon: "bolt",
                                title: "Quick Release",
                                subtitle: "Fast emotional reset"
                            )
                        }
                        .buttonStyle(.plain)
                    } else {
                        NavigationLink(destination: PaywallView()) {
                            lockedCard(
                                icon: "bolt",
                                title: "Quick Release",
                                subtitle: "Fast emotional reset",
                                note: "Unlock for £0.99"
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // 🌿 DEEP INNER WORK
                    sectionLabel("Deep Inner Work")
                    
                    if PurchaseManager.shared.hasUnlockedFullAccess {
                        NavigationLink(
                            destination: EmotionDecoderView(
                                category: UserDefaults.standard.string(forKey: "discoveryCategory") ?? "General",
                                count: UserDefaults.standard.integer(forKey: "discoveryCount"),
                                hasLayers: UserDefaults.standard.bool(forKey: "discoveryHasLayers")
                            )
                        ) {
                            decoderCard(
                                icon: "circle.hexagongrid",
                                title: "Emotion Decoder",
                                subtitle: "7-step harmonic release method"
                            )
                        }
                        .buttonStyle(.plain)
                    } else {
                        NavigationLink(destination: PaywallView()) {
                            lockedCard(
                                icon: "circle.hexagongrid",
                                title: "Emotion Decoder",
                                subtitle: "7-step harmonic release method",
                                note: "Unlock for £0.99"
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // 🌿 LOCKED — HEART MATRIX
                    lockedCard(
                        icon: "heart.circle",
                        title: "SoulArt Heart Matrix",
                        subtitle: "Shadow heart themes · emotions · beliefs",
                        note: "Advanced pathways unlock through training"
                    )
                    
                    // 🌿 LOCKED — MEDITATION FLOW
                    lockedCard(
                        icon: "waveform.path",
                        title: "Meditation Flow",
                        subtitle: "Let colour move and dissolve",
                        note: "Coming soon"
                    )
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToDiscovery) {
            DiscoveryGroundView()
        }
        .sheet(isPresented: $showPaywall) {
            NavigationStack {
                PaywallView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ReturnToHome"))) { _ in
            navigateToDiscovery = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                appState.returnToHome = true
            }
        }
    }
        // MARK: - Section Label
        
        func sectionLabel(_ text: String) -> some View {
            Text(text)
                .font(Theme.smallText)
                .foregroundStyle(Theme.textSecondary.opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        // MARK: - Decoder Card
        
        func decoderCard(icon: String, title: String, subtitle: String) -> some View {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.warmParchment)
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(Theme.deepBrown.opacity(0.6))
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(Theme.cardTitle)
                        .foregroundStyle(Theme.textPrimary)
                    Text(subtitle)
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(Theme.textSecondary.opacity(0.4))
                    .font(.caption)
            }
            .padding(16)
            .background(Color.white.opacity(0.75))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Theme.goldSoft.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        }
        
        // MARK: - Locked Card
        
        func lockedCard(icon: String, title: String, subtitle: String, note: String) -> some View {
            VStack(spacing: 6) {
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Theme.warmParchment.opacity(0.5))
                            .frame(width: 48, height: 48)
                        Image(systemName: icon)
                            .font(.system(size: 18))
                            .foregroundStyle(Theme.deepBrown.opacity(0.25))
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(title)
                            .font(Theme.cardTitle)
                            .foregroundStyle(Theme.textPrimary.opacity(0.4))
                        Text(subtitle)
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary.opacity(0.4))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "lock.fill")
                        .foregroundStyle(Theme.textSecondary.opacity(0.3))
                        .font(.caption)
                }
                .padding(16)
                .background(Color.white.opacity(0.35))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.goldSoft.opacity(0.15), lineWidth: 1)
                )
                
                Text(note)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 4)
            }
        }
    }

