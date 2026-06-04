import SwiftUI

struct OracleCardView: View {
    
    var card: OracleCard
    
    @State private var isFlipped = false
    @State private var pulse = false
    
    private func triggerHaptic() {
        
        let generator: UIImpactFeedbackGenerator
        
        switch card.type {
            
        case .soulArt:
            generator = UIImpactFeedbackGenerator(style: .soft)
            
        case .sacredSignature:
            generator = UIImpactFeedbackGenerator(style: .medium)
            
        case .blessing:
            generator = UIImpactFeedbackGenerator(style: .light)
        }
        
        generator.prepare()
        generator.impactOccurred()
    }
    
    var body: some View {
        
        ZStack {
            
            // FRONT / BACK SWITCH
            if isFlipped {
                cardBack
            } else {
                cardFront
            }
        }
        
        
        .frame(width: 180, height: 260)
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.6), value: isFlipped)
        .onTapGesture {
            triggerHaptic()
            isFlipped.toggle()
        }
    }
    
}
private extension OracleCardView {
    
    var cardFront: some View {
        
        ZStack {
            
            Image(frontImageName)
                .resizable()
                .scaledToFill()
                .frame(width: 180, height: 260)
                .clipped()
            
            // ✨ Sacred shimmer
            if card.type == .sacredSignature {
                sacredShimmer
            }
            
            // 🌸 Blessing glow
            if card.type == .blessing {
                blessingGlow
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
private extension OracleCardView {
    
    var cardBack: some View {
        
        ZStack {
            
            if card.type == .soulArt {
                chakraOrb
            }
            
            VStack(spacing: 10) {
                
                Text(card.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                
                if let frequency = card.frequency {
                    Text("Frequency: \(frequency)")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary)
                }
                
                if let colour = card.colour {
                    Text("Colour: \(colour)")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary)
                }
                
                Text(card.message)
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)   // 👈 ADD
                     .fixedSize(horizontal: false, vertical: true)
                
                if let activation = card.activation {
                    Text("Activation: \(activation)")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)   // 👈 ADD
                         .fixedSize(horizontal: false, vertical: true)
                }
                
                if let affirmation = card.affirmation {
                    Text(affirmation)
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textPrimary)
                        .italic()
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)   // 👈 ADD
                         .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(16)
        .frame(width: 180, height: 290)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(cardBackground)
        )
        .rotation3DEffect(
            .degrees(180),
            axis: (x: 0, y: 1, z: 0)
        )
    }
}
private extension OracleCardView {
    
    var frontImageName: String {
        
        switch card.type {
            
        case .soulArt:
            return "oracle-cards"   // 🎨 your SoulArt deck image
            
        case .sacredSignature:
            return "sacred_temple_oracle_card_view"
            
        case .blessing:
            return "louise_hays_blessings"
        }
    }
    
}
private extension OracleCardView {
    
    var cardBackground: Color {
        
        switch card.type {
            
        case .soulArt:
            return Color.white.opacity(0.95)
            
        case .sacredSignature:
            return Theme.goldSoft.opacity(0.25)
            
        case .blessing:
            return Theme.softCream
        }
    }
}
private extension OracleCardView {
    
        var chakraOrb: some View {
            
            Circle()
                .fill(chakraColor.opacity(0.25))
                .frame(width: 140, height: 140)
                .scaleEffect(isFlipped ? 1.2 : (pulse ? 1.05 : 0.95))
                .blur(radius: isFlipped ? 35 : 25)
                .opacity(isFlipped ? 0.5 : 0.25)
                .animation(.easeInOut(duration: 0.6), value: isFlipped)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulse)
                .onAppear {
                    pulse = true
                }
                .overlay(
                    Circle()
                        .stroke(chakraColor.opacity(0.5), lineWidth: 1)
                )
        }
}
private extension OracleCardView {
    
    var chakraColor: Color {
        
        guard let frequency = card.frequency else {
            return .clear
        }
        
        switch frequency {
            
        case 400..<484:
            return .red
            
        case 484..<508:
            return .orange
            
        case 508..<526:
            return .yellow
            
        case 526..<606:
            return .green
            
        case 606..<668:
            return .blue
            
        case 668..<789:
            return .purple
            
        default:
            return .white
        }
    }
}
private extension OracleCardView {
    
    var sacredShimmer: some View {
        
        LinearGradient(
            colors: [
                .clear,
                Theme.goldSoft.opacity(0.4),
                .clear
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .blendMode(.screen)
        .opacity(0.6)
    }
}
private extension OracleCardView {
    
    var blessingGlow: some View {
        
        Circle()
            .fill(Color.white.opacity(0.2))
            .frame(width: 160, height: 160)
            .blur(radius: 30)
            .opacity(0.6)
    }
}
