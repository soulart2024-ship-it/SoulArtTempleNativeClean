//
//  JournalHistoryView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 26/03/2026.
//
import SwiftUI

struct JournalHistoryView: View {
    
    @EnvironmentObject var discoveryStore: DiscoveryStore
    
    
    var body: some View {
        
        ZStack {
            
            Theme.templeParchment
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Text("Your Journey")
                    .font(Theme.sectionTitle)
                    .foregroundStyle(Theme.textPrimary)
                
                if discoveryStore.sessions.isEmpty {
                    
                    VStack(spacing: 12) {
                        
                        Image(systemName: "leaf")
                            .font(.system(size: 28))
                            .foregroundStyle(Theme.textSecondary.opacity(0.5))
                        
                        Text("Your journey begins here")
                            .font(Theme.bodyText)
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("No sessions yet")
                            .foregroundStyle(Theme.textSecondary)
                        
                        Text("Each release will be reflected here gently.")
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .padding(.top, 60)
                    
                } else {
                    
                    ScrollView {
                        
                        VStack(spacing: 16) {
                            
                            ForEach(discoveryStore.sessions.sorted(by: { $0.date > $1.date })) { session in
                                
                                NavigationLink {
                                    
                                    if session.stage == "discovery" {
                                        DiscoverySessionDetailView(session: session)
                                    } else {
                                        SessionDetailView(session: session)
                                    }
                                    
                                } label: {
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        
                                        // 🎨 IMAGE PREVIEW
                                        if let data = session.imageData,
                                           let uiImage = UIImage(data: data) {
                                            
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: 120)
                                                .clipped()
                                                .cornerRadius(12)
                                        }
                                        
                                        // 📅 DATE
                                        Text(session.date, format: .dateTime.day().month().year())
                                            .font(Theme.cardTitle)
                                            .foregroundStyle(Theme.textPrimary)
                                        
                                        // 🧭 TYPE
                                        Text(typeLabel(for: session))
                                            .font(Theme.smallText)
                                            .foregroundStyle(Theme.textSecondary.opacity(0.7))
                                        
                                        // 🏷 CATEGORY / TITLE
                                        Text(titleLabel(for: session))
                                            .font(Theme.bodyText)
                                            .foregroundStyle(Theme.textPrimary)
                                        
                                        // 🌿 REFLECTION PREVIEW
                                        if let reflection = session.reflection {
                                            Text(String(reflection.prefix(80)) + (reflection.count > 80 ? "..." : ""))
                                                .font(Theme.smallText)
                                                .foregroundStyle(Theme.textSecondary.opacity(0.7))
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: Theme.cardRadius)
                                            .fill(Theme.cardPrimary)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.cardRadius)
                                            .stroke(borderColor(for: session), lineWidth: 1)
                                    )
                                    .shadow(color: Theme.goldSoft.opacity(0.08), radius: 8, y: 4)
                                    .padding(.horizontal)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.top, 10)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    
    // MARK: - FORMAT DATE
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // MARK: - TYPE LABEL
    
    func typeLabel(for session: SessionEntry) -> String {
        
        if session.emotion == "Oracle Reading" {
            return "🔮 Oracle Reading"
        } else if session.emotion == "Journal Entry" {
            return "📝 Reflection"
        } else if session.emotion == "Creative Expression" {
            return "🎨 Creative Expression"
        } else if !session.replacement.isEmpty {
            return "✨ Release"
        } else {
            return "🌿 Discovery"
        }
    }
    
    // MARK: - TITLE LABEL
    
    func titleLabel(for session: SessionEntry) -> String {
        
        if session.emotion == "Oracle Reading" {
            return "Guidance received"
        } else if session.emotion == "Journal Entry" {
            return "Personal reflection"
        } else {
            return session.emotion
        }
    }
    
    // MARK: - BORDER COLOR
    
    func borderColor(for session: SessionEntry) -> Color {
        
        if session.emotion == "Creative Expression" {
            return Theme.brandBlue.opacity(0.25)
        } else if session.emotion == "Oracle Reading" {
            return Theme.goldSoft.opacity(0.25)
        } else if !session.replacement.isEmpty {
            return Theme.brandBlue.opacity(0.25)
        } else {
            return Theme.goldSoft.opacity(0.2)
        }
    }
}
