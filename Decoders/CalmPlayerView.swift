//
//  CalmPlayerView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 29/03/2026.
import SwiftUI
import AVKit

struct CalmPlayerView: View {
    
    let videoName: String
    let title: String
    
    @State private var player = AVPlayer()
    @State private var breatheScale: CGFloat = 1.0
    @State private var showGuidance = false
    @State private var showContinue = false
    @State private var goToDiscovery = false
    @State private var videoOpacity: Double = 1.0
    
    var body: some View {
        
        ZStack {
            
            Theme.templeParchment
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Text(title)
                    .font(Theme.sectionTitle)
                    .foregroundStyle(Theme.textPrimary)
                
                VideoPlayer(player: player)
                    .frame(height: 250)
                    .cornerRadius(20)
                    .padding()
                    .opacity(videoOpacity)
                    .onAppear {
                        playVideo()
                        
                        // 🌿 TIMING FLOW
                        withAnimation(.easeInOut(duration: 7).repeatForever(autoreverses: true)) {
                            breatheScale = 1.3
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showGuidance = true
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                            withAnimation {
                                showContinue = true
                            }
                        }
                    }
                if videoName == "calm_recalibration" {
                    Text("Silent • choose your own sound")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary.opacity(0.9))
                        .padding(.top, -6)
                }
                
                // 🌿 BREATH VISUAL
                Circle()
                    .fill(Theme.goldSoft.opacity(0.15))
                    .frame(width: 180, height: 180)
                    .scaleEffect(breatheScale)
                    .blur(radius: 20)
                
                // 🌿 GUIDANCE TEXT
                VStack(spacing: 6) {
                    
                    if showGuidance {
                        VStack(spacing: 6) {
                            Text("Breathe in slowly…")
                            Text("and soften into this moment")
                        }
                        .transition(.opacity)
                    }
                    
                    Text("Inhale 7 • Exhale 7")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary.opacity(0.7))
                }
                .font(Theme.bodyText)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                
                // 🌿 CONTINUE BUTTON (FIXED)
                if showContinue {
                    
                    Button {
                        stopVideo()   // 🔥 THIS IS THE FIX
                        goToDiscovery = true
                    } label: {
                        Text("I am ready to begin my release")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.brandBlue)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 40)
                    }
                    .transition(.opacity)
                }
                
                Spacer()
            }
        }
        .navigationDestination(isPresented: $goToDiscovery) {
            DiscoveryGroundView()
        }
    }
    
    // ✅ MUST BE OUTSIDE BODY
    func playVideo() {
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            print("❌ Missing video:", videoName)
            return
     
        }
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)

        // 👇 ADD THIS BLOCK
        if videoName == "just_waves" || videoName == "calm_recalibration" {
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: item,
                queue: .main
            ) { _ in
                player.seek(to: .zero)
                player.play()
            }
        }
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        player.play()
    }
    func stopVideo() {
        player.pause()
        player.replaceCurrentItem(with: nil)
    }
    
}
