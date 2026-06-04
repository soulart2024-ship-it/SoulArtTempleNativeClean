import SwiftUI
import UIKit
import AVKit

struct EmotionDecoderView: View {
    
    @EnvironmentObject var store: DiscoveryStore
    @EnvironmentObject var appState: AppState
    
    @Environment(\.dismiss) var dismiss
    
    @State private var currentStep = 2
    @State private var selectedWord: String? = nil
    @State private var selectedEmotion: String? = nil
    @State private var releasedEmotion: String = "Unknown"
    @State private var pulse = false
    @State private var isInhaling = true
    @State private var orbOpacity: Double = 1
    @State private var player: AVPlayer? = nil
    @State private var customMessage: String? = nil
    @State private var showDeeper = false
    @State private var showUnidentified = false
    @State private var discoveryCategory: String = "Unknown"
    @State private var revealEmotion: String = ""
    @State private var isRevealing = false
    @State private var glowPulse = false
    @State private var goToJournal = false
    @State private var isBurning = false
    @State private var resetID = UUID()
    @State private var showPaywall = false
    
    
    private let haptic = UIImpactFeedbackGenerator(style: .soft)
    
    let category: String
    let count: Int
    let hasLayers: Bool
    var calibratedFrequency: Int? = nil
    
    
    var body: some View {
        ZStack {
            
            Theme.templeBackground.ignoresSafeArea()
            Theme.decoderParchment.ignoresSafeArea()
            
            ScrollView {
                
                VStack(spacing: 24) {
                    
                    discoveryHeader
                    
                    Text("Step \(currentStep) of 7")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary.opacity(0.5))
                    
                    stepContent
                    
                    
                }
                .padding()
            }
            .navigationDestination(isPresented: $goToJournal) {
                JournalView(
                    emotion: releasedEmotion,
                    replacementWord: selectedWord ?? "",
                    affirmation: ""
                )
            }
        }
        .onAppear {
            discoveryCategory = category
        }
        .sheet(isPresented: $showPaywall, onDismiss: {
            if PurchaseManager.shared.hasUnlockedFullAccess {
                NotificationCenter.default.post(name: NSNotification.Name("ReturnToHome"), object: nil)
            }
        }) {
            NavigationStack {
                PaywallView()
            }
        }
    }
}


// MARK: - HEADER
extension EmotionDecoderView {

    var discoveryHeader: some View {
        VStack(spacing: 6) {

            // 🌿 TOP LABEL
            Text(headerLabel)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary.opacity(0.6))
                .animation(.easeInOut(duration: 0.4), value: currentStep)

            // 🌿 MAIN VALUE — burns away at step 4
            ZStack {

                // BURN LAYER — emotion dissolving
                if currentStep == 4, let emotion = selectedEmotion {
                    Text(emotion)
                        .font(Theme.sectionTitle)
                        .foregroundStyle(
                            isBurning
                            ? Color(red: 0.75, green: 0.40, blue: 0.20)
                            : Theme.textPrimary
                        )
                        .opacity(isBurning ? 0 : 1)
                        .scaleEffect(isBurning ? 1.1 : 1.0)
                        .offset(y: isBurning ? -20 : 0)
                        .blur(radius: isBurning ? 8 : 0)
                        .animation(.easeInOut(duration: 1.4), value: isBurning)
                } else {
                    Text(headerValue)
                        .font(Theme.sectionTitle)
                        .foregroundStyle(Theme.textPrimary)
                        .opacity(headerValue.isEmpty ? 0 : 1)
                        .animation(.easeInOut(duration: 0.5), value: headerValue)
                }
            }
            .frame(minHeight: 28)

            // 🌿 SUBTITLE
            Text(headerSubtitle)
                .font(Theme.smallText)
                .foregroundStyle(Theme.textSecondary.opacity(0.6))
                .multilineTextAlignment(.center)
                .animation(.easeInOut(duration: 0.4), value: currentStep)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.templeParchment.opacity(0.5))
        )
        .padding(.horizontal)
    }

    // 🌿 HEADER LABEL — top small text
    var headerLabel: String {
        switch currentStep {
        case 2: return "Working with"
        case 3: return "You identified"
        case 4: return "Releasing"
        case 5: return "Now replacing"
        case 6: return "Sealing in"
        case 7: return "Session complete"
        default: return "Working with"
        }
    }

    // 🌿 HEADER VALUE — main text
    var headerValue: String {
        switch currentStep {
        case 2: return discoveryCategory == "Unknown" ? "—" : discoveryCategory
        case 3: return selectedEmotion ?? "—"
        case 4: return selectedEmotion ?? "—"
        case 5: return "—"
        case 6: return selectedWord ?? "—"
        case 7:
            let emotion = releasedEmotion == "Unknown" ? "—" : releasedEmotion
            let word = selectedWord ?? "—"
            return "\(emotion) → \(word)"
        default: return discoveryCategory
        }
    }

    // 🌿 HEADER SUBTITLE — bottom small text
    var headerSubtitle: String {
        switch currentStep {
        case 2: return categoryDescription(for: discoveryCategory)
        case 3: return "Notice where this sits in your body"
        case 4: return "Let it dissolve"
        case 5: return "Choose what to invite in"
        case 6: return "Feel it settle"
        case 7: return "Beautiful work"
        default: return ""
        }
    }
}


