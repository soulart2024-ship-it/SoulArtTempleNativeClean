import SwiftUI

// ============================================================
// Shared style — matches your existing warm ink tone
// ============================================================
private let ink = Color(red: 0.35, green: 0.25, blue: 0.15).opacity(0.28)
private let lw2: CGFloat = 1.8



// MARK: - OCEAN DREAMS
// Waves, fish, shells, seahorse, bubbles
// ============================================================

struct OceanDreamsShape: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                // Wave bands
                ForEach(0..<4) { i in
                    Path { p in
                        let y = h * CGFloat(0.2 + Double(i) * 0.18)
                        p.move(to: CGPoint(x: 0, y: y))
                        var x: CGFloat = 0
                        while x <= w {
                            let phase = Double(x/w) * .pi * 3
                            let wy = y + CGFloat(sin(phase + Double(i))) * 10
                            p.addLine(to: CGPoint(x: x, y: wy))
                            x += 3
                        }
                    }
                    .stroke(ink.opacity(0.5), lineWidth: lw2 * 0.6)
                }
                // Fish
                DoodleFish(size: 50).position(x: w*0.3, y: h*0.3)
                DoodleFish(size: 34).rotationEffect(.degrees(180)).position(x: w*0.72, y: h*0.5)
                DoodleFish(size: 24).position(x: w*0.55, y: h*0.72)
                // Shell
                DoodleShell(size: 38).position(x: w*0.18, y: h*0.68)
                DoodleShell(size: 24).position(x: w*0.78, y: h*0.78)
                // Seahorse
                DoodleSeahorse().position(x: w*0.75, y: h*0.25)
                // Starfish
                DoodleStar(size: 22).position(x: w*0.42, y: h*0.88)
                DoodleStar(size: 14).position(x: w*0.12, y: h*0.88)
                // Bubbles
                ForEach([
                    (w*0.15, h*0.18, 14.0),
                    (w*0.55, h*0.12, 10.0),
                    (w*0.85, h*0.6,  8.0),
                    (w*0.38, h*0.55, 6.0),
                    (w*0.62, h*0.38, 12.0),
                    (w*0.88, h*0.12, 7.0)
                ], id: \.0) { x, y, s in
                    Circle().stroke(ink, lineWidth: lw2*0.7).frame(width: s).position(x: x, y: y)
                }
            }
        }
    }
}


// ============================================================
// MARK: - REUSABLE DOODLE COMPONENTS
// ============================================================

struct DoodleStar: View {
    let size: CGFloat
    var body: some View {
        Path { p in
            for i in 0..<5 {
                let a = Double(i) * .pi * 2 / 5 - .pi / 2
                let ia = a + .pi / 5
                let outer = CGPoint(x: cos(a)*size, y: sin(a)*size)
                let inner = CGPoint(x: cos(ia)*size*0.4, y: sin(ia)*size*0.4)
                if i == 0 { p.move(to: outer) } else { p.addLine(to: outer) }
                p.addLine(to: inner)
            }
            p.closeSubpath()
        }
        .stroke(ink, lineWidth: lw2*0.8)
    }
}




struct DoodleFish: View {
    let size: CGFloat
    var body: some View {
        ZStack {
            // body
            Ellipse().stroke(ink, lineWidth: lw2).frame(width: size, height: size*0.5)
            // tail
            Path { p in
                p.move(to: CGPoint(x: size*0.5, y: 0))
                p.addLine(to: CGPoint(x: size*0.75, y: -size*0.2))
                p.addLine(to: CGPoint(x: size*0.75, y: size*0.2))
                p.closeSubpath()
            }
            .stroke(ink, lineWidth: lw2)
            // eye
            Circle().fill(ink).frame(width: 5).offset(x: -size*0.28, y: -size*0.04)
            // fin
            Path { p in
                p.move(to: CGPoint(x: 0, y: -size*0.22))
                p.addCurve(to: CGPoint(x: size*0.2, y: -size*0.22),
                           control1: CGPoint(x: size*0.05, y: -size*0.4),
                           control2: CGPoint(x: size*0.15, y: -size*0.4))
            }
            .stroke(ink, lineWidth: lw2*0.8)
        }
    }
}

struct DoodleShell: View {
    let size: CGFloat
    var body: some View {
        ZStack {
            Path { p in
                p.move(to: CGPoint(x: 0, y: size*0.5))
                for i in 0..<45 {
                    let t = CGFloat(i) / 44.0
                    let a = t * .pi * 3
                    let r = t * size * 0.5
                    p.addLine(to: CGPoint(x: cos(a)*r, y: sin(a)*r - size*0.1))
                }
            }
            .stroke(ink, lineWidth: lw2)
            // ribs
            ForEach(0..<5) { i in
                Path { p in
                    let a = Double(i) * .pi / 5 + .pi
                    p.move(to: CGPoint(x: 0, y: size*0.5))
                    p.addLine(to: CGPoint(x: cos(a)*size*0.5, y: sin(a)*size*0.5 - size*0.1))
                }
                .stroke(ink, lineWidth: lw2*0.5)
            }
        }
    }
}

struct DoodleSeahorse: View {
    var body: some View {
        Path { p in
            p.move(to: CGPoint(x: 0, y: -40))
            p.addCurve(to: CGPoint(x: 12, y: -10),
                       control1: CGPoint(x: 18, y: -35),
                       control2: CGPoint(x: 18, y: -18))
            p.addCurve(to: CGPoint(x: -2, y: 18),
                       control1: CGPoint(x: 6, y: -2),
                       control2: CGPoint(x: -4, y: 8))
            p.addCurve(to: CGPoint(x: 6, y: 38),
                       control1: CGPoint(x: 0, y: 28),
                       control2: CGPoint(x: 8, y: 32))
            p.addCurve(to: CGPoint(x: -2, y: 44),
                       control1: CGPoint(x: 4, y: 44),
                       control2: CGPoint(x: -2, y: 44))
        }
        .stroke(ink, lineWidth: lw2)
        // head fin
        Path { p in
            p.move(to: CGPoint(x: 0, y: -40))
            p.addCurve(to: CGPoint(x: -14, y: -44),
                       control1: CGPoint(x: -6, y: -48),
                       control2: CGPoint(x: -12, y: -46))
        }
        .stroke(ink, lineWidth: lw2)
        // eye
        Circle().fill(ink).frame(width: 5).offset(x: 6, y: -34)
    }
}


