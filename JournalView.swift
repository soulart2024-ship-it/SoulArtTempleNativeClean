import SwiftUI

struct JournalView: View {
    
    @EnvironmentObject var discoveryStore: DiscoveryStore
    
    @ObservedObject var music = MusicPlayer.shared
    
    var emotion: String?
    var replacementWord: String = ""
    var affirmation: String = ""
    var onSave: ((String) -> Void)?
    var initialEntry: String = ""
    var stage: String? = nil
    
    @State private var entry: String = ""
    private let prompts = [
        "What shifted for you?",
        "How does your body feel now?",
        "What felt different during the release?",
        "What would you like to carry forward from this moment?"
    ]
    @State private var goToTemple = false
    @State private var showCompletion = false
    @FocusState private var isTyping: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack {
            
            Theme.templeParchment
                .ignoresSafeArea()
            
            Color.clear
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    isTyping = false
                }
            
            VStack(spacing: 20) {
                
                // 🔙 BACK BUTTON
                HStack {
                    Button {
                        if let onSave = onSave {
                            onSave(entry)
                        }
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Theme.textPrimary)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                // 🧠 HEADER
                if !replacementWord.isEmpty {
                    
                    VStack(spacing: 8) {
                        Text("Returning to Balance")
                            .font(Theme.sectionTitle)
                            .foregroundStyle(Theme.textPrimary.opacity(0.8))
                        
                        if let emotion = emotion {
                            Text("\(emotion) → \(replacementWord)")
                                .font(Theme.smallText)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        
                        Text(affirmation)
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                    
                } else {
                    
                    VStack(spacing: 6) {
                        Text("Reflect freely")
                            .font(Theme.sectionTitle)
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Take a moment to check in with yourself")
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                
                // 💬 PROMPT
                VStack(alignment: .leading, spacing: 8) {
                    
                    if let emotion = emotion {
                        let dynamicPrompts = journalPrompts(for: emotion)
                        
                        Text(dynamicPrompts.randomElement() ?? "")
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary)
                            .padding(.horizontal, 24)
                        
                    } else {
                        
                        Text(prompts.randomElement() ?? "")
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary)
                            .padding(.horizontal, 24)
                    }
                }
                
                // 🎵 SOUND BUTTON (FIXED BEHAVIOUR)
                if music.currentTrack == nil {
                    
                    Button {
                        music.playTrack("432hz")
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "waveform")
                            Text("Sound supporting your session")
                        }
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary.opacity(0.6))
                        .padding(.horizontal, 24)
                    }
                }
                
                // ✍️ JOURNAL BOX
                TextEditor(text: $entry)
                    .focused($isTyping)
                    .scrollContentBackground(.hidden)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.25))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 0.6)
                    )
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .frame(height: 220)
                
                // 🧩 INTEGRATION
                if let emotion = emotion {
                    
                    let prompts = journalPrompts(for: emotion)
                    
                    VStack(spacing: 12) {
                        
                        Text("Integration")
                            .font(.headline)
                        
                        ForEach(prompts, id: \.self) { prompt in
                            Text("• \(prompt)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                }
                
                // 💾 SAVE BUTTON
                Button {
                    
                    if !entry.isEmpty {
                        
                        if !discoveryStore.sessions.isEmpty {
                            
                            // 🔁 Existing session (from decoder flow)
                            discoveryStore.sessions[0].reflection = entry
                            
                        } else {
                            
                            // 🆕 Standalone journal → CREATE session first
                            let session = SessionEntry(
                                id: UUID(),
                                type: "journal", // ✅ ADD THIS HERE
                                emotion: "Journal Entry",
                                category: "Journal",
                                date: Date(),
                                reflection: entry,
                                replacement: "",
                                meaning: ""
                            )
                            
                            discoveryStore.sessions.insert(session, at: 0)
                            discoveryStore.saveSessions()
                        }
                    }
                    // MARK: Back button
                    if let onSave = onSave {
                        onSave(entry)
                        dismiss() // 🔥 embedded flow (Oracle / Decoder)
                    } else {
                        showCompletion = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            dismiss()
                        }
                    }
                    
                } label: {
                    Text("Save & Close")
                        .font(Theme.cardTitle)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.brandBlue)
                        .foregroundStyle(.white)
                        .cornerRadius(Theme.buttonRadius)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
            }
            .padding(.top, 40)
            
            .onAppear {
                
                if entry.isEmpty && !initialEntry.isEmpty {
                    entry = initialEntry
                }
                
                if music.currentTrack == nil {
                    music.playTrack("432hz")
                }
            }
        }
        if showCompletion {
            
            VStack(spacing: 16) {
                
                Text("Saved")
                    .font(Theme.sectionTitle)
                    .foregroundStyle(Theme.textPrimary)
                
                Text("Your reflection has been woven into your journey")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textSecondary)
                
            
        
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.95))
            )
            .padding(.horizontal, 30)
            .transition(.opacity)
        }
    }
        
    private func journalPrompts(for emotion: String) -> [String] {
        
        switch emotion {
            
        case "Fear":
            return [
                "Where in my life am I being invited to step forward?",
                "What would courage look like in this moment?",
                "What feels safer now than before?"
            ]
            
        case "Overwhelm":
            return [
                "What is asking me to slow down?",
                "What truly matters right now?",
                "What can I gently release from my plate?"
            ]
            
        default:
            return [
                "What did I notice during this release?",
                "How does my body feel now?",
                "What has shifted within me?"
            ]
        }
    }
}
