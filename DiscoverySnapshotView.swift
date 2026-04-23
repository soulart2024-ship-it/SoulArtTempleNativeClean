import SwiftUI

struct DiscoverySnapshotView: View {
    
    @EnvironmentObject var discoveryStore: DiscoveryStore
    
    var totalCount: Int {
        discoveryStore.items.reduce(0) { $0 + $1.count }
    }
    
    var sortedItems: [DiscoveryItem] {
        discoveryStore.items.sorted { $0.count > $1.count }
    }
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: Theme.spacingLarge) {
                
                Text("Your Emotional Snapshot")
                    .font(Theme.templeTitle)
                    .foregroundStyle(Theme.textPrimary)
                
                Text("This is your current identification map.")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textSecondary)
                
                // MARK: - Total
                
                Text("Total Stored Emotions: \(totalCount)")
                    .font(Theme.sectionTitle)
                    .foregroundStyle(Theme.textPrimary)
                
                // MARK: - List
                
                ForEach(sortedItems) { item in
                    
                    NavigationLink(destination: destinationView(for: item)){
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text(item.category)
                                .font(Theme.cardTitle)
                                .foregroundStyle(Theme.textOnDark)
                            
                            Text("Count: \(item.count)")
                                .font(Theme.bodyText)
                                .foregroundStyle(Theme.textOnDark)
                            
                            Text("Layers: \(item.hasLayers ? "Yes" : "No")")
                                .font(Theme.bodyText)
                                .foregroundStyle(Theme.textOnDark)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            item.count > 10
                            ? Color.red.opacity(0.15)
                            : Theme.cardSecondary
                        )
                        .cornerRadius(Theme.cardRadius)
                    }
                    
                    .buttonStyle(.plain)
                    
                    NavigationLink(destination: DecodersHomeView()) {
                        
                        Text("Start My Work")
                            .font(Theme.cardTitle)
                            .foregroundStyle(Theme.textOnDark)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.cardPrimary)
                            .cornerRadius(Theme.cardRadius)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                .padding()
            }
            
            .navigationTitle("Snapshot")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    func destinationView(for item: DiscoveryItem) -> some View {
        
        switch item.category {
            
        case "Common":
            return AnyView(
                EmotionDecoderView(
                    category: item.category,
                    count: item.count,
                    hasLayers: item.hasLayers
                )
                .environmentObject(discoveryStore)
            )
            
        case "Heart Shadows":
            return AnyView(
                SATHeartMatrixView()
            )
            
        case "Ancestral":
            return AnyView(
                    EmotionDecoderView(
                        category: item.category,
                        count: item.count,
                        hasLayers: item.hasLayers
                    )
                    .environmentObject(discoveryStore)
                )
        
            
        case "Body Coded":
            return AnyView(
                BodyDecoderView()
            )
            
        case "Aura / Field":
            return AnyView(
                EmotionDecoderView(
                    category: item.category,
                    count: item.count,
                    hasLayers: item.hasLayers
                )
                .environmentObject(discoveryStore)
            )
            
        default:
            return AnyView(
                EmotionDecoderView(
                    category: item.category,
                    count: item.count,
                    hasLayers: item.hasLayers
                )
                .environmentObject(discoveryStore)
            )
        }
    }
        
} // <- closes struct

#Preview {
    NavigationStack {
        DiscoverySnapshotView()
            .environmentObject(DiscoveryStore())
    }
}
