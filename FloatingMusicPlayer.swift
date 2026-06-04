import SwiftUI

struct FloatingMusicPlayer: View {
    
    @ObservedObject var player = MusicPlayer.shared
    
    let tracks = [
        "417hz",
        "432hz",
        "528hz",
        "639hz",
        "741hz",
        "852hz",
        "888hz",
        "963hz"
    ]
    
    @State private var position: CGPoint = .zero
    @State private var isDragging = false
    @State private var hasInitialized = false
    @State private var isHidden = false
    @State private var isCollapsed = false
    
    var body: some View {
        
        GeometryReader { geometry in
            
            if player.currentTrack != nil && player.showPlayer {
                
                ZStack {
                    
                    // FULL PLAYER
                    if !isHidden && !isCollapsed {
                        HStack(spacing: 16) {
                            
                            // TRACK MENU
                            Menu {
                                ForEach(tracks, id: \.self) { track in
                                    Button(track.replacingOccurrences(of: "hz", with: " Hz")) {
                                        MusicPlayer.shared.playTrack(track)
                                    }
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Text(player.currentTrack?.replacingOccurrences(of: "hz", with: " Hz") ?? "Choose")
                                        .font(.caption)
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 10))
                                }
                                .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            // PLAY/PAUSE
                            Button {
                                if player.isPaused {
                                    player.resumeSound()
                                } else {
                                    player.pauseSound()
                                }
                            } label: {
                                Image(systemName: player.isPaused ? "play.fill" : "pause.fill")
                                    .foregroundColor(.white)
                            }
                            
                            // STOP
                            Button {
                                player.stopSound()
                            } label: {
                                Image(systemName: "stop.fill")
                                    .foregroundColor(.white)
                            }
                            
                            // COLLAPSE
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    isCollapsed = true
                                }
                            } label: {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                )
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 10, y: 5)
                        .frame(maxWidth: 320)
                        .position(position)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                    position = value.location
                                }
                                .onEnded { _ in
                                    handleDragEnd(screenSize: geometry.size)
                                }
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // COLLAPSED TAB
                    if isCollapsed && !isHidden {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                isCollapsed = false
                            }
                        } label: {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "music.note")
                                        .foregroundColor(.white)
                                )
                                .shadow(color: Color.black.opacity(0.2), radius: 8, y: 2)
                        }
                        .position(position)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                    position = value.location
                                }
                                .onEnded { _ in
                                    handleDragEnd(screenSize: geometry.size)
                                }
                        )
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    // HIDDEN TAB (EDGE)
                    if isHidden {
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                isHidden = false
                            }
                        } label: {
                            HStack(spacing: 4) {
                                if position.x > geometry.size.width / 2 {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 12, weight: .semibold))
                                }
                                
                                Image(systemName: "music.note")
                                    .font(.system(size: 16))
                                
                                if position.x < geometry.size.width / 2 {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .semibold))
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 6)
                            .background(
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 8, y: 2)
                        }
                        .position(
                            x: position.x < geometry.size.width / 2 ? 20 : geometry.size.width - 20,
                            y: position.y
                        )
                        .transition(.move(edge: position.x < geometry.size.width / 2 ? .leading : .trailing).combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: position)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isHidden)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCollapsed)
                .onAppear {
                    if !hasInitialized {
                        loadPosition(screenSize: geometry.size)
                        hasInitialized = true
                    }
                }
            }
        }
    }
    
    // MARK: - HANDLE DRAG END
    
    private func handleDragEnd(screenSize: CGSize) {
        let edgeThreshold: CGFloat = 60
        
        // Check if dragged to edge
        if position.x < edgeThreshold || position.x > screenSize.width - edgeThreshold {
            // Hide to edge
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isHidden = true
            }
        } else {
            // Snap to nearest edge
            snapToEdge(screenSize: screenSize)
        }
        
        // Reset dragging after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isDragging = false
        }
    }
    
    // MARK: - SNAP TO EDGE
    
    private func snapToEdge(screenSize: CGSize) {
        let padding: CGFloat = 40
        
        // Clamp to screen bounds
        var newX = max(padding, min(position.x, screenSize.width - padding))
        let newY = max(100, min(position.y, screenSize.height - 100))
        
        // Snap to nearest edge (left or right)
        if newX < screenSize.width / 2 {
            newX = padding
        } else {
            newX = screenSize.width - padding
        }
        
        position = CGPoint(x: newX, y: newY)
        savePosition()
    }
    
    // MARK: - PERSISTENCE
    
    private func savePosition() {
        UserDefaults.standard.set(position.x, forKey: "musicPlayerX")
        UserDefaults.standard.set(position.y, forKey: "musicPlayerY")
    }
    
    private func loadPosition(screenSize: CGSize) {
        let savedX = UserDefaults.standard.double(forKey: "musicPlayerX")
        let savedY = UserDefaults.standard.double(forKey: "musicPlayerY")
        
        if savedX > 0 && savedY > 0 {
            position = CGPoint(x: savedX, y: savedY)
        } else {
            // Default position (top-right)
            position = CGPoint(x: screenSize.width - 180, y: 80)
        }
    }
}
