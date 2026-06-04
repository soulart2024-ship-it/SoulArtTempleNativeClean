import SwiftUI
import UIKit
import Combine

// MARK: - DisplayLink Driver

final class FlowerDriver: ObservableObject {
    @Published var time: Double = 0
    @Published var scale: CGFloat = 0.6

    private var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval = 0
    var targetScale: CGFloat = 0.65

    func start() {
        startTime = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 120)
        displayLink?.add(to: .main, forMode: .common)
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func tick(link: CADisplayLink) {
        time = CACurrentMediaTime() - startTime
        // Smooth lerp toward target — runs every frame so buttery smooth
        scale += (targetScale - scale) * 0.012
    }
}

// MARK: - BreathingFlowerView

struct BreathingFlowerView: View {

    let isInhale: Bool
    let isHold: Bool
    let isBreathing: Bool

    @StateObject private var driver = FlowerDriver()

    private var hue1: Double { isHold ? 38  : isInhale ? 270 : 215 }
    private var hue2: Double { isHold ? 48  : isInhale ? 285 : 195 }
    private var sat1: Double { isHold ? 75  : isInhale ? 55  : 65  }
    private var lit1: Double { isHold ? 68  : isInhale ? 62  : 70  }

    private var targetScale: CGFloat {
        if !isBreathing { return 0.65 }
        if isHold       { return driver.scale } // freeze
        return isInhale ? 1.0 : 0.52
    }

    var body: some View {
        Canvas { ctx, size in
            let t  = driver.time
            let s  = driver.scale
            let cx = size.width  / 2
            let cy = size.height / 2

            // ── Outer ambient glow ──────────────────────────────────────
            let glowPath = Path(ellipseIn: CGRect(
                x: cx - 130*s, y: cy - 130*s,
                width: 260*s,  height: 260*s
            ))
            ctx.fill(glowPath, with: .color(
                Color(hue: hue1/360, saturation: sat1/100, brightness: 0.9).opacity(0.28)
            ))

            // ── Outer petals (forward rotate) ───────────────────────────
            for i in 0..<8 {
                let fi      = Double(i)
                let wave    = sin(t * 2.2 + fi * 0.8) * 0.09
                let waveLen = sin(t * 1.8 + fi * 1.1) * 0.065
                let angle   = (fi / 8.0) * .pi * 2 + t * 0.18 + wave
                let ps      = s * CGFloat(1 + waveLen)
                let len     = 86 * ps
                let wid     = 24 * ps
                let shimmer = lit1 + sin(t * 3 + fi) * 6
                let alpha   = 0.85 + sin(t * 2 + fi * 0.7) * 0.1

                let tfm  = CGAffineTransform(translationX: cx, y: cy).rotated(by: angle)
                let path = Path(ellipseIn: CGRect(x: -wid/2, y: -len, width: wid, height: len))
                    .applying(tfm)
                ctx.fill(path, with: .color(
                    Color(hue: hue1/360, saturation: sat1/100, brightness: shimmer/100).opacity(alpha)
                ))
            }

            // ── Mid petals (counter-rotate) ─────────────────────────────
            for i in 0..<8 {
                let fi      = Double(i)
                let wave    = sin(t * 2.8 + fi * 1.2) * 0.1
                let waveLen = sin(t * 2.1 + fi * 0.9) * 0.06
                let angle   = (fi / 8.0) * .pi * 2 + .pi/8 - t * 0.12 + wave
                let ps      = s * CGFloat(0.58 + waveLen)
                let len     = 82 * ps
                let wid     = 18 * ps
                let alpha   = 0.78 + sin(t * 2.5 + fi) * 0.1

                let tfm  = CGAffineTransform(translationX: cx, y: cy).rotated(by: angle)
                let path = Path(ellipseIn: CGRect(x: -wid/2, y: -len, width: wid, height: len))
                    .applying(tfm)
                ctx.fill(path, with: .color(
                    Color(hue: hue2/360, saturation: (sat1-5)/100, brightness: 0.92).opacity(alpha)
                ))
            }

            // ── Inner tight petals (fast ripple) ────────────────────────
            for i in 0..<6 {
                let fi    = Double(i)
                let wave  = sin(t * 4.2 + fi * 1.5) * 0.14
                let angle = (fi / 6.0) * .pi * 2 + t * 0.28 + wave
                let len   = 30 * s
                let wid   = 9  * s
                let alpha = 0.80 + sin(t * 3.2 + fi) * 0.12

                let tfm  = CGAffineTransform(translationX: cx, y: cy).rotated(by: angle)
                let path = Path(ellipseIn: CGRect(x: -wid/2, y: -len, width: wid, height: len))
                    .applying(tfm)
                ctx.fill(path, with: .color(
                    Color(hue: (hue1+10)/360, saturation: 0.65, brightness: 0.94).opacity(alpha)
                ))
            }

            // ── Golden stamen ring ──────────────────────────────────────
            for i in 0..<12 {
                let fi    = Double(i)
                let angle = (fi / 12.0) * .pi * 2 + t * 0.5
                let r     = 22 * s
                let dx    = cx + cos(angle) * r
                let dy    = cy + sin(angle) * r
                let dotR  = 2.2 * s
                let alpha = 0.75 + sin(t * 3 + fi * 0.8) * 0.2

                let path = Path(ellipseIn: CGRect(x: dx-dotR, y: dy-dotR, width: dotR*2, height: dotR*2))
                ctx.fill(path, with: .color(
                    Color(hue: 45/360, saturation: 0.85, brightness: 0.92).opacity(alpha)
                ))
            }

            // ── Core ────────────────────────────────────────────────────
            let coreR = 17 * s
            let corePath = Path(ellipseIn: CGRect(x: cx-coreR, y: cy-coreR, width: coreR*2, height: coreR*2))
            ctx.fill(corePath, with: .color(
                Color(hue: hue1/360, saturation: 0.4, brightness: 0.97).opacity(0.97)
            ))

            // ── Core highlight ──────────────────────────────────────────
            let hlPath = Path(ellipseIn: CGRect(x: cx-4*s-5*s, y: cy-4*s-5*s, width: 10*s, height: 10*s))
            ctx.fill(hlPath, with: .color(.white.opacity(0.85)))
        }
        .onAppear {
            driver.targetScale = targetScale
            driver.start()
        }
        .onDisappear {
            driver.stop()
        }
        .onChange(of: isInhale)    { _, _ in driver.targetScale = targetScale }
        .onChange(of: isHold)      { _, _ in driver.targetScale = targetScale }
        .onChange(of: isBreathing) { _, _ in driver.targetScale = targetScale }
    }
}
