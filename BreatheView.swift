import SwiftUI

struct BreatheView: View {
    
    // MARK: - State
    
    @State private var isBreathing = false
    @State private var isInhale = true
    @State private var breathDuration = 6
    @State private var timeRemaining = 5
    @State private var cycles = 0
    @State private var timer: Timer? = nil
    @State private var showIntro = true
  
    
    // 🌿 NEW: Breath Types

    enum BreathType: String, CaseIterable {
        case regulation = "Regulate"
        case box = "Box"
        case fourSevenSeven = "4-7-7"
    }

    @State private var breathType: BreathType = .regulation
    @State private var phaseIndex: Int = 0
    
    var breathPattern: [(label: String, duration: Int)] {
        
        switch breathType {
            
        case .regulation:
            return [
                ("Breathe in slowly…", breathDuration),
                ("Breathe out gently…", breathDuration)
            ]
            
        case .box:
            return [
                ("Breathe in…", 4),
                ("Hold…", 4),
                ("Breathe out…", 4),
                ("Hold…", 4)
            ]
            
        case .fourSevenSeven:
            return [
                ("Breathe in…", 7),
                ("Hold…", 4),
                ("Breathe out…", 7)
            ]
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        
        ZStack {
            
            Theme.templeParchment
                .ignoresSafeArea(.all, edges: .bottom)
            
            VStack(spacing: 55) {
                
             
                // 🌬️ BREATH TEXT
                
                Text(
                    isBreathing
                    ? breathPattern[phaseIndex].label
                    : "Begin when you feel ready"
                )
                .font(Theme.sectionTitle)
                .foregroundStyle(Theme.textPrimary)
                .padding(.top, 85)
                
                // ⏱ TIMER
                
                Text("\(timeRemaining)")
                    .font(.system(size: 40, weight: .light))
                    .foregroundStyle(Theme.textSecondary)
                    .padding(.top, 10)
                
                // 🌸 BREATH CIRCLE (your lotus placeholder)
                
                LotusView(
                    isInhale: isInhale,
                    isHold: breathPattern[phaseIndex].label.lowercased().contains("hold")
                )
                .padding(.vertical, 20)
                
                // 🔁 CYCLE COUNT
                
                Text("Cycles: \(cycles)")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textSecondary)
                
                Text("Follow the rhythm of your breath")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textSecondary.opacity(0.6))
                
                
                
                // 🌬 BREATH TYPE SELECTOR
                
                Picker("", selection: $breathType) {
                    Text("Calm").tag(BreathType.regulation)
                    Text("Box").tag(BreathType.box)
                    Text("Recalibrate").tag(BreathType.fourSevenSeven)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 40)
                .disabled(isBreathing)
                
                // 🎛 CONTROLS
                
                HStack(spacing: 20) {
                    
                    Button(isBreathing ? "Pause" : "Start") {
                        toggleBreathing()
                    }
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(Theme.brandBlue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(color: Theme.goldGlow.opacity(0.4), radius: 10)
                    
                    Button("Reset") {
                        resetSession()
                    }
                    .foregroundStyle(Theme.textSecondary)
                }
                
                Spacer()
                
                Text("This space offers reflection, not therapy.")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textSecondary)
                
                    .toolbar(.hidden, for: .tabBar)
                
            }
        }
    }
    
    
    
    // MARK: - Logic
    
    private func toggleBreathing() {
        if isBreathing {
            pauseBreathing()
        } else {
            startBreathing()
        }
    }
    
    private func startBreathing() {
        isBreathing = true
        phaseIndex = 0
        timeRemaining = breathPattern[phaseIndex].duration
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            timeRemaining -= 1
            
            if timeRemaining <= 0 {
                
                // 🌿 HAPTIC — ALWAYS TRIGGERS WITH BREATH
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                
                // 🎵 MUSIC — OPTIONAL (SEPARATE)
                if false && MusicPlayer.shared.isPlaying {
                    let label = breathPattern[phaseIndex].label.lowercased()
                    
                    if label.contains("in") {
                        MusicPlayer.shared.playFrequency("528hz")
                    } else if label.contains("out") {
                        MusicPlayer.shared.playFrequency("432hz")
                    }
                }
                
                // Move to next phase
                phaseIndex += 1
                
                // If finished full cycle
                if phaseIndex >= breathPattern.count {
                    phaseIndex = 0
                    cycles += 1
                }
                
                // Set next phase duration
                timeRemaining = breathPattern[phaseIndex].duration
                
                // Update inhale/exhale ONLY for animation
                let label = breathPattern[phaseIndex].label.lowercased()
                if label.contains("in") {
                    isInhale = true
                } else if label.contains("out") {
                    isInhale = false
                }
                // HOLD → do nothing (this is the key fix)
            }
        }
    }
    
    private func pauseBreathing() {
        isBreathing = false
        timer?.invalidate()
    }
    
    private func resetSession() {
        pauseBreathing()
        isInhale = true
        cycles = 0
        timeRemaining = breathDuration
    }
}
