//
//  DiscoverSessionDetailView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 31/03/2026.
//
import SwiftUI


struct DiscoverySessionDetailView: View {
    
    @State private var appear = false
    @State private var isTransitioning = false
    
    
    var session: SessionEntry
    
    var body: some View {
        
        ZStack {
            Theme.templeParchment
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                Spacer(minLength: 40)
                
                // 📅 DATE
                Text(session.date, format: .dateTime.day().month().year())
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textSecondary)
                
                // 🧭 IDENTIFIED (NOT RELEASED)
                Text("Category Identified")
                    .font(.headline)
                    .foregroundStyle(Theme.textSecondary)
                
                // 🏷 CATEGORY LABEL
                VStack(spacing: 6) {
                    
                    Text("Category")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary)
                    
                    Text(session.emotion)
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .padding(.top, 4)
                        .overlay(
                            LinearGradient(
                                colors: [
                                    Theme.goldSoft.opacity(0.4),
                                    Color.clear
                                ],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                            .blur(radius: 8)
                            .opacity(0.6)
                        )
                }
                
                Divider().padding(.vertical, 10)
                
                // 🌿 OPTIONAL CONTEXT
                if let reflection = session.reflection {
                    
                    Text(reflection)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    // 🔥 RELEASE FROM THIS CATEGORY
                    Spacer().frame(height: 12)
                    
                    NavigationLink {
                        QuickReleaseView(category: session.emotion)
                    } label: {
                        Text("Release within this category")
                            .font(Theme.cardTitle)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: Theme.buttonRadius)
                                    .fill(Theme.textPrimary.opacity(0.9))
                            )
                            .shadow(color: Theme.goldSoft.opacity(0.2), radius: 12, x: 0, y: 6)
                            .foregroundStyle(.white)
                            .cornerRadius(Theme.buttonRadius)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            .padding()
            .opacity(isTransitioning ? 0 : 1)
            .scaleEffect(isTransitioning ? 0.98 : 1)
            .blur(radius: isTransitioning ? 4 : 0)
            .animation(.easeInOut(duration: 0.45), value: isTransitioning)
        }
    }
}

