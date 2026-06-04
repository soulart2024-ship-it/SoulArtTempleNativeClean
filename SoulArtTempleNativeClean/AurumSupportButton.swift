import SwiftUI

struct AurumSupportButton: View {
    
    @ObservedObject var appState: AppState
    @State private var isGlowing = false
    @State private var showAurum = false
    
    // 🎯 DRAGGING STATE
    @State private var position: CGPoint = .zero
    @State private var isDragging = false
    @State private var hasInitialized = false
    @State private var isHidden = false // Hidden to edge
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                
                // MAIN BUTTON (FULL SIZE)
                if !isHidden {
                    Button {
                        if !isDragging {
                            showAurum = true
                        }
                    } label: {
                        ZStack {
                            
                            // ✨ GLOW LAYER
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Theme.goldSoft.opacity(0.4),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 10,
                                        endRadius: 40
                                    )
                                )
                                .frame(width: 70, height: 70)
                                .blur(radius: 8)
                                .scaleEffect(isGlowing ? 1.2 : 1.0)
                                .opacity(isGlowing ? 0.8 : 0.4)
                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isGlowing)
                            
                            // 🔮 GLASS ORB
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 56, height: 56)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Theme.goldSoft.opacity(0.6),
                                                    Theme.goldSoft.opacity(0.2)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.5
                                        )
                                )
                                .shadow(color: Theme.goldSoft.opacity(0.3), radius: 10, y: 4)
                            
                            // 🌸 AURUM ART ICON
                            Image("aurum_art")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                        }
                    }
                    .buttonStyle(.plain)
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
                    .transition(.move(edge: position.x < geometry.size.width / 2 ? .leading : .trailing).combined(with: .opacity))
                }
                
                // HIDDEN TAB (SMALL ARROW)
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
                            
                            Image("aurum_art")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .clipShape(Circle())
                            
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
                                        .stroke(Theme.goldSoft.opacity(0.4), lineWidth: 1)
                                )
                        )
                        .shadow(color: Theme.goldSoft.opacity(0.2), radius: 8, y: 2)
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
            .onAppear {
                if !hasInitialized {
                    isGlowing = true
                    loadPosition(screenSize: geometry.size)
                    hasInitialized = true
                }
            }
            .fullScreenCover(isPresented: $showAurum) {
                AurumCompanionView()
                    .environmentObject(appState)
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
        let newY = max(padding, min(position.y, screenSize.height - padding))
        
        // Snap to nearest edge (left or right)
        if newX < screenSize.width / 2 {
            newX = padding // Snap to left
        } else {
            newX = screenSize.width - padding // Snap to right
        }
        
        position = CGPoint(x: newX, y: newY)
        savePosition()
    }
    
    // MARK: - PERSISTENCE
    
    private func savePosition() {
        UserDefaults.standard.set(position.x, forKey: "aurumButtonX")
        UserDefaults.standard.set(position.y, forKey: "aurumButtonY")
    }
    
    private func loadPosition(screenSize: CGSize) {
        let savedX = UserDefaults.standard.double(forKey: "aurumButtonX")
        let savedY = UserDefaults.standard.double(forKey: "aurumButtonY")
        
        if savedX > 0 && savedY > 0 {
            position = CGPoint(x: savedX, y: savedY)
        } else {
            // Default position (bottom-right)
            position = CGPoint(x: screenSize.width - 70, y: screenSize.height - 180)
        }
    }
}
