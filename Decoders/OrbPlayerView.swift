//
//  OrbPlayerView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 31/03/2026.
//
import SwiftUI
import AVKit

struct OrbPlayerView: View {
    
    let videoName: String
    let title: String
    
    @State private var player = AVPlayer()
    @State private var videoOpacity: Double = 1.0
    @State private var breatheScale: CGFloat = 1.0
    
    var body: some View {
        
        ZStack {
            
            Theme.templeParchment
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Text(title)
                    .font(Theme.sectionTitle)
                    .foregroundStyle(Theme.textPrimary)
                
                VideoPlayer(player: player)
                    .clipShape(Circle())
                    .frame(width: 260, height: 260)
                    .shadow(color: Theme.goldSoft.opacity(0.6), radius: 35, x: 0, y: 15)
                    .shadow(color: Theme.goldSoft.opacity(0.25), radius: 60, x: 0, y: 25)
                    .opacity(videoOpacity)
                    .scaleEffect(breatheScale)
                    .onAppear {
                        playVideo()
                        startBreathing()
                    }
                Button {
                    playFrequency("432hz")   // 👈 THIS LINE ONLY
                } label: {
                    Text("Choose Frequency...")
                        .font(.caption)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Theme.goldSoft.opacity(0.2))
                        .foregroundStyle(Theme.textPrimary)
                        .cornerRadius(10)
                
                        .padding(.top, 30)
                }
                
                Text("Breathe gently…")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textSecondary)
                
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding(.top, 40)
        }
    }
    
    func playVideo() {
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            print("❌ Missing video:", videoName)
            return
            
        }
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        player.isMuted = true
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        player.play()
        
        // 🌿 SOFT LOOP (NO FLASH / NO JUMP)
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { _ in
            
            // ✨ tiny fade (very subtle)
            withAnimation(.easeOut(duration: 0.8)) {
                videoOpacity = 0.7
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                
                player.seek(to: .zero)
                player.play()
                
                withAnimation(.easeIn(duration: 1.2)) {
                    videoOpacity = 1.0
                    
                }
            }
        }
    }
    func playFrequency(_ name: String) {
        MusicPlayer.shared.playFrequency(name)
    }
    func startBreathing() {
        
        func breatheCycle() {
            
            // 🌿 INHALE (5s)
            withAnimation(.easeInOut(duration: 5)) {
                breatheScale = 1.15
            }
            
            // 🌿 HOLD (1s)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                
                // 🌿 EXHALE (5s)
                withAnimation(.easeInOut(duration: 5)) {
                    breatheScale = 1.0
                }
                
                // 🔁 LOOP AGAIN
                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                    breatheCycle()
                }
            }
        }
        
        breatheCycle()
    }
    
}
