//
//  LotusView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 24/03/2026.
//
import SwiftUI

struct LotusView: View {
    
    var isInhale: Bool
        var isHold: Bool
    
    var body: some View {
        
        ZStack {
            
            // ✨ OUTER BREATH AURA (very soft expansion)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.purple.opacity(0.15),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 260
                    )
                )
                .blur(radius: 60)
                .scaleEffect(isInhale ? 1.25 : 0.75)
                .animation(.easeInOut(duration: 5), value: isInhale)
            
            // 🌫 BACK GLOW (ambient energy)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.purple.opacity(0.6),
                            Color.blue.opacity(0.15),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 260
                    )
                )
                .blur(radius: 40)
                .scaleEffect(isInhale ? 1.18 : 0.82)
                .animation(.easeInOut(duration: 5), value: isInhale)
                .blur(radius: isInhale ? 0 : 1.5)
            
            
            // 🌸 BACK PETALS (slow, wide)
            ForEach(0..<6) { i in
                PetalShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.6),
                                Color.blue.opacity(0.4)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 80, height: 140)
                    .offset(y: isInhale ? -65 : -45)
                    .rotationEffect(.degrees(Double(i) * 60))
                    .opacity(isInhale ? 0.95 : 0.75)
                    .scaleEffect(isHold ? 0.96 : (isInhale ? 1.0 : 0.92))
                    .animation(.easeInOut(duration: 5), value: isInhale)
                    .blur(radius: 0.5)
            }
            
            
            // 🌸 MID PETALS (main bloom)
            ForEach(0..<6) { i in
                PetalShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.95),
                                Color.purple.opacity(0.6),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .blur(radius: isInhale ? 0.5 : 1.5)
                    .frame(width: 60, height: 110)
                    .offset(y: isInhale ? -50 : -35)
                    .rotationEffect(.degrees(Double(i) * 60 + 30))
                    .opacity(isInhale ? 0.9 : 0.7)
                    .scaleEffect(isHold ? 0.96 : (isInhale ? 1.0 : 0.92))
                    .animation(.easeInOut(duration: 5), value: isInhale)
            }
            
            
            // 🌸 INNER PETALS (tight layer)
            ForEach(0..<6) { i in
                PetalShape()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 40, height: 70)
                    .offset(y: isInhale ? -30 : -22)
                    .rotationEffect(.degrees(Double(i) * 60))
                    .opacity(isInhale ? 0.6 : 0.4)
                    .scaleEffect(isHold ? 0.96 : (isInhale ? 1.0 : 0.92))
                    .animation(.easeInOut(duration: 5), value: isInhale)
                
                    .scaleEffect(isInhale ? 1.02 : 0.98)
                    .animation(.easeInOut(duration: 5), value: isInhale)
                    .blur(radius: 0.5)
            }
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.orange.opacity(0.35),
                            Color.yellow.opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 120
                    )
                )
                .blur(radius: 20)
                .scaleEffect(isInhale ? 1.3 : 0.8)
                .animation(.easeInOut(duration: 5), value: isInhale)
            
            // ☀️ CORE (gold soul center)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.yellow,
                            Color.orange,
                            Color.yellow.opacity(0.4),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 5,
                        endRadius: 60
                    )
                )
                .frame(width: 50, height: 50)
                .shadow(color: Color.orange.opacity(0.6), radius: 25)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .blur(radius: 2)
                )
                .scaleEffect(isInhale ? 1.15 : 0.85)
                .animation(.easeInOut(duration: 5), value: isInhale)
                .rotationEffect(.degrees(isInhale ? 2 : -2))
        }
    }
}
struct PetalShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control1: CGPoint(x: rect.maxX, y: rect.midY * 0.6),
            control2: CGPoint(x: rect.maxX * 0.8, y: rect.maxY)
        )
        
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control1: CGPoint(x: rect.minX * 0.2, y: rect.maxY),
            control2: CGPoint(x: rect.minX, y: rect.midY * 0.6)
        )
        
        return path
    }
}
