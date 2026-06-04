import SwiftUI
import Combine

// ============================================================
// MARK: - SupabaseService
// Step 1: Fetches announcements from Supabase only
// ============================================================

class SupabaseService: ObservableObject {

    static let shared = SupabaseService()

    private let url = "https://vjejstjyoimuwmgummwl.supabase.co/rest/v1/announcements"
    private let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZqZWpzdGp5b2ltdXdtZ3VtbXdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk3MDA3NzEsImV4cCI6MjA5NTI3Njc3MX0.XS-WmLSGMTTuvkTj_j2D5y0fDK6608WZtWkWtlqSE6I"

    @Published var announcements: [Announcement] = []
    @Published var dailyQuote: DailyQuote? = nil

    struct Announcement: Codable, Identifiable {
        let id: String
        let title: String
        let message: String
        let is_active: Bool
    }

    struct DailyQuote: Codable, Identifiable {
        let id: String
        let quote: String
        let author: String?
        let is_active: Bool
    }

    func fetchAnnouncements() {
        guard let reqURL = URL(string: "\(url)?is_active=eq.true&order=created_at.desc") else { return }
        var req = URLRequest(url: reqURL)
        req.setValue(key, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: req) { data, _, _ in
            guard let data = data,
                  let decoded = try? JSONDecoder().decode([Announcement].self, from: data)
            else { return }
            DispatchQueue.main.async {
                self.announcements = decoded
            }
        }.resume()
    }

    func fetchDailyQuote() {
        guard let reqURL = URL(string: "https://vjejstjyoimuwmgummwl.supabase.co/rest/v1/daily_content?is_active=eq.true&order=created_at.desc&limit=1") else { return }
        var req = URLRequest(url: reqURL)
        req.setValue(key, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: req) { data, _, _ in
            guard let data = data,
                  let decoded = try? JSONDecoder().decode([DailyQuote].self, from: data)
            else { return }
            DispatchQueue.main.async {
                self.dailyQuote = decoded.first
            }
        }.resume()
    }
}

// ============================================================
// MARK: - AnnouncementBanner
// Drop into TempleEntryView
// ============================================================

struct AnnouncementBanner: View {
    @EnvironmentObject var supabaseService: SupabaseService
    @State private var dismissed = false

    var body: some View {
        if !dismissed,
           let announcement = supabaseService.announcements.first {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(announcement.title)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.goldSoft)
                    Text(announcement.message)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(2)
                }
                Spacer()
                Button {
                    withAnimation { dismissed = true }
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .padding(12)
            .background(Theme.warmParchment.opacity(0.95))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.06), radius: 8)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}