// MARK: - STEP SWITCH
extension EmotionDecoderView {
    
    @ViewBuilder
    var stepContent: some View {
        switch currentStep {
        case 2: identifyStepView()
        case 3: acknowledgeStepView()
        case 4: releaseStepView()
        case 5: replaceStepView()
        case 6: sealStepView()
        case 7: completeStepView()
        default: identifyStepView()
        }
    }
}

// MARK: - STEP 2
extension EmotionDecoderView {
    
    func identifyStepView() -> some View {
        
        let emotions = [
            "Overwhelm","Anxiety","Sadness","Anger",
            "Fear","Rejection","Guilt","Shame",
            "Confusion","Loneliness","Pressure","Emptiness"
        ]
        
        return VStack(alignment: .leading, spacing: 20) {
            
            Text("What feels most present right now?")
                .font(.title3.weight(.medium))
                .foregroundStyle(Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            Text("Identify what is ready to be released")
                .font(.title3.weight(.medium))
                .foregroundStyle(Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            Text("Use your body's response to guide you. Move slowly through the options and notice what resonates.")
                .foregroundStyle(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            Text("Statement:")
                .font(.subheadline.weight(.medium))
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            Text("\"I would like to identify what is present and ready for release.\"")
                .italic()
                .foregroundStyle(Theme.textSecondary.opacity(0.9))
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            Text("If nothing stands out, continue to the deeper layers below.")
                .font(.footnote)
                .foregroundStyle(Theme.textSecondary.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            HStack(alignment: .top, spacing: 16) {
                
                VStack(spacing: 24) {
                    ForEach(1...6, id: \.self) { row in
                        Text("\(row)")
                            .font(.caption2)
                            .foregroundStyle(Theme.textSecondary.opacity(0.4))
                            .frame(height: 135)
                    }
                }
                
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(minimum: 140), spacing: 16),
                        GridItem(.flexible(minimum: 140), spacing: 16)
                    ],
                    spacing: 14
                ) {
                    ForEach(emotions, id: \.self) { emotion in
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Theme.templeParchment)
                                .overlay(
                                    Image("still_art")
                                        .resizable()
                                        .scaledToFill()
                                        .opacity(0.18)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                )
                                .shadow(color: Color.white.opacity(0.5), radius: 2, x: -2, y: -2)
                                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
                            
                            if isRevealing && revealEmotion == emotion {
                                Text(revealEmotion)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(Theme.textPrimary.opacity(0.85))
                            }
                            
                            if selectedEmotion == emotion {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Theme.brandBlue.opacity(0.25))
                                    .blur(radius: 12)
                            }
                        }
                        .frame(height: 135)
                        .scaleEffect(selectedEmotion == emotion ? 1.04 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: selectedEmotion)
                        .onTapGesture {
                            Haptics.light()
                            withAnimation(.easeInOut(duration: 0.15)) {
                                isRevealing = true
                                revealEmotion = emotion
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                Haptics.medium()
                                selectedEmotion = emotion
                                customMessage = nil
                                withAnimation { isRevealing = false }
                                withAnimation(.easeInOut(duration: 0.5)) { currentStep = 3 }
                            }
                        }
                    }
                }
            }
            .id(resetID)
            .padding(.horizontal, 10)
            
