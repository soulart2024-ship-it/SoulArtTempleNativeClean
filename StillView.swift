import SwiftUI

struct StillView: View {
    
    // MARK: - State
    
    @State private var selectedHex: String? = nil
    @State private var currentAcknowledgement: String = ""
    @State private var showAcknowledgement = false
    @State private var showChoice = false
    @State private var navigateToDiscovery = false
    @State private var navigateToBreathe = false
    @State private var suggestedFrequency: String? = nil
    @State private var isPlaying = false
    @State private var currentFrequency: String? = nil

    
    // MARK: - Acknowledgements
    
    private let acknowledgements: [String: [String]] = [
        
        "#5f6368": [
            "This can be here without needing to move.",
            "Even this heaviness is allowed to rest.",
            "Nothing needs to be lifted right now.",
            "You are not required to make sense of this.",
            "This can exist without urgency.",
            "You can sit beside this, not inside it."
        ],
        
        "#9aa0a6": [
            "It’s okay to not have clarity yet.",
            "Nothing needs to be decided here.",
            "You can remain in this space gently.",
            "Understanding can come later.",
            "This moment does not require answers.",
            "You are allowed to pause here."
        ],
        
        "#c7a6a1": [
            "This feeling is safe to be felt.",
            "You can soften around this.",
            "There is no need to hold this tightly.",
            "This can be held gently.",
            "You are allowed to feel without explaining.",
            "This can move at its own pace."
        ],
        
        "#c9b458": [
            "Something is present, and that is enough.",
            "You don’t need to follow this yet.",
            "You can stay with the awareness only.",
            "There is no need to act on this.",
            "This can unfold without direction.",
            "You can observe without engaging."
        ],
        
        "#8ab4a8": [
            "Your system is finding its balance.",
            "This can settle naturally.",
            "There is nothing to adjust here.",
            "You can rest in this state.",
            "This moment is already enough.",
            "You are allowed to stay here."
        ],
        
        "#e6c7a1": [
            "You are supported in this moment.",
            "There is nothing required of you here.",
            "This space can hold you.",
            "You can let yourself be here.",
            "There is no need to move away from this.",
            "You are safe to remain."
        ]
    ]
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Theme.templeParchment
                .ignoresSafeArea()
            
