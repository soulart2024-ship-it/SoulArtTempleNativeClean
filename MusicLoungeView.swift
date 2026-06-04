import SwiftUI

struct MusicLoungeView: View {
    
    var body: some View {
        
        ZStack {
            
            Theme.templeParchment
                .ignoresSafeArea()

            // 🌿 BASE WARM TONE
            Theme.warmOverlay
                .opacity(0.18)
                .ignoresSafeArea()

            // 🌿 EDGE DEPTH (SUBTLE VIGNETTE)
            RadialGradient(
                colors: [
                    Color.clear,
                    Theme.warmOverlayDeep.opacity(0.25)
                ],
                center: .center,
                startRadius: 150,
                endRadius: 600
            )
            .ignoresSafeArea()
            
            
            VStack(spacing: 24) {
                
                Spacer()
                
                // 🔒 LOCK ICON
                Image(systemName: "lock.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Theme.goldSoft.opacity(0.6))
                
                // 🌿 TITLE
                Text("Music Lounge")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Theme.textPrimary)
                
                Text("Unlocking Soon")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textSecondary)
                
                Text("We're curating a collection of frequency-tuned soundscapes to support your practice.")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textSecondary.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
