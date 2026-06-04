import SwiftUI


struct DoodleLoungeHomeView: View {
    
    @EnvironmentObject var moodStore: MoodStore
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // 🌊 BACKGROUND
                MoodBackgroundView(mood: moodStore.selectedMood)
                    .ignoresSafeArea()
                
                // 🌿 CONTENT (NOW INSIDE ZSTACK ✅)
                ScrollView {
                    
                    VStack(spacing: 20) {
                        
                        // 🌿 TITLE
                        VStack(spacing: 8) {
                            
                            Text("Creative Lounge")
                                .font(Theme.sectionTitle)
                                .foregroundStyle(Theme.textPrimary)
                            
                            Text("Choose how you’d like to express today")
                                .font(Theme.bodyText)
                                .foregroundStyle(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Spacer(minLength: 60)
                        
                        // ✏️ DOODLE ROOM
                        NavigationLink(destination: DoodleRoomView()) {
                            Card(
                                title: "Doodle",
                                subtitle: "Draw, trace and express freely"
                            )
                        }
                        .buttonStyle(.plain)
                        
                        // 🌊 FLUID ART
                        NavigationLink(destination: FluidArtView()) {
                            Card(
                                title: "Fluid Art",
                                subtitle: "Flowing ink and colour blending"
                            )
                        }
                        .buttonStyle(.plain)
                        
                        // 🌫 MEDITATION FLOW
                        NavigationLink(destination: FluidMeditationRoom()) {
                            Card(
                                title: "Meditation Flow",
                                subtitle: "Let colour move and dissolve"
                            )
                        }
                        .buttonStyle(.plain)
                        
                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