            // 🔊 SOUND ICON (SAFE VERSION)
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        
                        if isPlaying {
                            MusicPlayer.shared.stopSound()
                            isPlaying = false
                        } else {
                            let freq = suggestedFrequency ?? "432hz"
                            MusicPlayer.shared.playFrequency(freq)
                            currentFrequency = freq
                            isPlaying = true
                        }
                        
                    } label: {
                        Image(systemName: isPlaying ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .foregroundStyle(
                                suggestedFrequency != nil
                                ? Theme.brandBlue
                                : Theme.textSecondary
                            )
                            .shadow(
                                color: suggestedFrequency != nil ? Theme.goldGlow : .clear,
                                radius: 8
                            )
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.textSecondary)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.5))
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
            }
            
            VStack(spacing: 30) {
                
                Spacer()
                
                Text("What is present for you right now?")
                    .font(Theme.sectionTitle)
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
              
                
                // 🎨 COLOURS
                
                HStack(spacing: 16) {
                    tone("#5f6368")
                    tone("#9aa0a6")
                    tone("#c7a6a1")
                    tone("#c9b458")
                    tone("#8ab4a8")
                    tone("#e6c7a1")
                }
                .onAppear {
                    
                    if let saved = UserDefaults.standard.string(forKey: "lastStillColor") {
                        selectedHex = saved
                        
                    }
                }
                
                // 🌿 ACKNOWLEDGEMENT
                
                if showAcknowledgement {
                    
                    VStack(spacing: 20) {
                        
                        Text(currentAcknowledgement)
                            .opacity(showAcknowledgement ? 1 : 0)
                            .animation(.easeIn(duration: 1.2), value: showAcknowledgement)
                            .font(Theme.bodyText)
                            .foregroundStyle(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                        Circle()
                            .fill(Color(hex: selectedHex ?? "#cccccc"))
                            .frame(width: 120, height: 120)
                            .opacity(0.5)
                            .scaleEffect(showAcknowledgement ? 1.15 : 0.9)
                            .animation(
                                .easeInOut(duration: 4)
                                    .repeatForever(autoreverses: true),
                                value: showAcknowledgement
                            )
                    }
                }
                
                // 🌿 CHOICE
                
                if showChoice {
                    
                    VStack(spacing: 18) {
                        
                        Text("You can stay here… or gently explore what’s held.")
                            .font(Theme.bodyText)
                            .foregroundStyle(Theme.textSecondary)
                        
                        Button("Choose again") {
                            withAnimation {
                                selectedHex = nil
                                showChoice = false
                            }
                        }
                        
                        Spacer().frame(height: 100)
                        
                        HStack(spacing: 40) {

                            // 🔵 DISCOVERY
                            Button {
                                navigateToDiscovery = true
                            } label: {
                                VStack {
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                colors: [
                                                    Theme.brandBlue.opacity(0.9),
                                                    Theme.brandBlue.opacity(0.6),
                                                    Theme.brandBlue.opacity(0.2)
                                                ],
                                                center: .center,
                                                startRadius: 5,
                                                endRadius: 60
                                            )
                                        )
                                        .shadow(color: Theme.goldGlow, radius: 12)
                                        .frame(width: 70, height: 70)
                                        .scaleEffect(showChoice ? 1.05 : 0.95)
                                        .animation(
                                            .easeInOut(duration: 3)
                                            .repeatForever(autoreverses: true),
                                            value: showChoice
                                        )

                                    Text("Understand")
                                        .font(Theme.smallText)
                                        .foregroundStyle(Theme.textPrimary)
                                }
                            }

                            // 🟣 BREATH
                            Button {
                                navigateToBreathe = true
                            } label: {
                                VStack {
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                colors: [
                                                    Theme.brandBlue.opacity(0.9),
                                                    Theme.brandBlue.opacity(0.5),
                                                    Theme.brandBlue.opacity(0.15)
                                                ],
                                                center: .center,
                                                startRadius: 5,
                                                endRadius: 60
                                            )
                                        )
                                        .shadow(color: Theme.goldGlow, radius: 12)
                                        .frame(width: 70, height: 70)
                                        .scaleEffect(showChoice ? 1.05 : 0.95)
                                        .animation(
                                            .easeInOut(duration: 3)
                                            .repeatForever(autoreverses: true),
                                            value: showChoice
                                        )

                                    Text("Breathe")
                                        .font(Theme.smallText)
                                        .foregroundStyle(Theme.textPrimary)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                Text("This space offers reflection, not therapy.")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textSecondary)
            }
        }
    
    .navigationDestination(isPresented: $navigateToDiscovery) {
        DiscoveryGroundView()
    }
    .toolbar(.hidden, for: .tabBar)
    }

    
    
    // MARK: - Tone Button
    
    private func tone(_ hex: String) -> some View {
        
        Circle()
            .fill(Color(hex: hex))
            .frame(width: 44, height: 44)
            .shadow(color: Color.black.opacity(0.08), radius: 6, y: 3)
            .shadow(
                color: selectedHex == hex ? Theme.goldGlow.opacity(0.4) : .clear,
                radius: 10
            )
            .scaleEffect(selectedHex == hex ? 1.15 : 1.0)
            .animation(.easeInOut(duration: 0.25), value: selectedHex)
        
            .onTapGesture {
                let impact = UIImpactFeedbackGenerator(style: .soft)
                impact.prepare()
                impact.impactOccurred()
                
                selectedHex = hex
                
                // 🌿 Suggest frequency (no auto play)

                switch hex {
                case "#5f6368": suggestedFrequency = "432hz"
                case "#9aa0a6": suggestedFrequency = "417hz"
                case "#c7a6a1": suggestedFrequency = "528hz"
                case "#c9b458": suggestedFrequency = "432hz"
                case "#8ab4a8": suggestedFrequency = "528hz"
                case "#e6c7a1": suggestedFrequency = "888hz"
                default: suggestedFrequency = nil
                }
                
                // 🔊 Auto play suggested frequency (if already playing)

                if isPlaying {
                    
                    let newFrequency = suggestedFrequency ?? "432hz"
                    
                    // Only change if different frequency
                    if currentFrequency != newFrequency {
                        MusicPlayer.shared.playFrequency(newFrequency)
                        currentFrequency = newFrequency
                    }
                }
                
                UserDefaults.standard.set(hex, forKey: "lastStillColor")
                
                let key = "colorCount_\(hex)"
                let current = UserDefaults.standard.integer(forKey: key)
                UserDefaults.standard.set(current + 1, forKey: key)
                
                if let options = acknowledgements[hex] {
                    currentAcknowledgement = options.randomElement() ?? ""
                }
                
                withAnimation {
                    showAcknowledgement = true
                    showChoice = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                    
                    withAnimation(.easeOut(duration: 2.0)) {
                        showAcknowledgement = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                         withAnimation(.easeIn(duration: 1.2)) {
                             showChoice = true
                        }
                    }
                }
            }
    }
}
