import SwiftUI
import AVKit

struct DiscoveryGroundView: View {
    
    @State private var navigateNext = false
    @State private var isTransitioning = false
    @State private var breathing = false
    @State private var player = AVPlayer()
    @State private var showEducationModal = false
 
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // Background - parchment tone
                LinearGradient(
                    colors: [
                        Color(red: 0.96, green: 0.93, blue: 0.88),
                        Color(red: 0.92, green: 0.89, blue: 0.84)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    
                    Spacer()
                    
                    // Title
                    Text("Discovery Portal")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                    
                    // 🌿 GUIDED ARRIVAL CONTAINER
                    VStack(spacing: 20) {

                        Text("Begin your journey of release by grounding into a calm space")
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 30)

                        Text("There is nothing to force here.")
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary.opacity(0.7))
                            .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Together we will discover the category in which you are ready to release a shadow emotion from.")
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary.opacity(0.7))
                            .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .fixedSize(horizontal: false, vertical: true)

                        // ✨ BREATHING ORB
                        ZStack {
                            
                            // ✨ SOFT GOLD HALO
                            Circle()
                                .fill(Theme.goldSoft.opacity(0.2))
                                .frame(width: 160, height: 160)
                                .blur(radius: 30)
                            
                            // 🎥 VIDEO ORB
                            VideoPlayer(player: player)
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Theme.goldSoft.opacity(0.2), lineWidth: 1)
                                )
                                .scaleEffect(breathing ? 1.05 : 0.95)
                            
                                .animation(
                                    .easeInOut(duration: 5)
                                    .repeatForever(autoreverses: true),
                                    value: breathing
                                )
                            
                            // ✅ ON APPEAR
                                .onAppear {
                                    breathing = true
                                    
                                    if let url = Bundle.main.url(forResource: "crown_chakra", withExtension: "mp4") {
                                        player = AVPlayer(url: url)
                                        player.isMuted = true
                                        player.play()
                                        
                                        NotificationCenter.default.removeObserver(self)
                                        

                                        NotificationCenter.default.addObserver(
                                            forName: .AVPlayerItemDidPlayToEndTime,
                                            object: player.currentItem,
                                            queue: .main
                                        ) { _ in
                                            player.seek(to: .zero)
                                            player.play()
                                        }
                                    }
                                }
                            
                            // ✅ ON DISAPPEAR (THIS IS THE FIX)
                                .onDisappear {
                                    player.pause()
                                    player.replaceCurrentItem(with: nil)
                                }
                        }

                        .opacity(isTransitioning ? 0 : 1)
                        .scaleEffect(isTransitioning ? 0.98 : 1)
                        .blur(radius: isTransitioning ? 4 : 0)
                        .animation(.easeInOut(duration: 0.5), value: isTransitioning)
                            

                        Text("""
                    “I invite clarity, truth, and gentle awareness into this space.
                    I allow only what is ready to be seen.”
                    """)
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.textPrimary)
                            .multilineTextAlignment(.center)

                        NavigationLink {
                            GuidedCheckView(category: "General")
                        } label: {
                            Text("Try Guided Check")
                                .font(Theme.smallText)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .padding(.top, 6)
                        
                        Button {
                            // later → open your tutorial video modal
                        } label: {
                            Text("Watch How to Test")
                                .font(Theme.smallText)
                                .foregroundStyle(Theme.textSecondary.opacity(0.7))
                        }
                        
                        Button {
                            showEducationModal = true
                        } label: {
                            Text("Learn more…")
                                .font(Theme.smallText)
                                .foregroundStyle(Theme.textSecondary.opacity(0.7))
                        }
                        .padding(.top, 4)
          
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
                    
                    Spacer()
                    
                    // Continue Button
                    Button {
                        
                        // 🌿 BEGIN TRANSITION
                        isTransitioning = true
                        
                        // 🌿 SMALL DELAY BEFORE NAVIGATION
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                            
                            // ✅ SAVE COMPLETION
                            UserDefaults.standard.set(true, forKey: "hasCompletedDiscovery")
                            UserDefaults.standard.set("Common", forKey: "discoveryCategory")
                            UserDefaults.standard.set(12, forKey: "discoveryCount")
                            UserDefaults.standard.set(true, forKey: "discoveryHasLayers")
                            
                            navigateNext = true
                        }
                        
                    } label: {
                        Text("Let's us begin")
                            .font(.system(size: 18, weight: .medium))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black.opacity(0.85))
                            .foregroundStyle(.white)
                            .cornerRadius(14)
                            .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationDestination(isPresented: $navigateNext) {
            DiscoveryCategoryView()
        }
        .sheet(isPresented: $showEducationModal) {
            
            VStack(spacing: 20) {
                
                Text("How to Use This Space")
                    .font(Theme.sectionTitle)
                
                Text("This experience uses gentle awareness and body guidance. There is no right or wrong choice — simply notice what feels open or resonant in your body.")
                    .font(Theme.bodyText)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("Close") {
                    showEducationModal = false
                }
                .padding()
            }
            .padding()
        }
    }
}

#Preview {
    DiscoveryGroundView()
}