            Divider().padding(.vertical, 4)
            
            // 🌿 DEEPER LAYERS TOGGLE
            Button {
                let impact = UIImpactFeedbackGenerator(style: .soft)
                impact.impactOccurred()
                withAnimation { showDeeper.toggle() }
            } label: {
                Text("Nothing resonate yet? Tap to explore deeper layers")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(Theme.deepBrown)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .multilineTextAlignment(.center)
            }
            
            if showDeeper {
                Text("Sometimes what's underneath is quieter.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                
                HStack(alignment: .top, spacing: 12) {
                    VStack(spacing: 28) {
                        ForEach(1...4, id: \.self) { row in
                            Text("\(row)")
                                .font(.caption2)
                                .foregroundStyle(Theme.textSecondary.opacity(0.4))
                                .frame(height: 135)
                        }
                    }
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(minimum: 140), spacing: 16),
                            GridItem(.flexible(minimum: 140), spacing: 16)
                        ],
                        spacing: 14
                    ) {
                        let deeperEmotions = [
                            "Insecurity","Resentment","Helplessness","Loneliness",
                            "Overwhelm","Disappointment","Betrayal","Unlovable"
                        ]
                        ForEach(deeperEmotions, id: \.self) { emotion in
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Theme.templeParchment)
                                    .overlay(
                                        Image("still_art")
                                            .resizable()
                                            .scaledToFill()
                                            .opacity(0.16)
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                    )
                                if isRevealing && revealEmotion == emotion {
                                    Text(revealEmotion)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(Theme.textPrimary.opacity(0.85))
                                }
                            }
                            .frame(height: 135)
                            .onTapGesture {
                                Haptics.light()
                                withAnimation { isRevealing = true; revealEmotion = emotion }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    selectedEmotion = emotion
                                    currentStep = 3
                                    isRevealing = false
                                }
                            }
                        }
                    }
                }
            }
            
            // 🌿 UNIDENTIFIABLE - single button at bottom
                        Divider().padding(.vertical, 4).opacity(showDeeper ? 1 : 0)
            Text("Still cannot identify?")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Theme.deepBrown)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .opacity(showDeeper ? 1 : 0)
            Button {
                Haptics.light()
                selectedEmotion = "Unidentifiable"
                customMessage = "Sometimes the body holds what the mind cannot name. That is enough."
                withAnimation(.easeInOut(duration: 0.5)) { currentStep = 3 }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 20))
                        .foregroundStyle(Theme.textSecondary.opacity(0.5))
                    Text("Unidentifiable")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(Theme.deepBrown)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.templeParchment)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
                        .opacity(showDeeper ? 1 : 0)
                        
                        if selectedEmotion != nil {
                VStack(alignment: .leading, spacing: 8) {
                    Text("This is a common stored emotional state.")
                    Text("Notice where this sits in your body.")
                    Text("No need to analyse — just observe.")
                        .foregroundStyle(Theme.textSecondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Theme.rootSoft.opacity(0.2))
                )
            }
        }
        .padding(.bottom, 80)
    }


    
    // MARK: - STEP 3
    
    func acknowledgeStepView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Acknowledge this emotion")
                .font(.title3.weight(.medium))
                .foregroundStyle(Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding(.top, 6)
            
            if let emotion = selectedEmotion {
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("You have identified:")
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding(.top, 6)
                    
                    Text(emotion)
                        .font(.title2.bold())
                        .foregroundStyle(Theme.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding(.top, 6)
                    
                    if let customMessage {
                        Text(customMessage)
                            .foregroundStyle(Theme.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                            .padding(.top, 6)
                    } else {
                        Text("This is a common stored emotional state.")
                            .foregroundStyle(Theme.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                            .padding(.top, 6)
                    }
                    
                    Text("It is safe to acknowledge it without judgement.")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    
                    Text("Simply notice where it sits in your body.")
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding(.top, 6)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    Text("Take a few slow breaths before you continue")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary.opacity(0.9))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding(.top, 6)
                    
                    Text(isInhaling ? "Inhale…" : "Exhale…")
                        .font(.body.weight(.medium))
                        .foregroundStyle(Theme.textPrimary)
                        .opacity(isInhaling ? 1 : 0.6)
                        .animation(.easeInOut(duration: 1.2), value: isInhaling)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack {
                        Spacer()
                        
                        ZStack {
                            
                            Circle()
                                .fill(Theme.rootActive.opacity(0.25))
                                .frame(width: 160, height: 160)
                                .scaleEffect(pulse ? 1.2 : 0.8)
                                .blur(radius: 20)
                            
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            Theme.rootActive,
                                            Theme.rootActive.opacity(0.7),
                                            Theme.rootSoft
                                        ]),
                                        center: .center,
                                        startRadius: 10,
                                        endRadius: 80
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .scaleEffect(isInhaling ? 1.15 : 0.9)
                                .animation(.easeInOut(duration: 2.8), value: isInhaling)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    .onAppear {
                        pulse = true
                        
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                            isInhaling.toggle()
                            
                            if currentStep == 4 {
                                if isInhaling {
                                    haptic.impactOccurred(intensity: 0.7)
                                } else {
                                    haptic.impactOccurred(intensity: 0.3)
                                }
                            }
                        }
                    }
                    .animation(
                        .easeInOut(duration: 2.8)
                        .repeatForever(autoreverses: true),
                        value: pulse
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Theme.rootSoft.opacity(0.2))
                )
                
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentStep = 4
                    }
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.deepBrown)
                        .foregroundStyle(.white)
                        .cornerRadius(14)
                }
                
            } else {
                
                Text("Return to Step 2 and select an emotion.")
                    .foregroundStyle(Theme.warmParchment)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.top, 6)
            }
        }
    }
    
    // MARK: STEP 4 — RELEASE

        func releaseStepView() -> some View {

            return VStack(alignment: .leading, spacing: 20) {

                Text("Release \(selectedEmotion ?? "Emotion")")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(Theme.warmParchment)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .id(selectedEmotion)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))

                Text("Place your awareness on your body. Hold the intention to release.")
                    .foregroundStyle(Theme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)

                Text("Tap or gently swipe through your centre line to release.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)

                // 🎥 VIDEO VIEW
                Group {
                    if let player = player {
                                            ZStack {
                                                // 🌿 PARCHMENT BACKGROUND
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(Theme.warmParchment)
                                                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
                                                
                                                // 🌿 SOFT GOLD BORDER
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Theme.goldSoft.opacity(0.3), lineWidth: 1)
                                                
                                                VStack(spacing: 8) {
                                                    // 🎥 VIDEO
                                                    VideoPlayer(player: player)
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 180)
                                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                                        .padding(.horizontal, 8)
                                                        .padding(.top, 8)
                                                    
                                                    // 🌿 LABEL
                                                    Text("Swipe gently from top of lip to base of your head")
                                                        .font(Theme.smallText)
                                                        .foregroundStyle(Theme.textSecondary.opacity(0.7))
                                                        .padding(.bottom, 10)
                                                }
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 240)
                                        } else {
                        VStack(spacing: 12) {
                            Image(systemName: "hand.draw")
                                .font(.system(size: 40))
                                .foregroundStyle(Theme.textSecondary.opacity(0.5))
                            Text("Gently swipe from the top of your head\ndown through your centre line.")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Theme.templeParchment)
                        )
                    }
                }
                .onAppear {
                    if player == nil {
                        if let url = Bundle.main.url(forResource: "meridianSwipe", withExtension: "mp4") {
                            let newPlayer = AVPlayer(url: url)
                            newPlayer.isMuted = true
                            newPlayer.play()

                            NotificationCenter.default.addObserver(
                                forName: .AVPlayerItemDidPlayToEndTime,
                                object: newPlayer.currentItem,
                                queue: .main
                            ) { _ in
                                newPlayer.seek(to: .zero)
                                newPlayer.play()
                            }

                            player = newPlayer
                        }
                    }
                }

                Spacer(minLength: 10)

                // 🔮 ORB
                ZStack {

                    Circle()
                        .fill(Theme.rootActive.opacity(0.25))
                        .frame(width: 180, height: 180)
                        .scaleEffect(isInhaling ? 1.3 : 0.8)
                        .animation(.easeInOut(duration: 2.8), value: isInhaling)
                        .blur(radius: 30)

                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Theme.rootActive,
                                    Theme.rootActive.opacity(0.7),
                                    Theme.rootSoft
                                ]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 90
                            )
                        )
                        .frame(width: 120, height: 120)
                        .opacity(orbOpacity)
                        .scaleEffect(isInhaling ? 1.15 : 0.9)
                        .animation(.easeInOut(duration: 2.8), value: isInhaling)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .onAppear {
                    pulse = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        pulse = true
                    }
                    orbOpacity = 1
                }
                .onTapGesture {

                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.prepare()
                    impact.impactOccurred()

                    withAnimation(.easeOut(duration: 0.6)) {
                        pulse = false
                        orbOpacity = 0
                        isBurning = true
                    }


                    releasedEmotion = selectedEmotion ?? category
                    store.reduceCount(for: category)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        currentStep += 1
                    }
                }

                // 🔘 CONTINUE BUTTON
                Button {

                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.prepare()
                    impact.impactOccurred()

                    withAnimation(.easeOut(duration: 0.6)) {
                        pulse = false
                        orbOpacity = 0
                        isBurning = true
                    }


                    releasedEmotion = selectedEmotion ?? category
                    store.reduceCount(for: category)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        currentStep += 1
                    }

                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.deepBrown)
                        .foregroundStyle(.white)
                        .cornerRadius(14)
                }

            }
        }

    // MARK: STEP 5 — REPLACE
    func replaceStepView() -> some View {
        
        let words = [
            "Peace","Power","Worthiness","Love",
            "Joy","Freedom","Safety","Trust",
            "Courage","Clarity","Strength","Acceptance"
        ]
        
        return VStack(alignment: .leading, spacing: 20) {
            
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
            
            // 🌿 GRID + ROW NUMBERS
            HStack(alignment: .top, spacing: 16) {
                
                VStack(spacing: 24) {
                    ForEach(1...6, id: \.self) { row in
                        Text("\(row)")
                            .font(.caption2)
                            .foregroundStyle(Theme.textSecondary.opacity(0.4))
                            .frame(height: 135)
                    }
                }
                
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(minimum: 140), spacing: 16),
                        GridItem(.flexible(minimum: 140), spacing: 16)
                    ],
                    spacing: 14
                ) {
                    
                    ForEach(words, id: \.self) { word in
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Theme.templeParchment)
                                .overlay(
                                    Image("still_art")
                                        .resizable()
                                        .scaledToFill()
                                        .opacity(0.15)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                )
                                .shadow(color: Color.white.opacity(0.6), radius: 2, x: -2, y: -2)
                                .shadow(color: Color.black.opacity(0.12), radius: 6, x: 3, y: 4)
                            
                            Text(word)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(Theme.textPrimary.opacity(0.85))
                            
                            if selectedWord == word {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(frequencyColor(for: word).opacity(0.28))
                                    .blur(radius: 16)
                                    .opacity(0.9)
                            }
                        }
                        .frame(height: 120)
                        .scaleEffect(selectedWord == word ? 1.04 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: selectedWord)
                        
                        .onTapGesture {
                            Haptics.light()
                            selectedWord = word
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            
            // 🌿 AFTER SELECTION
            if let word = selectedWord {
                
                VStack(spacing: 6) {
                    
                    Text("Let this feeling settle into your body")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    
                    Text("I now invite the frequency of \(word)")
                        .foregroundStyle(Theme.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 6)
                
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentStep = 6
                    }
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.deepBrown)
                        .foregroundStyle(.white)
                        .cornerRadius(14)
                }
                .padding(.top, 12)
            }
        }
    }
    

    // MARK: STEP 6 — SEAL STEP with ORB
    func sealStepView() -> some View {
        
        return VStack(spacing: 16) {
            
            // 🌿 ORB + TEXT BLOCK
            VStack(spacing: 24) {
                
                ZStack {
                                    
                                    let orbColor = frequencyColor(for: selectedWord ?? "")
                                    
                                    Circle()
                                        .fill(orbColor.opacity(0.25))
                                        .frame(width: 200, height: 200)
                                        .scaleEffect(pulse ? 1.25 : 0.9)
                                        .blur(radius: 30)
                                    
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                gradient: Gradient(colors: [
                                                    orbColor,
                                                    orbColor.opacity(0.7),
                                                    orbColor.opacity(0.3)
                                                ]),
                                                center: .center,
                                                startRadius: 10,
                                                endRadius: 90
                                            )
                                        )
                                        .frame(width: 140, height: 140)
                                        .scaleEffect(pulse ? 1.08 : 0.95)
                                }
                .onAppear {
                    pulse = true
                }
                .animation(
                    .easeInOut(duration: 2)
                    .repeatForever(autoreverses: true),
                    value: pulse
                )
                
                VStack(spacing: 8) {
                    
                    Text("Root Chakra Activated")
                        .font(.headline)
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text("Grounding light anchors into your body")
                    Text("Feel strength, warmth, and harmony rise")
                }
                .font(.body)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
            }
            
            // 🔘 CONTINUE BUTTON
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentStep = 7
                }
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.success)
                    .foregroundStyle(.white)
                    .cornerRadius(14)
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }
    
    // MARK: STEP 7 — COMPLETE
    func completeStepView() -> some View {
        
        return VStack(spacing: 24) {
            
            // 🌿 TITLE
            Text("Beautiful Work")
                .font(.title.bold())
                .foregroundStyle(Theme.success)
            
            // 🌿 SUMMARY CARD
            VStack(alignment: .leading, spacing: 12) {
                
                Text("Release Summary")
                    .font(Theme.sectionTitle)
                    .foregroundStyle(Theme.textOnParchment)
                
                HStack {
                    Text("Emotion:")
                        .foregroundStyle(Theme.textOnParchment)
                    Spacer()
                    Text(releasedEmotion)
                        .foregroundStyle(Theme.textOnParchment)
                }
                
                HStack {
                    Text("Replaced With:")
                        .foregroundStyle(Theme.textOnParchment)
                    Spacer()
                    Text(selectedWord ?? "-")
                        .foregroundStyle(Theme.textOnParchment)
                }
                
                HStack {
                    Text("Date:")
                        .foregroundStyle(Theme.textOnParchment)
                    Spacer()
                    Text(Date(), style: .date)
                        .foregroundStyle(Theme.textOnParchment)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Theme.templeParchment)
            )

            
          
            
            // JOURNAL
                        Button {
                            saveSession()
                            navigateToJournal()
                        } label: {
                Text("Journal This Session")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.deepBrown)
                    .foregroundStyle(Theme.warmParchment)
                    .cornerRadius(14)
            }

            // COMPLETE → HOME
            Button {
                if releasedEmotion != "Unknown" {
                    saveSession()
                }
                
                // 📊 INCREMENT SESSION COUNTER
                print("📊 Before increment: \(SessionCounter.shared.sessionCount)")
                SessionCounter.shared.incrementSession()
                print("📊 After increment: \(SessionCounter.shared.sessionCount)")
                SessionCounter.shared.refreshStatus()

                // Check if limit reached - show paywall instead of going back
                if !SessionCounter.shared.canStartNewSession() && !PurchaseManager.shared.hasUnlockedFullAccess {
                    showPaywall = true
                } else {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        appState.returnToHome = true
                    }
                }
        
            } label: {
                Text("Complete")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.deepBrown)
                    .foregroundStyle(Theme.warmParchment)
                    .cornerRadius(14)
            }

            // RELEASE AGAIN → CATEGORY SELECTION
            Button {
                if SessionCounter.shared.canStartNewSession() {
                    dismiss()
                } else {
                    showPaywall = true
                }
            } label: {
                Text("Release Another Emotion")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Theme.deepBrown.opacity(0.4), lineWidth: 1)
                    )
                    .foregroundStyle(Theme.deepBrown)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }
    // MARK: - HELPERS (REQUIRED)

    func categoryDescription(for category: String) -> String {
        switch category {
            
        case "Common":
            return "Present-life emotional patterns ready to be released."
            
        case "Ancestral":
            return "Inherited emotional imprints carried through lineage."
            
        case "Heart Shadows":
            return "Deeper emotional layers held within the heart space."
            
        case "Etheric":
            return "Subtle energetic imprints beyond the physical body."
            
        case "Aura / Field":
            return "Emotions held within your energetic field."
            
        case "DNA":
            return "Encoded emotional memory within your biology."
            
        case "Third Trimester":
            return "Pre-birth emotional experiences stored in the body."
            
        case "Twin (Dual)":
            return "Shared or mirrored emotional experiences."
            
        case "Deeply Hidden":
            return "Emotions stored beyond conscious awareness."
            
        case "Stealth":
            return "Quiet emotional patterns that subtly influence behaviour."
            
        case "Body Coded":
            return "Emotions stored directly in physical body areas."
            
        case "Unidentified":
            return "An emotion present without needing to be named."
            
        default:
            return ""
        }
    }


    func frequencyColor(for word: String) -> Color {
        switch word {
            
        case "Peace": return .green
        case "Power": return .red
        case "Worthiness": return .pink
        case "Love": return .pink
        case "Joy": return .yellow
        case "Freedom": return .blue
        case "Safety": return .orange
        case "Trust": return .teal
        case "Courage": return .orange
        case "Clarity": return .indigo
        case "Strength": return .red
        case "Acceptance": return .purple
            
        default:
            return Theme.brandBlue
        }
    }
    
    // MARK: - SESSION HELPERS
    
    func saveSession() {
            store.addSession(
                emotion: releasedEmotion,
                replacement: selectedWord ?? "Balance",
                category: discoveryCategory,
                date: Date(),
                calibratedFrequency: calibratedFrequency        
        )
    }
    
    func navigateToJournal() {
        goToJournal = true
    }

    func resetSession() {
        selectedEmotion = nil
        selectedWord = nil
        releasedEmotion = "Unknown"
        customMessage = nil
        revealEmotion = ""
        isRevealing = false
        isBurning = false
        orbOpacity = 1
        pulse = false
        showDeeper = false
        currentStep = 2
        resetID = UUID() // Force grid to reset
    }
    
    // MARK: - ORB (OUTSIDE MAIN VIEW)
    struct FrequencyOrb: View {
        
        var color: Color
        var label: String
        var action: () -> Void
        
        var body: some View {
            VStack {
                Circle()
                    .fill(color)
                    .frame(width: 56, height: 56)
                    .onTapGesture { action() }
                
                Text(label)
            }
        }
    }
}
