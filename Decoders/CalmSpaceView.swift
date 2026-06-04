import SwiftUI


struct CalmSpaceView: View {
    
    @State private var selectedOrb: String? = nil
    @State private var showOrbPlayer = false
    
    let videos = [
        ("just_waves", "Waves"),
        ("calm_forest_432", "Forest 432Hz"),
        ("calm_recalibration", "Recalibrate"),
        ("mountain_528", "Mountain 528Hz"),
        ("zen_garden_639", "Zen Garden 639Hz"),
        ("calm_beach_963", "Beach 963Hz")
    ]
    
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                
                
                Theme.templeParchment
                    .ignoresSafeArea()
                
                ScrollView {
                    
                    VStack(spacing: 20) {
                        
                        Text("Welcome to your Calm Space")
                            .font(Theme.sectionTitle)
                            .foregroundStyle(Theme.textPrimary)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            
                            ForEach(videos, id: \.0) { video in
                                
                                NavigationLink {
                                    CalmPlayerView(videoName: video.0, title: video.1)
                                } label: {
                                    
                                    ZStack {
                                        
                                        // Simple soft background (replace later with thumbnails if you want)
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Theme.cardPrimary)
                                            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 4)
                                        
                                        VStack(spacing: 0) {
                                            
                                            Image(video.0 + "_thumb")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: 100)
                                                .clipped()
                                                .cornerRadius(16)
                                            
                                            Text(video.1)
                                                .font(.caption)
                                                .foregroundColor(Theme.textPrimary)
                                                .padding(.vertical, 6)
                                                .frame(maxWidth: .infinity)
                                                .background(Theme.cardPrimary.opacity(0.95))
                                        }
                                    }
                                    .frame(height: 140)
                                }
                            }
                        }
                        .padding()
                        
                        // 🌿 ORB SECTION (NEW)
                        VStack(spacing: 12) {
                            
                            Text("Breathing Orbs")
                                .font(Theme.sectionTitle)
                                .foregroundStyle(Theme.textPrimary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack(spacing: 16) {
                                    
                                    NavigationLink(destination: OrbPlayerView(
                                        videoName: "root_chakra_recalibration",
                                        title: "Root Chakra"
                                    )) {
                                        BreathingOrbView(videoName: "root_chakra_recalibration")
                                    }
                                    .buttonStyle(.plain)
                                    .contentShape(Rectangle())   // 👈 THIS LINE IS THE FIX
                                    
                                    NavigationLink(destination: OrbPlayerView(
                                        videoName: "sacral_chakra",
                                        title: "Sacral Chakra"
                                    )) {
                                        BreathingOrbView(videoName: "sacral_chakra")
                                    }
                                    .buttonStyle(.plain)
                                    .contentShape(Rectangle())
                                    
                                    NavigationLink(destination: OrbPlayerView(
                                        videoName: "solar_chakra",
                                        title: "Solar Chakra"
                                    )) {
                                        BreathingOrbView(videoName: "solar_chakra")
                                    }
                                    .buttonStyle(.plain)
                                    .contentShape(Rectangle())
                                    
                                    NavigationLink(destination: OrbPlayerView(
                                        videoName: "heart_chakra",
                                        title: "Heart Chakra"
                                    )) {
                                        BreathingOrbView(videoName: "heart_chakra")
                                    }
                                    .buttonStyle(.plain)
                                    .contentShape(Rectangle())
                                    
                                    NavigationLink(destination: OrbPlayerView(
                                        videoName: "throat_chakra",
                                        title: "Throat Chakra"
                                    )) {
                                        BreathingOrbView(videoName: "throat_chakra")
                                    }
                                    .buttonStyle(.plain)
                                    .contentShape(Rectangle())
                                    
                                    NavigationLink(destination: OrbPlayerView(
                                        videoName: "third_eye_chakra",
                                        title: "Third-eye Chakra"
                                    )) {
                                        BreathingOrbView(videoName: "third_eye_chakra")
                                    }
                                    .buttonStyle(.plain)
                                    .contentShape(Rectangle())
                                    
                                    NavigationLink(destination: OrbPlayerView(
                                        videoName: "crown_chakra",
                                        title: "Crown Chakra"
                                    )) {
                                        BreathingOrbView(videoName: "crown_chakra")
                                    }
                                    .buttonStyle(.plain)
                                    .contentShape(Rectangle())
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
            
            .navigationDestination(isPresented: $showOrbPlayer) {
                OrbPlayerView(
                    videoName: selectedOrb ?? "",
                    title: "Root Chakra"
                )
            }
        }
    }


