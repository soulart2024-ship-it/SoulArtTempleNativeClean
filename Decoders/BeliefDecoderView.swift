import SwiftUI
import UIKit
import AVKit

struct BeliefDecoderView: View {
    
    @EnvironmentObject var store: DiscoveryStore
    @Environment(\.dismiss) var dismiss
    
    @State private var currentStep = 1
    @State private var selectedWord: String? = nil
    @State private var selectedBelief: String? = nil
    @State private var releasedBelief: String = "Unknown"
    @State private var pulse = false
    @State private var isPressed = false
    @State private var breathCount = 0
    @State private var isBreathingIn = true
    @State private var breathTimer: Timer?
    @State private var isBreathComplete = false
    @State private var isInhaling = true
    @State private var orbOpacity: Double = 1
    @State private var player: AVPlayer? = nil
    @State private var customMessage: String? = nil
    @State private var showDeeper = false
    @State private var showUnidentified = false
    
    private let haptic = UIImpactFeedbackGenerator(style: .soft)
    
    let category: String
    let count: Int
    let hasLayers: Bool
    
    var currentCount: Int {
        store.items.first(where: { $0.category == category })?.count ?? count
    }
    
    // MARK: STEP TEXT
    var stepInstruction: String {
        switch currentStep {
        case 1: return "Take a breath and settle into your body."
        case 2: return ""
        case 3: return "Acknowledge this emotion is present."
        case 4: return "Release the emotion gently."
        case 5: return ""
        case 6: return ""
        case 7: return ""
        default: return ""
        }
    }
    
