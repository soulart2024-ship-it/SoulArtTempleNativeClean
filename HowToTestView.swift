//
//  HowToTestView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 08/04/2026.
//
import SwiftUI
import AVKit

struct HowToTestView: View {
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("How to Muscle Test")
                .font(Theme.sectionTitle)
                .foregroundStyle(Theme.textPrimary)
            
            VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: "muscle_test", withExtension: "mp4")!))
                .frame(height: 240)
                .cornerRadius(16)
            
            Text("Gently say 'yes' and 'no' and notice your body’s response.")
                .font(Theme.smallText)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Spacer()
        }
        .padding()
        .background(Theme.templeBackground)
    }
}
