import SwiftUI

struct BurnView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var isReleasing = false
    
    var emotion: String
    var onComplete: (String) -> Void
    
    var body: some View {
        
        
        ZStack {
            
            Theme.templeParchment
                .ignoresSafeArea()
            
            Theme.burnGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                Spacer()
                
                // 🌿 Orb
                   Circle()
                       .fill(Theme.goldSoft.opacity(0.25))
                       .frame(width: 220, height: 220)
                       .blur(radius: isReleasing ? 60 : 20)
                       .scaleEffect(isReleasing ? 1.2 : 0.8)
                       .opacity(isReleasing ? 1 : 0.4)
                       .animation(.easeInOut(duration: 1.5), value: isReleasing)
                   
                   // 🔥 Emotion text INSIDE orb
                   Text(emotion)
                       .font(Theme.sectionTitle)
                       .foregroundStyle(
                           isReleasing
                           ? Color(red: 0.75, green: 0.40, blue: 0.20)
                           : Theme.textPrimary
                       )
                       .opacity(isReleasing ? 0 : 1)
                       .scaleEffect(isReleasing ? 1.1 : 1.0)
                       .offset(y: isReleasing ? -60 : 0)
                       .blur(radius: isReleasing ? 8 : 0)
                       .animation(.easeInOut(duration: 1.6), value: isReleasing)
                    
                
                Text("Releasing…")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textSecondary.opacity(0.6))
                    .opacity(isReleasing ? 0 : 1)
                    .blur(radius: isReleasing ? 4 : 0)
                    .animation(.easeInOut(duration: 1.2).delay(0.3), value: isReleasing)
            
            .onAppear {
                isReleasing = true
            }
                Spacer()
                
                ZStack {
                    
                    // 🌿 Outer soft glow (wide + diffused)
                    RoundedRectangle(cornerRadius: Theme.buttonRadius)
                        .fill(Theme.goldSoft.opacity(0.08))
                        .frame(height: 60)
                        .blur(radius: 50)
                    
                    // 🌿 Inner glow (closer, warmer)
                    RoundedRectangle(cornerRadius: Theme.buttonRadius)
                        .fill(Theme.goldSoft.opacity(0.18))
                        .frame(height: 60)
                        .blur(radius: 20)
                        .opacity(isReleasing ? 1 : 0.5)
                        .animation(.easeInOut(duration: 1.5), value: isReleasing)
                    
                    // 🔘 Button
                    Button {
                        onComplete(emotion)
                        dismiss()
                    } label: {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.deepBrown)
                            .foregroundStyle(.white)
                            .cornerRadius(Theme.buttonRadius)
                            .padding(.horizontal, 40)
                    }
                }
                
                Spacer()
            }
        }
    }
    
}
