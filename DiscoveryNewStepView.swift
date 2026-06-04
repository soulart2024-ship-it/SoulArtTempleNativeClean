//
//  DiscoveryNewStepView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 25/03/2026.
//
import SwiftUI

struct DiscoveryNextStepView: View {
    
    @State private var goToQuickRelease = false
    @State private var goToMembers = false
    @State private var showSavedMessage = false
    @State private var showTransition = false
    
    @EnvironmentObject var discoveryStore: DiscoveryStore
    
    var category: String
    var count: Int
    var hasLayers: Bool
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Theme.templeParchment
                    .ignoresSafeArea()
                
                if showTransition {
                    VStack {
                        Text("Let’s gently explore this together.")
                            .font(Theme.sectionTitle)
                            .foregroundStyle(Theme.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Theme.templeParchment.opacity(0.95))
                    .transition(.opacity)
                }
                
                if showSavedMessage {
                    
                    VStack(spacing: 20) {
                        
                        Spacer()
                        
                        Text("Saved for you")
                            .font(Theme.sectionTitle)
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("You can return to this whenever you feel ready.")
                            .font(Theme.bodyText)
                            .foregroundStyle(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button("Go to My Journey") {
                            goToMembers = true
                        }
                        .font(Theme.cardTitle)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.brandBlue)
                        .foregroundStyle(.white)
                        .cornerRadius(Theme.buttonRadius)
                        .padding(.horizontal, 40)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Theme.templeParchment.opacity(0.95))
                    .transition(.opacity)
                }
                
                if !showSavedMessage && !showTransition {
                    
                    VStack(spacing: 30) {
                        
                        Spacer()
                        
                        Text("You’ve identified something important.")
                            .font(Theme.bodyText)
                            .foregroundStyle(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Text("What would you like to do next?")
                            .font(Theme.sectionTitle)
                            .foregroundStyle(Theme.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                        
                        // 🔘 Begin Release
                        
                        Button {
                            showTransition = true
                            showSavedMessage = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                goToQuickRelease = true
                            }
                        } label: {
                            Text("Begin release")
                                .font(Theme.cardTitle)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.brandBlue)
                                .foregroundStyle(.white)
                                .cornerRadius(Theme.buttonRadius)
                                .padding(.horizontal, 40)
                        }
                        
                        // 🔘 SAVE FOR LATER
                        
                        Button {
                            
                            discoveryStore.save(
                                category: category,
                                count: count,
                                hasLayers: hasLayers
                            )
                            
                            discoveryStore.addDiscoverySession(
                                category: category,
                                count: count,
                                hasLayers: hasLayers
                            )
                            
                            showSavedMessage = true
                            showTransition = false // ✅ NEW FEELING
                            
                        } label: {
                            Text("Save and return later")
                                .font(Theme.cardTitle)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.7))
                                .foregroundStyle(Theme.textPrimary)
                                .cornerRadius(Theme.buttonRadius)
                                .padding(.horizontal, 40)
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationDestination(isPresented: $goToQuickRelease) {
                QuickReleaseView(category: category)
                
            }
            .navigationDestination(isPresented: $goToMembers) {
                MembersAreaView()
            }
        }
    }
}
