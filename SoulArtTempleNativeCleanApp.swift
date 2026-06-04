import SwiftUI
import UIKit



enum BrandUI {
    static func applyTabBarAppearance() {
        let appearance = UITabBarAppearance()
        
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        
        // 🔥 THIS IS THE MAGIC
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
    
    init() {
        BrandUI.applyTabBarAppearance() // ✅ THIS LINE FIXES YOUR WHITE BLOCK
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                AppRootView()
                    .environmentObject(moodStore)
                    .environmentObject(galleryStore)
                
                FloatingMusicPlayer()
            }
        }
    }
}
