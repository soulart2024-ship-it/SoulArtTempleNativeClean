//
//  MandalaView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 24/03/2026.

import SwiftUI

struct MandalaView: View {
    
    var isInhale: Bool
    
    var body: some View {
        
        ZStack {
            
            // 🌿 Ambient glow (soft premium background)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.purple.opacity(0.25),
                            Color.blue.opacity(0.15),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 180
                    )
                )
                .frame(width: 260, height: 260)
                .blur(radius: 20)
                .scaleEffect(isInhale ? 1.2 : 0.9)
                .animation(.easeInOut(duration: 5), value: isInhale)
            
            
            // 🌿 Mandala petals (layered for depth)
            ForEach(0..<12) { i in
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.9),
                                Color.purple.opacity(0.6),
                                Color.blue.opacity(0.4)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 22, height: 90)
                    .offset(y: -45)
                    .rotationEffect(.degrees(Double(i) * 30))
                    .opacity(isInhale ? 1 : 0.6)
                    .scaleEffect(isInhale ? 1.05 : 0.85)
                    .animation(.easeInOut(duration: 5), value: isInhale)
            }
            
            
            // 🌿 Inner layer (soft secondary petals)
            ForEach(0..<12) { i in
                Capsule()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 14, height: 55)
                    .offset(y: -28)
                    .rotationEffect(.degrees(Double(i) * 30))
                    .opacity(isInhale ? 0.7 : 0.3)
                    .animation(.easeInOut(duration: 5), value: isInhale)
            }
            
            
            // 🌿 Golden center (soul core)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.yellow,
                            Color.orange,
                            Color.yellow.opacity(0.6)
                        ],
                        center: .center,
                        startRadius: 5,
                        endRadius: 40
                    )
                )
                .frame(width: 45, height: 45)
                .shadow(color: Color.yellow.opacity(0.6), radius: 15)
        }
    }
}

