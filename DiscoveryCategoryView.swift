import SwiftUI

// ✅ REQUIRED MODEL
struct CategoryNav: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct DiscoveryCategoryView: View {
    
    private let columns = [
        GridItem(.flexible(minimum: 140), spacing: 16),
        GridItem(.flexible(minimum: 140), spacing: 16)
    ]
    
    @State private var revealedCategory: String? = nil
    @State private var isRevealing = false
    @State private var navigateToCategory: CategoryNav? = nil
    @State private var glowPulse: Bool = false
    @State private var appear = false
    @State private var isTransitioning = false
    
    @EnvironmentObject var store: DiscoveryStore
    
    private let allCategories = [
        "Common",
        "Ancestral",
        "Heart Shadows",
        "Etheric",
        "Aura / Field",
        "DNA",
        "Third Trimester",
        "Twin (Dual)",
        "Deeply Hidden",
        "Stealth",
        "Body Coded",
        "Unidentified"   // ✅ NEW CATEGORY
    ]
    
    @State private var shuffledCategories: [String] = []
    
    var body: some View {
        
        ZStack {
            
            Theme.templeBackground
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack(spacing: Theme.spacingLarge) {
                    
                    Text("Let's begin your releasing journey.")
                        .font(Theme.sectionTitle)
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text("Allow your body to guide you to what category is ready to move")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    // 🌿 ADD THIS BLOCK RIGHT HERE
                    VStack(spacing: 10) {
                        
                        Text("Before selecting…")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary.opacity(0.5))
                        
                        Text("Gently say ‘yes’ out loud several times and notice how your body responds, then do the same for ‘no’, and notice the difference.")
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary.opacity(0.7))
                            .multilineTextAlignment(.center)
                        
                        Text("When you are comfortable, identify the tile by selecting the category that feels ready to release.")
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary.opacity(0.7))
                            .multilineTextAlignment(.center)
                        
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 6)
                    .opacity(isTransitioning ? 0 : 1)
                    .scaleEffect(isTransitioning ? 0.98 : 1)
                    .blur(radius: isTransitioning ? 4 : 0)
                    .animation(.easeInOut(duration: 0.45), value: isTransitioning)
                    
                    VStack(spacing: 16) {
                        
                        // 🌿 COLUMN LABELS (A / B)
                        HStack {
                            Spacer()
                            
                            Text("A")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary.opacity(0.5))
                                .frame(maxWidth: .infinity)
                            
                            Text("B")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary.opacity(0.5))
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 30)
                        
                        // 🌿 GRID + ROW LABELS
                        HStack(alignment: .top, spacing: 16) {
                            
                            // 🌿 ROW NUMBERS
                            VStack(spacing: 24) {
                                ForEach(1...6, id: \.self) { row in
                                    Text("\(row)")
                                        .font(.caption2)
                                        .foregroundStyle(Theme.textSecondary.opacity(0.4))
                                        .frame(height: 135) // 👈 MUST match tile height
                                }
                            }
                            
                            // 🌿 GRID
                            LazyVGrid(columns: columns, spacing: 14) {
                                ForEach(Array(shuffledCategories.enumerated()), id: \.element) { index, category in
                                    navCard(category)
                                }
                            }
                        }
                        .padding(.horizontal, 10) // 👈 THIS restores the breathing space
                    }
                    .padding(.top, 14)
                }
                .opacity(appear ? 1 : 0)
                .scaleEffect(appear ? 1 : 0.96)
                .animation(.easeOut(duration: 0.6), value: appear)
            }
        }
        .navigationTitle("Discovery")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            shuffledCategories = allCategories.shuffled()
            
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                glowPulse.toggle()
            }
            appear = true
        }
        .navigationDestination(item: $navigateToCategory) { item in
            EmotionDecoderView(
                category: item.name,
                count: 0,
                hasLayers: false
            )
        }
    }
    
    // MARK: - Card
    
    private func navCard(_ title: String) -> some View{
        
        ZStack {
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.templeParchment)
                
                // 🌿 STILL ART LAYER
                Image("still_art")
                    .resizable()
                    .scaledToFill()
                    .opacity(revealedCategory == title ? 0.28 : 0.16)
                    .scaleEffect(revealedCategory == title ? 1.02 : 1.0)
                    .animation(.easeInOut(duration: 0.4), value: revealedCategory) // 👈 subtle, adjust 0.12–0.22
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // 🌿 GLOW LAYER (keeps your “alive” feeling)
                RadialGradient(
                    colors: [
                        Theme.goldSoft.opacity(glowPulse ? 0.12 : 0.04),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 20,
                    endRadius: 120
                )
                .blendMode(.plusLighter)
            }
            .shadow(color: Color.white.opacity(0.5), radius: 2, x: -2, y: -2)
            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isRevealing && revealedCategory == title
                        ? Theme.brandBlue.opacity(0.3)
                        : .clear,
                        lineWidth: 1
                    )
            )
            
            VStack(spacing: 6) {
                
                
                
                ZStack {
                    
                    
                    Text(title)
                        .font(Theme.cardTitle)
                        .foregroundStyle(Theme.textPrimary)
                        .opacity(isRevealing && revealedCategory == title ? 1 : 0)
                }
            }
            .frame(minHeight: 135)
            .scaleEffect(isRevealing && revealedCategory == title ? 1.06 : 1.0)
            .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isRevealing)
        }
        .onTapGesture {
            
            Haptics.light()
            
            revealedCategory = title
            
            // 🌿 SAVE DISCOVERY FIRST
            store.addDiscoverySession(
                category: title,
                count: 0,
                hasLayers: false
            )
            
            // 🌿 STEP 1 — TILE RESPONSE
            withAnimation(.easeInOut(duration: 0.3)) {
                isRevealing = true
            }
            
            // 🌿 STEP 2 — SCREEN TRANSITION
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                isTransitioning = true
            }
            
            // 🌿 STEP 3 — NAVIGATE
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isRevealing = false
                navigateToCategory = CategoryNav(name: title)
            }
        }
    }
}
