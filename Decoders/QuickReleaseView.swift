import SwiftUI
import AVKit

struct QuickReleaseView: View {
 
    let category: String
    
    @EnvironmentObject var discoveryStore: DiscoveryStore
    
 
    var count: Int = 0
    var sessionId: UUID?
    
    private let emotions = [
        "Fear","Guilt","Shame","Grief",
        "Anger","Despair","Abandonment","Rejection",
        "Hopelessness","Powerlessness","Anxiety","Worthlessness",
        "Unidentifiable","Overwhelm"
    ]
    
    @State private var selectedEmotionIndex: Int? = nil
    @State private var showOrb = false
    @State private var countdown = 30
    @State private var orbScale: CGFloat = 1.0
    @State private var showJournal = false
    @State private var navigateToBurn = false
    @State private var orbEmotion: String = ""
    @State private var revealEmotion: String = ""
    @State private var isRevealing = false
    @State private var player = AVPlayer()
    @State private var isCalmState = false
    @State private var isVideoPlaying = false
    @State private var shuffledEmotions: [String] = []
 
    // MARK: - 🧭 MAIN VIEW
    var body: some View {
     
        
        
        ZStack {
            
            Theme.templeParchment
                .ignoresSafeArea()
            
            
            
            // MARK: - 🌿 STEP 1: Emotion Grid
            if selectedEmotionIndex == nil {

                ScrollView {

                    VStack(spacing: 24) {

                        Text("Quick Release")
                            .font(Theme.sectionTitle)
                            .foregroundStyle(Theme.textPrimary)

                        Text("Working within: \(category)")
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary.opacity(0.7))

                        Text("""
                        Notice what feels open, neutral, or slightly easier.

                        There is no need to think.
                        Your first response is enough.
                        """)
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        
                        HStack(spacing: 20) {

                            NavigationLink {
                                KinesiologyMiniCourse(startAtModule: 1)
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "sparkles")
                                    Text("Try Guided Check")
                                }
                                .font(Theme.smallText)
                                .foregroundStyle(Theme.textPrimary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Theme.templeParchment)
                                .cornerRadius(10)
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                Haptics.soft()
                            })

                            NavigationLink {
                                KinesiologyMiniCourse(startAtModule: 2)
                            } label: {
                                Text("Watch How to Test")
                                    .font(Theme.smallText)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                        }
                        .padding(.top, 6)

                        // 🌿 COLUMN LABELS
                        HStack {
                            Spacer()

                            Text("A")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary.opacity(0.5))
                                .frame(maxWidth: .infinity)

                            Text("B")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary.opacity(0.5))
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 30)

