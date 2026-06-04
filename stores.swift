import SwiftUI


    var body: some View {
        
        ZStack {
            
            // Same soft background
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.93, blue: 0.88),
                    Color(red: 0.92, green: 0.89, blue: 0.84)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Text("Category Identification")
                    .font(.title2.bold())
                
                Text("This is where your 11 emotion categories will appear.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
            }
        }
    }

#Preview {
    DiscoveryCategoryView()
}
//  stores.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 12/03/2026.
//

