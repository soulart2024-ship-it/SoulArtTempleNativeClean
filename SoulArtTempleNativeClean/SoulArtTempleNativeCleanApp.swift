import SwiftUI
import UIKit

enum BrandUI {
    static func applyTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.shadowColor = .clear
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

@main
struct SoulArtTempleNativeCleanApp: App {
    @StateObject var moodStore = MoodStore()
    @StateObject var galleryStore = GalleryStore()
    @StateObject var appState = AppState()
    @StateObject var purchaseManager = PurchaseManager.shared
    @StateObject var supabaseService = SupabaseService.shared

    init() {
        BrandUI.applyTabBarAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                AppRootView()
                    .environmentObject(moodStore)
                    .environmentObject(galleryStore)
                    .environmentObject(appState)
                    .environmentObject(purchaseManager)
                    .environmentObject(supabaseService)
                    .onAppear {
                        SupabaseService.shared.fetchAnnouncements()
                        SupabaseService.shared.fetchDailyQuote()
                    }
                
                
                FloatingMusicPlayer()
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AurumSupportButton(appState: appState)
                            .padding(.trailing, 20)
                            .padding(.bottom, 90)
                    }
                }
            }
        }
    }
}
