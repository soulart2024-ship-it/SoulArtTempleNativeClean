//
//  JournalViewWithImage.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 11/04/2026.
//

import SwiftUI

struct JournalViewWithImage: View {
    @EnvironmentObject var discoveryStore: DiscoveryStore
    @Environment(\.dismiss) var dismiss
    
    var image: UIImage?
    @State private var reflection: String = ""
    @State private var showNextStepOptions = false
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(16)
                        .shadow(radius: 8)
                }
                
                Text("What did this express?")
                    .font(Theme.sectionTitle)
                
                TextEditor(text: $reflection)
                    .frame(height: 150)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                
                Button("Save Reflection") {
                    
                    let session = SessionEntry(
                        id: UUID(),
                        type: "creative", // ✅ MOVE HERE
                        emotion: "Creative Expression",
                        category: "Creative",
                        date: Date(),
                        reflection: reflection,
                        replacement: "",
                        meaning: "Artwork Expression",
                        imageData: image?.jpegData(compressionQuality: 0.8)
                        
                    )
                    
                    discoveryStore.sessions.insert(session, at: 0)
                    discoveryStore.saveSessions()
                    
                    showNextStepOptions = true
                }
                if showNextStepOptions {
                    
                    VStack(spacing: 12) {
                        
                        Button("Create Again") {
                            dismiss() // back to doodle
                        }
                        
                        Button("Complete") {
                            dismiss()
                            dismiss() // go home
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
