//
//  KinesiologyIntroView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 31/03/2026.
//
import SwiftUI
import AVKit

struct KinesiologyIntroView: View {
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 30) {
                
                // 🌿 TITLE
                
                Text("Practical Kinesiology")
                    .font(Theme.sectionTitle)
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                
                
                // 🌿 60 SECOND EXPLANATION
                
                VStack(spacing: 16) {
                    
                    Text("Listening to your body's truth in everyday life.")
                        .font(Theme.cardTitle)
                        .foregroundStyle(Theme.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("""
Kinesiology is a gentle way of listening to your body’s natural responses.

When something is true for you, your body stays strong.
When something is not aligned, it softens.

This allows you to identify what is ready to be seen — without needing to think or analyse.

You are not guessing.
You are responding.
""")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.25))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Theme.goldSoft.opacity(0.08), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                
                
                // 🎥 VIDEO SECTION
                
                VStack(spacing: 20) {
                    
                    Text("Follow the guidance below")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary.opacity(0.7))
                    
                    videoPlaceholder(title: "1. How to Set Your Baseline")
                    videoPlaceholder(title: "2. How to Ask a Clear Question")
                    videoPlaceholder(title: "3. Strong vs Weak Response")
                    videoPlaceholder(title: "4. Practising with Confidence")
                }
                
                
                Spacer(minLength: 40)
            }
        }
        .background(Theme.templeBackground)
        .navigationTitle("Kinesiology")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - 🎥 VIDEO PLACEHOLDER

extension KinesiologyIntroView {
    
    func videoPlaceholder(title: String) -> some View {
        
        VStack(spacing: 10) {
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.cardPrimary.opacity(0.4))
                    .frame(height: 180)
                
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Theme.textSecondary.opacity(0.6))
            }
            
            Text(title)
                .font(Theme.smallText)
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.horizontal, 20)
    }
}