                        // 🌿 GRID + ROW LABELS
                        HStack(alignment: .top, spacing: 16) {

                            // ROW NUMBERS (MATCH DISCOVERY)
                            VStack(spacing: 24) {
                                ForEach(1...7, id: \.self) { row in
                                    Text("\(row)")
                                        .font(.caption2)
                                        .foregroundStyle(Theme.textSecondary.opacity(0.4))
                                        .frame(height: 135) // ✅ MATCH DISCOVERY
                                }
                            }

                            // GRID (MATCH DISCOVERY)
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(minimum: 140), spacing: 16),
                                    GridItem(.flexible(minimum: 140), spacing: 16)
                                ],
                                spacing: 14
                            ) {

                                let source = shuffledEmotions.isEmpty ? emotions : shuffledEmotions

                                ForEach(Array(source.enumerated()), id: \.element) { index, emotion in

                                    ZStack {

                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Theme.templeParchment)
                                            .overlay(
                                                Image("still_art")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .opacity(0.25)
                                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                            )
                                            .shadow(color: Color.white.opacity(0.6), radius: 2, x: -2, y: -2)
                                            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 3, y: 4)

                                        if isRevealing && revealEmotion == emotion {
                                            Text(revealEmotion)
                                                .font(Theme.smallText)
                                                .foregroundStyle(Theme.textPrimary)
                                        }
                                    }
                                    .frame(height: 135) // ✅ MATCH DISCOVERY
                                    .scaleEffect(isRevealing && revealEmotion == emotion ? 1.04 : 1.0)
                                    .animation(.easeInOut(duration: 0.25), value: isRevealing)

                                    .onTapGesture {

                                        Haptics.light()

                                        withAnimation(.easeInOut(duration: 0.15)) {
                                            isRevealing = true
                                        }

                                        triggerReveal(index: index)

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            Haptics.medium()   // 👈 ADD THIS
                                        
                                        }
                                    }
                                }
                            }
                        }
                        // 👇 THIS IS CRITICAL — matches Discovery spacing
                        .padding(.horizontal, 10)
                    }
                }
                .onAppear {
                    shuffleIfNeeded()
                }
            }
        
            // MARK: - 🔥 STEP 2: Release Guidance
            
            else if let selected = selectedEmotionIndex, !showOrb {
                
                VStack(spacing: 24) {
                    
                    Spacer()
                    
                    VStack(spacing: 6) {
                        
                        Text("You are ready to release")
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary.opacity(0.7))
                        
                        let source = shuffledEmotions.isEmpty ? emotions : shuffledEmotions
                        
                        Text(source[selected])
                            .font(Theme.sectionTitle)
                            .foregroundStyle(Theme.textPrimary)
                    }
                    
                    
                    ZStack {
                        
                        // 🌿 SOFT BACK CARD
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Theme.warmParchment.opacity(0.6))
                            .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
                        
                        // 🎥 VIDEO
                        VideoPlayer(player: player)
                            .cornerRadius(20)
                            .padding(6)
                        
                        // 🌫️ SOFT OVERLAY (before play)
                        if !isVideoPlaying {
                            
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .opacity(0.6)
                            
                            VStack(spacing: 10) {
                                
                                Text("Begin Guidance")
                                    .font(Theme.smallText)
                                    .foregroundStyle(Theme.textSecondary)
                                
                                Button {
                                    if let url = Bundle.main.url(forResource: "meridianSwipe", withExtension: "mp4") {
                                        player = AVPlayer(url: url)
                                        player.play()

                                        Haptics.medium()

                                        withAnimation(.easeInOut(duration: 0.6)) {
                                            isVideoPlaying = true
                                        }
                                    }
                                
                                } label: {
                                    
                                    ZStack {
                                        
                                        // ✨ GOLD HALO
                                        Circle()
                                            .fill(Theme.goldSoft.opacity(0.25))
                                            .frame(width: 70, height: 70)
                                            .blur(radius: 20)
                                        
                                        // ▶️ BUTTON
                                        Circle()
                                            .fill(Theme.deepBrown.opacity(0.85))
                                            .frame(width: 60, height: 60)
                                        
                                        Image(systemName: "play.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 22))
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 220)
                    .padding(.horizontal, 20)
                    
                    Text("Swipe your governing meridian 3 times while holding your intention")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .foregroundStyle(Theme.textSecondary)
                    
                    
                    ZStack {
                        
                        // ✨ GOLD GLOW BEHIND
                        RoundedRectangle(cornerRadius: Theme.buttonRadius)
                            .fill(Theme.goldSoft.opacity(0.18))
                            .frame(height: 60)
                            .blur(radius: 30)
                            
                        Button {
                            Haptics.medium()
                            // ✅ STOP VIDEO BEFORE NAVIGATING
                            player.pause()
                            player.replaceCurrentItem(with: nil)
                            isVideoPlaying = false
                            
                            if let selected = selectedEmotionIndex {
                                orbEmotion = emotions[selected]
                            }
                            
                            navigateToBurn = true
                        } label: {
                            Text("Continue")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.brandBlue)
                                .foregroundStyle(.white)
                                .cornerRadius(Theme.buttonRadius)
                        }
                        .buttonStyle(GoldGlowButtonStyle())
                        .padding(.horizontal, 40)
                    }
                    
                    
                    Spacer()
                }
            }
            
            // MARK: - ✨ STEP 3: Orb Recalibration
            else if showOrb {
                
                let replacementData = replacement(for: orbEmotion)
                let orbVideoName = replacementData.orbVideo
                
                VStack(spacing: 30) {
                    
                    Spacer().frame(height: 40)
                    
                    Text("Returning to Balance")
                        .font(Theme.sectionTitle)
                        .foregroundStyle(Theme.textPrimary.opacity(0.8))
                    
                    Text("Allow your system to settle into calm")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.top, 4)
                    
                    ZStack {
                        
                        // ✨ GOLD HALO (outer aura)
                        Circle()
                            .fill(Theme.goldSoft.opacity(0.18))
                            .frame(width: 240, height: 240)
                            .blur(radius: 50)
                            .scaleEffect(orbScale)
                        
                        // ✨ INNER GOLD GLOW (closer warmth)
                        Circle()
                            .fill(Theme.goldSoft.opacity(0.25))
                            .frame(width: 200, height: 200)
                            .blur(radius: 25)
                            .opacity(0.8)
                        
                        
                        // ⚪ Orb
                        ZStack {
                            VideoPlayer(player: player)
                                .frame(width: 160, height: 160)
                                .clipShape(Circle())
                        }
                        .scaleEffect(orbScale)
                        
                    }
                    .onAppear {
                        Haptics.soft()
                        if let url = Bundle.main.url(forResource: orbVideoName, withExtension: "mp4") {
                            player = AVPlayer(url: url)
                            player.play()
                        }
                        startCountdown()
                        orbScale = 1.15
                        
                        if MusicPlayer.shared.currentTrack == nil {
                            MusicPlayer.shared.playTrack("432hz")
                        }
                    }
                    .animation(
                        .easeInOut(duration: 2.2)
                        .repeatForever(autoreverses: true),
                        value: orbScale
                    )
                    
                    Text("\(countdown)")
                        .font(.system(size: 40))
                        .foregroundStyle(Theme.textSecondary)
                    
                    Text(replacementData.word)
                        .font(Theme.sectionTitle)
                        .foregroundStyle(Theme.textSecondary)
                    
                    Text(replacementData.affirmation)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .foregroundStyle(Theme.textSecondary)
                    
                    Text("Reflect and tune into the moment when you felt this beautiful frequency, hold the feeling in your heart, then swipe to replace and anchor")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .foregroundStyle(Theme.textSecondary)
                    
                    Button {
                        
                        Haptics.success()
                        
                        // ✅ STOP VIDEO
                        player.pause()
                        player.replaceCurrentItem(with: nil)

                        if !orbEmotion.isEmpty {
                            let replacementData = discoveryStore.replacement(for: orbEmotion)

                            discoveryStore.addSession(
                                emotion: orbEmotion,
                                replacement: replacementData.word,
                                category: category,
                                date: Date()
                            )
                        }

                        UserDefaults.standard.set(true, forKey: "hasCompletedFirstRelease")

                        print(discoveryStore.sessions.count)

                        resetSession()

                    } label: {
                        Text("Complete")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.brandBlue)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 40)
                    }
                    
                    Button {
                        showJournal = true
                    } label: {
                        Text("Journal & Reflect")
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                    
                }
                .toolbar(.hidden, for: .tabBar)
            }
        }
        
        // MARK: - 🧭 NAVIGATION
        
        .navigationDestination(isPresented: $showJournal) {
            let replacementData = replacement(for: orbEmotion)

            JournalView(
                emotion: orbEmotion,
                replacementWord: replacementData.word,
                affirmation: replacementData.affirmation
            )
        }
        
        .navigationDestination(isPresented: $navigateToBurn) {
            
            if let selected = selectedEmotionIndex {
                
                let source = shuffledEmotions.isEmpty ? emotions : shuffledEmotions
                
                BurnView(
                    emotion: source[selected],
                    onComplete: { emotion in
                        orbEmotion = emotion
                        
                        withAnimation(.easeInOut(duration: 0.6)) {
                            showOrb = true
                        }
                    }
                )
            }
        }
    }
    // MARK: - 🛠 HELPERS
    
    private func triggerReveal(index: Int) {
        let source = shuffledEmotions.isEmpty ? emotions : shuffledEmotions
        revealEmotion = source[index]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            selectedEmotionIndex = index
            isRevealing = false
        }
    }
    
    private func resetSession() {
        selectedEmotionIndex = nil
        showOrb = false
        countdown = 30
        
        player.pause()
        player.replaceCurrentItem(with: nil)
        isVideoPlaying = false
    }
    
    func startCountdown() {
        countdown = 30
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer.invalidate()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isCalmState = true
                }
            }

        }
        
    }
    
    // MARK: - 📖 CONTENT MAPPING
    private func meaning(for emotion: String) -> String {
        switch emotion {
        case "Fear": return "A sense of holding back, where movement once felt unsafe."
        case "Guilt": return "A weight carried from the past, asking for compassion."
        case "Shame": return "A quiet belief of not being enough, ready to soften."
        case "Grief": return "A deep ache of loss, still moving through the heart."
        case "Anger": return "Energy seeking expression, clarity, or boundary."
        case "Despair": return "A moment where hope felt distant, but not gone."
        case "Abandonment": return "A feeling of being left, calling for inner safety."
        case "Rejection": return "A moment of not feeling chosen, ready to be reclaimed."
        case "Hopelessness": return "A pause in possibility, waiting to reopen."
        case "Powerlessness": return "A sense of lost control, ready to return to self."
        case "Anxiety": return "Energy moving quickly, seeking calm and grounding."
        case "Worthlessness": return "A story of not being valued, ready to dissolve."
        default: return "An energy ready to be seen and released."
        }
    }
    
    private func replacement(for emotion: String) -> (word: String, affirmation: String, orbVideo: String) {
        switch emotion {
            
        case "Fear": return ("Courage", "You may now choose courage.", "solar_chakra")
        case "Guilt": return ("Forgiveness", "You are allowed to forgive yourself.", "heart_chakra")
        case "Shame": return ("Worth", "Your value remains.", "solar_chakra")
        case "Grief": return ("Acceptance", "Acceptance allows the heart to breathe again.", "heart_chakra")
        case "Anger": return ("Discernment", "You may choose clarity and power.", "solar_chakra")
        case "Despair": return ("Hope", "Let hope return.", "heart_chakra")
        case "Abandonment": return ("Self-Love", "You are safe within yourself.", "heart_chakra")
        case "Rejection": return ("Acceptance", "You belong to yourself first.", "heart_chakra")
        case "Hopelessness": return ("Possibility", "Hope opens possibility.", "throat_chakra")
        case "Powerlessness": return ("Strength", "Your strength is still here.", "root_chakra_recalibration")
        case "Anxiety": return ("Calm", "Allow calm to enter the body.", "throat_chakra")
        case "Worthlessness": return ("Value", "Your value is not conditional.", "solar_chakra")
        case "Overwhelm":
            return ("Stability", "You are safe to slow everything down.", "root_chakra_recalibration")
            
        default: return ("Balance", "Return to balance.", "crown_chakra")
        }
    }
    private func shuffleIfNeeded() {
        
        let lastShuffleKey = "lastEmotionShuffle"
        let now = Date()
        
        if let last = UserDefaults.standard.object(forKey: lastShuffleKey) as? Date {
            
            let hours = Calendar.current.dateComponents([.hour], from: last, to: now).hour ?? 0
            
            if hours >= 24 {
                shuffledEmotions = emotions.shuffled()
                UserDefaults.standard.set(now, forKey: lastShuffleKey)
            } else {
                shuffledEmotions = emotions.shuffled() // optional: still shuffle each open
            }
            
        } else {
            shuffledEmotions = emotions.shuffled()
            UserDefaults.standard.set(now, forKey: lastShuffleKey)
        }
    }
}

