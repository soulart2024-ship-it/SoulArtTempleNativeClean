//
//  BreathingOrbView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 31/03/2026.
//
import SwiftUI
import AVKit

struct BreathingOrbView: View {
    
    let videoName: String
    
    @State private var player = AVPlayer()
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        
        ZStack {
            
            Circle()
                .fill(Theme.goldSoft.opacity(0.2))
                .frame(width: 140, height: 140)
                .blur(radius: 20)
                .scaleEffect(scale)
            
            VideoPlayer(player: player)
                .allowsHitTesting(false)
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .onAppear {
                    playLoop()
                    
                    withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                        scale = 1.2
                    }
                }
        }
    }
    
    func playLoop() {
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") else { return }
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        player.isMuted = true
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        player.play()
    }
}
