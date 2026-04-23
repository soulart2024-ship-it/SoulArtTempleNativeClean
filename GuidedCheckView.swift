//
//  GuidedCheckView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 08/04/2026.
import SwiftUI
import AVKit

struct GuidedCheckView: View {
    
    let category: String   // ✅ ADD THIS
    
    @State private var step = 0
    @State private var feltResponse: String? = nil
    @State private var navigateToRelease = false
    @State private var navigateBackToDiscovery = false
    @State private var player = AVPlayer()
    @State private var contentOpacity: Double = 1
    @State private var contentOffset: CGFloat = 0
    @State private var breatheScale: CGFloat = 1.0
    @State private var videoOpacity: Double = 1
    @State private var blurAmount: CGFloat = 0
    @State private var glowOpacity: Double = 0.15
    
    let steps: [(text: String, video: String?, showsChoice: Bool)] = [
        
        ("Gently settle through breath.", "breathing_soft", false),
        
        ("Take a slow breath in… and out (count to 5).", "breath_cycle", false),
        
        ("Bring your awareness to your body.", "body_awareness", false),
        
        ("Say 'yes' softly… notice expansion or ease.", "finger_rub_yes", true),
        
        ("Rub thumb and forefinger together. Stay in 'Yes'.", "finger_hold", false),
        
        ("Now say 'no'… notice restriction or hesitation, stickiness.", "finger_rub_no", true),
        
        ("Test Column A… then Column B.", "column_test", false),
        
        ("Move through the rows until one feels open or 'yes'.", "row_test", false),
        
        ("Select the tile that feels or muscle tested ready.", nil, false)
    ]
    
    
    var body: some View {
        
        VStack(spacing: 30) {
            
            Text("Guided Check")
                .font(Theme.sectionTitle)
                .foregroundStyle(Theme.textPrimary)
            
            ZStack {
                
                // ✨ SOFT GLOW BEHIND VIDEO
                RoundedRectangle(cornerRadius: 20)
                    .fill(Theme.goldSoft.opacity(glowOpacity))
                    .blur(radius: 25)
                    .frame(height: 160)
                
                // 🎥 VIDEO
                if steps[step].video != nil {
                    VideoPlayer(player: player)
                        .frame(height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .scaleEffect(breatheScale)
                        .opacity(videoOpacity)
                        .blur(radius: blurAmount)
                }
            }
            .opacity(contentOpacity)
            .offset(y: contentOffset)
            .animation(.easeInOut(duration: 0.35), value: contentOpacity)
                
                if steps[step].showsChoice {
                    
                    VStack(spacing: 12) {
                        
                        Text("What did you feel?")
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary)
                        
                        HStack(spacing: 16) {
                            
                            Button("Open / Yes") {
                                Haptics.soft()
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                feltResponse = "yes"
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                feltResponse == "yes"
                                ? Theme.brandBlue
                                : Color.white.opacity(0.5)
                            )
                            .scaleEffect(feltResponse == "yes" ? 1.05 : 1.0)
                            .animation(.spring(response: 0.3), value: feltResponse)
                            .foregroundStyle(feltResponse == "yes" ? .white : Theme.textPrimary)
                            .cornerRadius(12)
                            
                            Button("Unsure / No") {
                                Haptics.warning()
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                feltResponse = "no"
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                feltResponse == "no"
                                ? Theme.brandBlue
                                : Color.white.opacity(0.5)
                            )
                            .scaleEffect(feltResponse == "no" ? 1.05 : 1.0)
                            .animation(.spring(response: 0.3), value: feltResponse)
                            .foregroundStyle(feltResponse == "no" ? .white : Theme.textPrimary)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                
                if step == steps.count - 1 && feltResponse != nil {
                    
                    Text(feltResponse == "yes"
                         ? "Your body is aligned with this category."
                         : "You may explore another category or continue gently.")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                }
                
                Button {
                    
                    if step < steps.count - 1 {
                        
                        // 🌫 EXIT TRANSITION
                        withAnimation(.easeOut(duration: 0.25)) {
                            contentOpacity = 0
                            contentOffset = 12
                            videoOpacity = 0
                            blurAmount = 6
                            glowOpacity = 0.25
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            
                            step += 1
                            
                            // ✨ ENTER TRANSITION
                            withAnimation(.easeIn(duration: 0.45)) {
                                contentOpacity = 1
                                contentOffset = 0
                                videoOpacity = 1
                                blurAmount = 0
                                glowOpacity = 0.15
                            }
                        }
                    }
                    
                } label: {
                    Text(step == steps.count - 1 ? "Complete" : "Next")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Theme.brandBlue)
                        .foregroundStyle(.white)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
                .padding()
                .background(Theme.templeBackground)
                .onChange(of: step) { _, newStep in
                    
                    let current = steps[newStep]
                    
                    if let video = current.video,
                       let url = Bundle.main.url(forResource: video, withExtension: "mp4") {
                        
                        let item = AVPlayerItem(url: url)
                        player.replaceCurrentItem(with: item)
                        player.isMuted = true
                        player.play()
                        
                    } else {
                        player.pause()
                        player.replaceCurrentItem(with: nil)
                    }
                }
            
                .onAppear {
                    
                    let current = steps[step]
                    
                    if let video = current.video,
                       let url = Bundle.main.url(forResource: video, withExtension: "mp4") {
                        
                        player = AVPlayer(url: url)
                        player.isMuted = true
                        player.play()
                        
                        withAnimation(
                            .easeInOut(duration: 4)
                            .repeatForever(autoreverses: true)
                        ) {
                            breatheScale = 1.03
                            glowOpacity = 0.2
                        
                        }
                    }
                }
            
                .navigationDestination(isPresented: $navigateToRelease) {
                    QuickReleaseView(category: category)
                }
            
                .navigationDestination(isPresented: $navigateBackToDiscovery) {
                    CategoryCheckView(category: category)
                }
        }
    }

