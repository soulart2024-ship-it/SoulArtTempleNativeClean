//
//  AurumCompanionView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 14/04/2026.
//
import SwiftUI

struct AurumCompanionView: View {

        
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @State private var userInput: String = ""
    @State private var responseText: String = ""
    @State private var isLoading = false
    @State private var isBreathingMode = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Theme.templeParchment
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        Spacer()
                        
                        // 🌿 TITLE
                        Text("Aurum")
                            .font(Theme.sectionTitle)
                            .foregroundStyle(Theme.textPrimary)
                        
                        // 🌿 ENTRY MESSAGE
                        Text("I'm here with you.\nYou don't have to figure anything out right now.\nJust speak, or sit for a moment.")
                            .font(Theme.bodyText)
                            .foregroundStyle(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                        
                        // 🌿 USER INPUT
                        TextField("Share what's present for you...", text: $userInput)
                            .onSubmit {
                                generateResponse()
                            }
                            .padding()
                            .background(Color.white.opacity(0.6))
                            .cornerRadius(12)
                            .padding(.horizontal, 30)
                            .submitLabel(.done)
                        
                        Button("Reflect with me") {
                            print("BUTTON TRIGGERED")
                            generateResponse()
                        }
                        .padding(.top, 10)
                        
                        // 🌿 BREATHING MODE (FIRST)
                        if isBreathingMode {
                            
                            VStack(spacing: 16) {
                                
                                OrbPlayerView(
                                    videoName: "regulate_breath",
                                    title: "Just breathe"
                                )
                                .frame(height: 320)
                                
                                Text("Stay here… just breathe.")
                                    .font(Theme.bodyText)
                                    .foregroundStyle(Theme.textSecondary)
                                
                                Button("I'm ready") {
                                    isBreathingMode = false
                                }
                                .padding(.top, 10)
                            }
                            
                        }
                        // 🌿 NORMAL RESPONSE FLOW
                        else if isLoading {
                            
                            ProgressView()
                                .padding()
                            
                        } else if !responseText.isEmpty {
                            
                            Text(responseText)
                                .font(Theme.bodyText)
                                .foregroundStyle(Theme.textPrimary)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.25))
                                )
                                .padding(.horizontal, 30)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                                .animation(.easeInOut(duration: 0.6), value: responseText)
                        }
                        
                        Spacer()
                        
                        // 🌿 GENTLE NEXT STEPS
                        
                        VStack(spacing: 12) {
                            
                            Text("Follow what feels right for you…")
                                .font(Theme.smallText)
                                .foregroundStyle(Theme.textSecondary)
                            
                            HStack(spacing: 12) {
                                
                                Button {
                                    dismiss()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        appState.selectedTab = 1 // Switch to Decoders tab
                                    }
                                } label: {
                                    Text("Go Deeper")
                                        .font(Theme.smallText)
                                        .padding()
                                        .background(Theme.templeParchment)
                                        .cornerRadius(10)
                                }
                                
                                NavigationLink(destination: JournalView()) {
                                    Text("Journal This")
                                        .font(Theme.smallText)
                                        .padding()
                                        .background(Theme.templeParchment)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.bottom, 120)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Theme.textSecondary)
                            .padding(8)
                            .background(Color.white.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
    
    // 🌿 SIMPLE RESPONSE ENGINE (PHASE 1)
    
    func generateResponse() {
        
        guard !userInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        isLoading = true
        responseText = ""
        
        let lowerInput = userInput.lowercased()

        // 🌿 STILLNESS / BREATH DETECTION (FIRST PRIORITY)
        if lowerInput.contains("breathe") ||
           lowerInput.contains("breath") ||
           lowerInput.contains("still") ||
           lowerInput.contains("sit") ||
           lowerInput.contains("pause") {
            
            isBreathingMode = true
            isLoading = false
            responseText = ""
            return
        }

        // 🌿 SHADOW EMOTION DETECTION
        let shadowTriggers = [
            "fear", "guilt", "shame", "grief", "anger",
            "despair", "abandonment", "rejection",
            "hopelessness", "powerlessness", "anxiety", "worthlessness"
        ]

        let isShadowTriggered = shadowTriggers.contains {
            lowerInput.contains($0)
        }

        // 🌿 ENHANCED INPUT
        let enhancedInput = isShadowTriggered
        ? "User is expressing a shadow emotion: \(userInput)"
        : userInput
        
        Task {
            do {
                let reply = try await AurumService.shared.sendMessage(enhancedInput)
                
                await MainActor.run {
                    responseText = reply
                    isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    responseText = "Something didn't flow just now… try again."
                    isLoading = false
                }
            }
        }
    }
}
