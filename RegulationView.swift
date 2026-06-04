import SwiftUI

struct RegulationView: View {
    
    @State private var isInhaling = true
    @State private var pulse = false
    @State private var showContinue = false
    
    var body: some View {
        
        ZStack {
            
            // 🌑 Background (use your theme if preferred)
            Theme.decoderParchment
                .ignoresSafeArea()
            
            Theme.brandBlueGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                Spacer()
                
                // 🌸 BREATH TEXT
                Text(isInhaling ? "Inhale…" : "Exhale…")
                    .font(.title2.weight(.medium))
                    .foregroundStyle(Theme.textPrimary)
                    .opacity(isInhaling ? 1 : 0.6)
                    .animation(.easeInOut(duration: 2.8), value: isInhaling)
                
                // 🌕 BREATH ORB
                ZStack {
                    
                    Circle()
                        .fill(Theme.rootActive.opacity(0.25))
                        .frame(width: 220, height: 220)
                        .scaleEffect(pulse ? 1.2 : 0.8)
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
                                endRadius: 100
                            )
                        )
                        .frame(width: 140, height: 140)
                        .scaleEffect(isInhaling ? 1.15 : 0.9)
                        .animation(.easeInOut(duration: 2.8), value: isInhaling)
                }
                
                Spacer()
                
                // 👉 CONTINUE BUTTON (appears after delay)
                if showContinue {
                    
                    NavigationLink(destination: Text("Opening Step")) {
                        Text("Continue")
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
                            .padding(.horizontal)
                    }
                    .transition(.opacity)
                }
            }
        }
        .onAppear {
            
            pulse = true
            
            // 🌬️ BREATH LOOP
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                isInhaling.toggle()
            }
            
            // ⏳ SHOW CONTINUE AFTER CALMING
            DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                withAnimation {
                    showContinue = true
                }
            }
        }
    }
}
