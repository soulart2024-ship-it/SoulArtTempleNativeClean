import SwiftUI

struct OracleView: View {
    
    @StateObject var oracle = OracleStore()
    @State private var goToJournal = false
    @State private var oracleMessage = ""
    @State private var revealIndex = 0
    @EnvironmentObject var discoveryStore: DiscoveryStore
    
    var body: some View {
        
        ZStack {
            
            Theme.templeParchment
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // 🧠 HEADER
                VStack(spacing: 6) {
                    Text("SoulArt Oracle Deck")
                        .font(Theme.sectionTitle)
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text("Draw guidance for your journey")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary)
                }
                
                // 🎴 DRAW CONTROLS
                drawControls
                
                // 🃏 DRAW AREA
                drawArea
                
                // 🔁 ACTIONS
                if !oracle.drawnCards.isEmpty {
                    actionButtons
                }
                
                Spacer()
            }
            .padding(.top, 40)
            
            .navigationDestination(isPresented: $goToJournal) {
                JournalView(
                    emotion: "Oracle Reading",
                    replacementWord: "",
                    affirmation: "",
                    onSave: nil,
                    initialEntry: oracleMessage,
                    stage: "oracle"
                )
            }
        }
    }
    
    
    // MARK: - DRAW CONTROLS
    private var drawControls: some View {
        
        VStack(spacing: 10) {
            
            HStack {
                Button("1 Card") { drawWithAnimation(count: 1) }
                Button("3 Cards") { drawWithAnimation(count: 3) }
            }
            
            HStack {
                Button("5 Cards") { drawWithAnimation(count: 5) }
                Button("Random") { drawRandomWithAnimation() }
            }
        }
        .font(Theme.smallText)
        .foregroundStyle(Theme.textPrimary.opacity(0.5))
    }
    
    private func drawWithAnimation(count: Int) {
        
        oracle.draw(count: count)
        revealIndex = 0
        
        for i in 0..<count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.25) {
                revealIndex = i + 1
            }
        }
    }

    private func drawRandomWithAnimation() {
        
        oracle.drawRandom()
        revealIndex = 0
        
        let count = oracle.drawnCards.count
        
        for i in 0..<count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.25) {
                revealIndex = i + 1
            }
        }
    }
    // MARK: - DRAW AREA
    private var drawArea: some View {
        
        VStack(spacing: 16) {
            
            if oracle.drawnCards.isEmpty {
                
                Text("Choose a draw option above")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textPrimary)
                    .padding(.top, 40)
                
            } else {
                
                if oracle.drawnCards.count == 3 {
                    
                    ScrollView {
                            sacredThreeCardLayout
                        }
                        
                } else if oracle.drawnCards.count == 5 {

                                        ScrollView {
                                            sacredFiveCardLayout
                                                .padding(.top, 10)
                                        }
                    
                } else {
                    
                    ScrollView {
                        
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 24
                        ) {
                            ForEach(Array(oracle.drawnCards.enumerated()), id: \.element.id) { index, card in
                                OracleCardView(card: card)
                                    .frame(maxWidth: 180)
                                      .opacity(index < revealIndex ? 1 : 0)
                                      .scaleEffect(index < revealIndex ? 1 : 0.9)
                                      .animation(.easeOut(duration: 0.4), value: revealIndex)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
    }
 
    private var sacredThreeCardLayout: some View {
        
        VStack(spacing: 36) {
            
            // 🔮 TOP CARD
            VStack(spacing: 6) {
                Text("Guidance")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textPrimary.opacity(0.5))
                
                OracleCardView(card: oracle.drawnCards[0])
                    .frame(width: 180, height: 260)
                    .opacity(0 < revealIndex ? 1 : 0)
                    .scaleEffect(0 < revealIndex ? 1 : 0.9)
                    .animation(.easeOut(duration: 0.4), value: revealIndex)
                    .shadow(color: Theme.goldSoft.opacity(0.15), radius: 12, y: 6)
                    .scaleEffect(1.02)
            }
            
            // 🌿 BOTTOM CARDS
            HStack(alignment: .top, spacing: 24) {
                
                VStack(spacing: 6) {
                    Text("Foundation")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textPrimary.opacity(0.5))
                    
                    OracleCardView(card: oracle.drawnCards[1])
                        .frame(maxWidth: .infinity)
                        .aspectRatio(180/260, contentMode: .fit)
                        .opacity(1 < revealIndex ? 1 : 0)
                        .scaleEffect(1 < revealIndex ? 1 : 0.92)
                     
                }
                
                VStack(spacing: 6) {
                    Text("Integration")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textPrimary.opacity(0.5))
                    
                    OracleCardView(card: oracle.drawnCards[2])
                        .frame(maxWidth: .infinity)
                                   .aspectRatio(180/260, contentMode: .fit)
                                   .opacity(2 < revealIndex ? 1 : 0)
                                   .scaleEffect(2 < revealIndex ? 1 : 0.92)
                      
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
    }
    
    private var sacredFiveCardLayout: some View {

        VStack(spacing: 36) {

            // 🔮 TOP — GUIDANCE
            VStack(spacing: 8) {
                Text("Guidance")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textPrimary.opacity(0.5))

                OracleCardView(card: oracle.drawnCards[0])
                    .opacity(0 < revealIndex ? 1 : 0)
                    .scaleEffect(0 < revealIndex ? 1 : 0.9)
                    .animation(.easeOut(duration: 0.4), value: revealIndex)
                    .shadow(color: Theme.goldSoft.opacity(0.15), radius: 10, y: 5)
            }
            .frame(maxWidth: .infinity)

            // 🌿 SECOND ROW
            HStack(alignment: .top, spacing: 16) {

                VStack(spacing: 8) {
                    Text("Past")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textPrimary.opacity(0.5))

                    OracleCardView(card: oracle.drawnCards[1])
                        .opacity(1 < revealIndex ? 1 : 0)
                        .scaleEffect(1 < revealIndex ? 1 : 0.92)
                        .animation(.easeOut(duration: 0.4), value: revealIndex)
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 8) {
                    Text("Expansion")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textPrimary.opacity(0.5))

                    OracleCardView(card: oracle.drawnCards[2])
                        .opacity(2 < revealIndex ? 1 : 0)
                        .scaleEffect(2 < revealIndex ? 1 : 0.92)
                        .animation(.easeOut(duration: 0.4), value: revealIndex)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)

            // 🧭 CENTER — CORE
            VStack(spacing: 8) {
                Text("Core")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textPrimary.opacity(0.5))

                OracleCardView(card: oracle.drawnCards[3])
                    .opacity(3 < revealIndex ? 1 : 0)
                    .scaleEffect(3 < revealIndex ? 1 : 0.9)
                    .animation(.easeOut(duration: 0.4), value: revealIndex)
                    .shadow(color: Theme.goldSoft.opacity(0.2), radius: 12, y: 6)
            }
            .frame(maxWidth: .infinity)

            // 🌕 BOTTOM — INTEGRATION
            VStack(spacing: 8) {
                Text("Integration")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textPrimary.opacity(0.5))

                OracleCardView(card: oracle.drawnCards[4])
                    .opacity(4 < revealIndex ? 1 : 0)
                    .scaleEffect(4 < revealIndex ? 1 : 0.9)
                    .animation(.easeOut(duration: 0.4), value: revealIndex)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.top, 20)
        .padding(.bottom, 120)
        .padding(.horizontal, 16)
    }
    // MARK: - ACTION BUTTONS
    private var actionButtons: some View {
        
        HStack {
            
            Button("Draw Again") {
                oracle.reset()
            }
            
            .padding(.horizontal, 30)
            .font(Theme.smallText)
            .foregroundStyle(Theme.textPrimary.opacity(0.5))
            
            Spacer()
            
            Button("Save Reading") {

                            guard !oracle.drawnCards.isEmpty else { return }

                            let reading = oracle.drawnCards
                                .map { "✦ \($0.title)\n\($0.message)" }
                                .joined(separator: "\n\n")

                            let session = SessionEntry(
                                id: UUID(),
                                type: "oracle",
                                emotion: "Oracle Reading",
                                category: "Oracle",
                                date: Date(),
                                reflection: reading,
                                replacement: "",
                                meaning: "Oracle guidance received"
                            )

                            discoveryStore.sessions.insert(session, at: 0)
                            discoveryStore.saveSessions()

                oracleMessage = ""
                                goToJournal = true
                        }
            .padding(.horizontal, 30)
            .font(Theme.smallText)
            .foregroundStyle(Theme.textPrimary.opacity(0.5))
        }
    }
}