    // MARK: BODY
    var body: some View {
        ZStack {
            
            Theme.decoderParchment
                .ignoresSafeArea()
            
            Theme.brandBlueGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Belief Decoder")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text("Step \(currentStep) of 7")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary)
                    
                    // STEP CONTENT
                    Group {
                        switch currentStep {
                        case 2:
                            identifyStepView
                        case 3:
                            acknowledgeStepView
                        case 4:
                            releaseStepView
                        case 5:
                            replaceStepView
                        case 6:
                            sealStepView
                        case 7:
                            completeStepView
                        default:
                            Text(stepInstruction)
                                .font(.title3.weight(.medium))
                                .foregroundStyle(Theme.textPrimary)
                                .padding(.vertical, 10)
                        }
                    }
                    
                    
                    // CONTINUE BUTTON (ONLY CHANGE IS HERE)
                    
                    if currentStep != 4 {
                        
                        Button {
                            
                            let impact = UIImpactFeedbackGenerator(style: .soft)
                            impact.impactOccurred()
                            
                            if currentStep == 2 && selectedBelief == nil {
                                return
                            }
                            
                            if currentStep < 7 {
                                currentStep += 1
                            } else {
                                currentStep = 1
                                selectedBelief = nil
                                selectedWord = nil
                            }
                            
                        } label: {
                            Text(
                                currentStep == 7 ? "Release Another Belief" :
                                    "Continue"
                            )
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Theme.cardPrimary, Theme.cardSecondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .foregroundStyle(.white)
                            .cornerRadius(14)
                            .scaleEffect(isPressed ? 0.97 : 1.0)
                            .shadow(
                                color: Color.black.opacity(isPressed ? 0.08 : 0.15),
                                radius: isPressed ? 3 : 8,
                                y: isPressed ? 1 : 4
                            )
                        }
                        .buttonStyle(.plain)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        isPressed = true
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        isPressed = false
                                    }
                                }
                        )}
                    
                    // COMPLETE SESSION
                    Button {
                        dismiss()
                    } label: {
                        Text("Complete Session")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.completeFill.opacity(0.7))
                            .foregroundStyle(.white)
                            .cornerRadius(14)
                    }
                }
                .padding()
            }
        }
    }

    // MARK: STEP 3 — ACKNOWLEDGE
    var acknowledgeStepView: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Acknowledge this belief is present.")
            Text("Release the belief gently.")
                .font(.title3.weight(.medium))
                .foregroundStyle(Theme.textPrimary)
            
            if let belief = selectedBelief {
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("You have identified:")
                        .foregroundStyle(Theme.textSecondary)
                    
                    Text(belief)
                        .font(.title2.bold())
                        .foregroundStyle(Theme.textPrimary)
                    
                    if let customMessage = customMessage {
                        Text(customMessage)
                            .foregroundStyle(Theme.textSecondary)
                    } else {
                        Text("Reflect gently")
                            .foregroundStyle(Theme.textSecondary)
                    }
                    Text("When did this belief first take root.")
                    Text("Whose voice does this belief carry.")
                    Text("How has this belief tried to protect you?")
                        .foregroundStyle(Theme.textSecondary)
                    
                    Divider()
                        .padding(.vertical, 8)

                    Text("I acknowledge this belief with compassion.  It no longer serves my highest good")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary.opacity(0.9))

                    Text(isInhaling ? "Inhale…" : "Exhale…")
                        .font(.body.weight(.medium))
                        .foregroundStyle(Theme.textPrimary)
                        .opacity(isInhaling ? 1 : 0.6)
                        .animation(.easeInOut(duration: 1.2), value: isInhaling)
                    
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
                
            } else {
                
                Text("Return to Step 2 and select a belief.")
                    .foregroundStyle(.red)
            }
        }
    }
    // MARK: STEP 4 — RELEASE
    var releaseStepView: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Release the belief")
                .font(.title3.weight(.medium))
                .foregroundStyle(Theme.textPrimary)
            
            Text("Place your awareness on your body. Hold the intention to release.")
                .foregroundStyle(Theme.textSecondary)
            
            Text("Tap or gently swipe through your centre line to release.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary.opacity(0.9))
                .onAppear {
                    if player == nil {
                        if let url = Bundle.main.url(forResource: "meridianSwipe", withExtension: "mp4") {
                            
                            let newPlayer = AVPlayer(url: url)
                            newPlayer.isMuted = true
                            newPlayer.play()
                            
                            // 🔁 LOOP VIDEO
                            NotificationCenter.default.addObserver(
                                forName: .AVPlayerItemDidPlayToEndTime,
                                object: newPlayer.currentItem,
                                queue: .main
                            ) { _ in
                                newPlayer.seek(to: .zero)
                                newPlayer.play()
                            }
                            
                            player = newPlayer
                            player?.isMuted = true
                        }
                    }
                }
            
            // OPTIONAL VIDEO PLACEHOLDER
            
            if let player = player {
                VideoPlayer(player: player)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)  // 👈 THIS IS THE FIX
            } else {
                Text("Loading video...")
                    .frame(height: 220)
            }
            
            Spacer(minLength: 10)
            
            // ORB (interactive)
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
                }
                
                releasedBelief = selectedBelief ?? category
                store.reduceCount(for: category)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    currentStep += 1
                }
            }
            
            
            // Continue button
            Button {
                
                // HAPTIC FEEDBACK
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.prepare()
                impact.impactOccurred()
                
                // VISUAL RELEASE
                withAnimation(.easeOut(duration: 0.6)) {
                    pulse = false
                    orbOpacity = 0
        
                }
                
                // STORE RELEASE
                releasedBelief = selectedBelief ?? category
                store.reduceCount(for: category)
                
                // MOVE TO NEXT STEP (with pause for experience)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    currentStep += 1
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
    }
    
    
    // MARK: STEP 2 — IDENTIFY
    var identifyStepView: some View {
        
        let beliefs = [
            "Worthiness", "Control & Safety", "Love & Connection",
            "Expression", "Vision & Faith", "Divine Alignment",
            "Boundaries & Identity", "Receiving & Abundance"
        ]
        
        return VStack(alignment: .leading, spacing: 20) {
            
            Text("What feels most present right now?")
                .font(.title3.weight(.medium))
                .foregroundStyle(Theme.textPrimary)
            
            Text("Identify what is ready to be released")
                .font(.title3.weight(.medium))
                .foregroundStyle(Theme.textPrimary)

            Text("Use your body’s response to guide you. Move slowly through the options and notice what resonates.")
                .foregroundStyle(Theme.textSecondary)

            Text("Statement:")
                .font(.subheadline.weight(.medium))

            Text("“I would like to identify what is present and ready for release.”")
                .italic()
                .foregroundStyle(Theme.textSecondary.opacity(0.9))

            Text("If nothing stands out, continue to the deeper layers below.")
                .font(.footnote)
                .foregroundStyle(Theme.textSecondary.opacity(0.8))
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 14) {
                
                ForEach(beliefs, id: \.self) { belief in
                    
                    Button {
                        let impact = UIImpactFeedbackGenerator(style: .soft)
                        impact.impactOccurred()
                        
                        selectedBelief = belief
                        customMessage = nil
                        currentStep = 3
                    
                    } label: {
                        
                        Text(belief)
                            .font(.subheadline.bold())
                            .foregroundStyle(Theme.textOnDark)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                ZStack {
                                    
                                    if selectedBelief == belief {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.red.opacity(0.25))
                                            .blur(radius: 12)
                                            .offset(y: 4)
                                    }
                                    
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                colors: [Theme.cardPrimary, Theme.cardSecondary],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                }
                            )
                            .scaleEffect(selectedBelief == belief ? 1.05 : 1.0)
                            .shadow(
                                color: selectedBelief == belief
                                ? Color.black.opacity(0.2)
                                : .clear,
                                radius: 8,
                                y: 4
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Divider().padding(.vertical, 10)

            Button {
                let impact = UIImpactFeedbackGenerator(style: .soft)
                impact.impactOccurred()
                
                withAnimation {
                    showDeeper.toggle()
                }
            } label: {
                Text("Nothing resonate yet? Tap to explore deeper layers")
                    .font(.subheadline.weight(.medium))
            }

            // 🔥 FIXED SECTION STARTS HERE
            if showDeeper {

                Text("Sometimes what’s underneath is quieter.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary.opacity(0.8))
                    .padding(.top, 6)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    
                    ForEach([
                        "Insecurity", "Resentment", "Helplessness", "Loneliness",
                        "Overwhelm", "Disappointment", "Betrayal", "Unlovable"
                    ], id: \.self) { shadow in
                        
                        Button {
                            let impact = UIImpactFeedbackGenerator(style: .soft)
                            impact.impactOccurred()

                            selectedBelief = shadow
                            customMessage = nil
                            currentStep = 3

                        } label: {
                            Text(shadow)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.12))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Theme.cardPrimary.opacity(0.4), lineWidth: 1)
                                )
                        }
                    }
                } // ✅ closes LazyVGrid
                
                Divider().padding(.vertical, 10)
                
                Button {
                    withAnimation {
                        showUnidentified.toggle()
                    }
                } label: {
                    Text("Still nothing?")
                        .font(.subheadline.weight(.medium))
                    Text("That's okay. You don’t need to name it to release it.")
                        .font(.footnote)
                        .foregroundStyle(Theme.textSecondary.opacity(0.8))
                }
                
                if showUnidentified {
                    Text("You can release what is present without needing to name it.")
                        .font(.footnote)
                        .foregroundStyle(Theme.textSecondary.opacity(0.8))
                    
                    Button {
                        let impact = UIImpactFeedbackGenerator(style: .soft)
                        impact.impactOccurred()
                        
                        selectedBelief = "Unidentified"
                        customMessage = "Acceptance is the key to releasing what you cannot identify. It’s okay not to know, but it is ready to let go."
                        currentStep = 3
                        
                    } label: {
                        Text("Release Unidentified Belief")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Theme.cardPrimary,
                                        Theme.cardSecondary.opacity(0.9)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            )
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: Color.black.opacity(0.2), radius: 10, y: 6)
                    }
                    .buttonStyle(.plain)
                        
                    }
            } // ✅ closes showDeeper
            
            if selectedBelief != nil {
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("This is a common stored Belief state.")
                    Text("Notice where this sits in your body.")
                    Text("No need to analyse — just observe.")
                        .foregroundStyle(Theme.textSecondary)
                    
                }
                .font(.body)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Theme.rootSoft.opacity(0.2))
                )
            }
            
        } // ✅ closes main VStack
    }
    
    // MARK: STEP 5 — REPLACE (MATCH STEP 2 STYLE)
    var replaceStepView: some View {
        
        let words = [
                "Self-acceptance", "Trust", "Compassion", "Forgiveness",
                "Truth telling", "Empowerment", "Intuition", "Divine trust",
                "Self-worth", "Open to receive", "Gratitude", "Self-love"
        ]
        
        return VStack(alignment: .leading, spacing: 20) {
            
            Text("Install your new truth")
                .font(.title3.weight(.medium))
                .foregroundStyle(Theme.textPrimary)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 14) {
                
                ForEach(words, id: \.self) { word in
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedWord = word
                        }
                    } label: {
                        
                        Text(word)
                            .font(.subheadline.bold())
                            .foregroundStyle(Theme.textOnDark)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                ZStack {
                                    
                                    // ✨ GOLD GLOW (same behaviour as Step 2)
                                    if selectedWord == word {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color(red: 1.0, green: 0.84, blue: 0.4).opacity(0.45))
                                            .blur(radius: 10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color(red: 1.0, green: 0.84, blue: 0.4).opacity(0.35), lineWidth: 1)
                                            )
                                    }
                                    
                                    // 💜 PURPLE BUTTON (same structure as Step 2)
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.35, green: 0.20, blue: 0.55),
                                                    Color(red: 0.25, green: 0.15, blue: 0.45)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                }
                            )
                            .scaleEffect(selectedWord == word ? 1.05 : 1.0)
                            .shadow(
                                color: selectedWord == word
                                ? Color.black.opacity(0.2)
                                : .clear,
                                radius: 8,
                                y: 4
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            if let word = selectedWord {
                Text("I now invite the frequency of \(word)")
                    .padding()
                    .foregroundStyle(Theme.textPrimary)
            }
        }
    }
    
    // MARK: STEP 6 — ROOT ORB
    var sealStepView: some View {
        
        VStack(spacing: 24) {
            
            ZStack {
                
                Circle()
                    .fill(Theme.rootActive.opacity(0.25))
                    .frame(width: 200, height: 200)
                    .scaleEffect(pulse ? 1.25 : 0.9)
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
                    .frame(width: 140, height: 140)
                    .scaleEffect(pulse ? 1.08 : 0.95)
            }
            .onAppear { pulse = true }
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulse)
            
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
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }
    
    // MARK: STEP 7 — COMPLETE
    var completeStepView: some View {
        
        VStack(spacing: 20) {
            
            Text("Beautiful Work")
                .font(.title.bold())
                .foregroundStyle(Theme.success)
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Release Summary")
                    .font(Theme.sectionTitle)
                
                HStack {
                    Text("Belief:")
                    Spacer()
                    Text(releasedBelief)
                }
                
                HStack {
                    Text("Frequency:")
                    Spacer()
                    Text(selectedWord ?? "-")
                }
                
                HStack {
                    Text("Date:")
                    Spacer()
                    Text(Date(), style: .date)
                }
            }
            .padding()
        }
    }
}

// MARK: PREVIEW
#Preview {
    BeliefDecoderView(
        category: "Belief",
        count: 12,
        hasLayers: true
    )
}
