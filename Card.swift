import SwiftUI

struct Card: View {
    
    var title: String
    var subtitle: String
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            Text(title)
                .font(Theme.cardTitle)
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(Theme.cardSubtitle)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(Theme.cardPrimary)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Theme.goldSoft.opacity(0.1), lineWidth: 1)
        )
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 6
        )
    }
}
