import SwiftUI

// ============================================================
// MARK: - TracingShape Enum  (replace your existing one)
// ============================================================

enum TracingShape: String, CaseIterable, Identifiable {
    case none           = "None"
    case mandala        = "Mandala"
    case lotus          = "Lotus"
    case sacredGeometry = "Sacred Geometry"
    case butterfly      = "Butterfly"
    case moonPhases     = "Moon Phases"
    case rippleWater    = "Ripple Water"
    case celticKnot     = "Celtic Knot"
    case treeOfLife     = "Tree of Life"
    case fibonacci      = "Fibonacci"
    case crescentMoon   = "Crescent Moon"
    case labyrinth      = "Labyrinth"
    case waveGrid       = "Wave Grid"
    case seedOfLife     = "Seed of Life"
    case sunMandala     = "Sun Mandala"
    case roseWindow     = "Rose Window"
    case animalDoodle   = "Animal Doodle"
    case animalFriends2 = "Animal Friends 2"
    case animalFun      = "Animal Fun"
    case doodleFlowers  = "Doodle Flowers"
    case doodleFriends  = "Doodle Friends"
    case doodleTwo      = "Doodle Two"
    case pansy2         = "Pansy"
    case pansy          = "Pansy Garden"
    case oceanDreams     = "Ocean Dreams"
  
    var id: String { rawValue }
}

// ============================================================
// MARK: - TracingOverlay  (replace your existing switch)
// ============================================================

struct TracingOverlay: View {
    var shape: TracingShape
    var body: some View {
        switch shape {
        case .none:           EmptyView()
        case .mandala:        MandalaShape()
        case .lotus:          LotusShape()
        case .sacredGeometry: SacredGeometryShape()
        case .butterfly:      ButterflyShape()
        case .moonPhases:     MoonPhasesShape()
        case .rippleWater:    RippleWaterShape()
        case .celticKnot:     CelticKnotShape()
        case .treeOfLife:     TreeOfLifeShape()
        case .fibonacci:      FibonacciShape()
        case .crescentMoon:   CrescentMoonShape()
        case .labyrinth:      LabyrinthShape()
        case .waveGrid:       WaveGridShape()
        case .seedOfLife:     SeedOfLifeShape()
        case .sunMandala:     SunMandalaShape()
        case .roseWindow:     RoseWindowShape()
        case .animalDoodle:   PatternImage(name: "animal_doodle")
        case .animalFriends2: PatternImage(name: "animal_friends")
        case .animalFun:      PatternImage(name: "animal_fun")
        case .doodleFlowers:  PatternImage(name: "Doodle_flowers")
        case .doodleFriends:  PatternImage(name: "doodle_friends")
        case .doodleTwo:      PatternImage(name: "doodle_two")
        case .pansy2:         PatternImage(name: "pansy_2")
        case .pansy:          PatternImage(name: "pansy")
        case .oceanDreams:     OceanDreamsShape()
      
        }
    }
}


// MARK: - Shared style constants


private let lw: CGFloat = 1.8          // standard line width
private let col = Color(red: 0.35, green: 0.25, blue: 0.15).opacity(0.22)  // warm ink


// MARK: - 1. Ripple Water


struct RippleWaterShape: View {
    var body: some View {
        ZStack {
            ForEach(0..<10) { i in
                Ellipse()
                    .stroke(col, lineWidth: lw)
                    .frame(width: CGFloat(60 + i * 28), height: CGFloat(30 + i * 14))
            }
            // small pebble drop lines
            ForEach(0..<4) { i in
                let angle = Double(i) * 90.0
                Path { p in
                    p.move(to: CGPoint(x: 0, y: 0))
                    p.addLine(to: CGPoint(x: 0, y: -12))
                }
                .stroke(col, lineWidth: lw * 0.7)
                .rotationEffect(.degrees(angle))
            }
        }
    }
}


// MARK: - 2. Celtic Knot


struct CelticKnotShape: View {
    var body: some View {
        ZStack {
            // outer circle
            Circle().stroke(col, lineWidth: lw).frame(width: 280)
            Circle().stroke(col, lineWidth: lw * 0.6).frame(width: 260)

            // four interlocking loops
            ForEach(0..<4) { i in
                ZenCelticLoop()
                    .rotationEffect(.degrees(Double(i) * 90))
            }

            // centre diamond
            Rectangle()
                .stroke(col, lineWidth: lw)
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(45))

            Circle().stroke(col, lineWidth: lw).frame(width: 40)
        }
    }
}

struct ZenCelticLoop: View {
    var body: some View {
        Path { p in
            p.move(to: CGPoint(x: 0, y: -100))
            p.addCurve(to: CGPoint(x: 100, y: 0),
                       control1: CGPoint(x: 80, y: -100),
                       control2: CGPoint(x: 100, y: -80))
            p.addCurve(to: CGPoint(x: 0, y: -60),
                       control1: CGPoint(x: 100, y: 20),
                       control2: CGPoint(x: 60, y: -30))
            p.addCurve(to: CGPoint(x: -60, y: 0),
                       control1: CGPoint(x: -30, y: -90),
                       control2: CGPoint(x: -60, y: -60))
        }
        .stroke(col, lineWidth: lw)
    }
}


// MARK: - 4. Tree of Life


struct TreeOfLifeShape: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let cx = w / 2
            let cy = h / 2
            ZStack {
                // trunk
                Path { p in
                    p.move(to: CGPoint(x: cx, y: cy + h * 0.3))
                    p.addLine(to: CGPoint(x: cx, y: cy))
                }
                .stroke(col, lineWidth: lw * 1.2)

                // roots
                ForEach(0..<5) { i in
                    Path { p in
                        let angle = Double(i - 2) * 20.0
                        let rad = angle * .pi / 180
                        p.move(to: CGPoint(x: cx, y: cy + h * 0.3))
                        p.addCurve(
                            to: CGPoint(x: cx + CGFloat(sin(rad)) * w * 0.28, y: cy + h * 0.45),
                            control1: CGPoint(x: cx + CGFloat(sin(rad)) * w * 0.1, y: cy + h * 0.35),
                            control2: CGPoint(x: cx + CGFloat(sin(rad)) * w * 0.2, y: cy + h * 0.4))
                    }
                    .stroke(col, lineWidth: lw)
                }

                // branches
                ForEach(0..<5) { level in
                    let y = cy - CGFloat(level) * h * 0.07
                    let spread = w * CGFloat(0.08 + Double(level) * 0.06)
                    ForEach([-1, 1] as [CGFloat], id: \.self) { side in
                        Path { p in
                            p.move(to: CGPoint(x: cx, y: y))
                            p.addCurve(
                                to: CGPoint(x: cx + side * spread, y: y - h * 0.08),
                                control1: CGPoint(x: cx + side * spread * 0.3, y: y - h * 0.03),
                                control2: CGPoint(x: cx + side * spread * 0.8, y: y - h * 0.06))
                        }
                        .stroke(col, lineWidth: max(lw - CGFloat(level) * 0.2, 0.8))
                    }
                }

                // canopy circle
                Circle()
                    .stroke(col, lineWidth: lw)
                    .frame(width: w * 0.7, height: w * 0.7)
                    .position(x: cx, y: cy - h * 0.1)

                // leaf dots
                ForEach(0..<12) { i in
                    let a = Double(i) / 12.0 * .pi * 2
                    Circle()
                        .fill(col)
                        .frame(width: 5, height: 5)
                        .position(x: cx + CGFloat(cos(a)) * w * 0.28,
                                  y: cy - h * 0.1 + CGFloat(sin(a)) * w * 0.28)
                }
            }
        }
    }
}



// MARK: - 6. Fibonacci Spiral


struct FibonacciShape: View {
    var body: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height) * 0.44
            let cx = geo.size.width / 2
            let cy = geo.size.height / 2
            Path { p in
                var started = false
                for angle in stride(from: 0.0, through: .pi * 6, by: 0.05) {
                    let r = s * CGFloat(angle / (.pi * 6))
                    let x = cx + CGFloat(cos(angle)) * r
                    let y = cy + CGFloat(sin(angle)) * r
                    if !started { p.move(to: CGPoint(x: x, y: y)); started = true }
                    else { p.addLine(to: CGPoint(x: x, y: y)) }
                }
            }
            .stroke(col, lineWidth: lw)
            // outer circle
            Circle().stroke(col.opacity(0.4), lineWidth: lw * 0.6)
                .frame(width: s * 2, height: s * 2)
                .position(x: cx, y: cy)
        }
    }
}

// MARK: - 7. Crescent Moon & Stars


struct CrescentMoonShape: View {
    var body: some View {
        ZStack {
            // crescent via two circles
            Circle()
                .stroke(col, lineWidth: lw)
                .frame(width: 200)
            Circle()
                .fill(Color.white.opacity(0.001)) // hit test only
                .frame(width: 160)
                .offset(x: 40)
                .overlay(
                    Circle()
                        .stroke(col, lineWidth: lw)
                        .frame(width: 160)
                        .offset(x: 40)
                )

            // stars scattered
            let starPositions: [(CGFloat, CGFloat, CGFloat)] = [
                (-90, -80, 12), (80, -100, 8), (-110, 20, 6),
                (100, 40, 10), (-60, 100, 7), (60, 110, 5),
                (20, -120, 9), (-130, -30, 5)
            ]
            ForEach(starPositions.indices, id: \.self) { i in
                let (x, y, s) = starPositions[i]
                ZenStar(size: s).offset(x: x, y: y).stroke(col, lineWidth: lw * 0.7)
            }

            // crescent inner detail lines
            ForEach(0..<5) { i in
                Path { p in
                    let y = CGFloat(-60 + i * 30)
                    p.move(to: CGPoint(x: -80, y: y))
                    p.addCurve(to: CGPoint(x: -20, y: y),
                               control1: CGPoint(x: -60, y: y - 8),
                               control2: CGPoint(x: -40, y: y - 8))
                }
                .stroke(col.opacity(0.4), lineWidth: lw * 0.6)
            }
        }
        .frame(width: 300, height: 300)
    }
}

struct ZenStar: Shape {
    var size: CGFloat
    func path(in rect: CGRect) -> Path {
        var p = Path()
        for i in 0..<5 {
            let a = Double(i) * .pi * 2 / 5 - .pi / 2
            let ia = a + .pi / 5
            let outer = CGPoint(x: cos(a) * size, y: sin(a) * size)
            let inner = CGPoint(x: cos(ia) * size * 0.4, y: sin(ia) * size * 0.4)
            i == 0 ? p.move(to: outer) : p.addLine(to: outer)
            p.addLine(to: inner)
        }
        p.closeSubpath()
        return p
    }
}


// ============================================================

struct LabyrinthShape: View {
    var body: some View {
        GeometryReader { geo in
            let cx = geo.size.width / 2
            let cy = geo.size.height / 2
            let maxR = min(geo.size.width, geo.size.height) * 0.44
            ZStack {
                ForEach(0..<7) { i in
                    let r = maxR * CGFloat(i + 1) / 7.0
                    Path { p in
                        p.addArc(center: CGPoint(x: cx, y: cy),
                                 radius: r,
                                 startAngle: .degrees(190),
                                 endAngle: .degrees(350),
                                 clockwise: false)
                    }
                    .stroke(col, lineWidth: lw * 0.9)
                }
                ForEach(0..<7) { i in
                    let r = maxR * CGFloat(i + 1) / 7.0
                    Path { p in
                        p.addArc(center: CGPoint(x: cx, y: cy),
                                 radius: r,
                                 startAngle: .degrees(10),
                                 endAngle: .degrees(170),
                                 clockwise: false)
                    }
                    .stroke(col, lineWidth: lw * 0.9)
                }
                Circle().fill(col).frame(width: 8).position(x: cx, y: cy)
            }
        }
    }
}


// MARK: - 12. Wave Grid


struct WaveGridShape: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                ForEach(0..<10) { row in
                    Path { p in
                        let y = h * CGFloat(row) / 9.0
                        p.move(to: CGPoint(x: 0, y: y))
                        var cx: CGFloat = 0
                        while cx <= w {
                            let phase = Double(cx / w) * .pi * 4
                            let wy = y + CGFloat(sin(phase + Double(row) * 0.5)) * h * 0.04
                            p.addLine(to: CGPoint(x: cx, y: wy))
                            cx += 3
                        }
                    }
                    .stroke(col, lineWidth: lw * 0.75)
                }
                ForEach(0..<10) { col2 in
                    Path { p in
                        let x = w * CGFloat(col2) / 9.0
                        p.move(to: CGPoint(x: x, y: 0))
                        var cy: CGFloat = 0
                        while cy <= h {
                            let phase = Double(cy / h) * .pi * 4
                            let wx = x + CGFloat(sin(phase + Double(col2) * 0.5)) * w * 0.04
                            p.addLine(to: CGPoint(x: wx, y: cy))
                            cy += 3
                        }
                    }
                    .stroke(col, lineWidth: lw * 0.75)
                }
            }
        }
    }
}


// MARK: - 13. Seed of Life


struct SeedOfLifeShape: View {
    var body: some View {
        ZStack {
            // centre circle
            Circle().stroke(col, lineWidth: lw).frame(width: 130)
            // 6 surrounding circles
            ForEach(0..<6) { i in
                let a = Double(i) * .pi / 3
                Circle()
                    .stroke(col, lineWidth: lw)
                    .frame(width: 130)
                    .offset(x: CGFloat(cos(a)) * 65, y: CGFloat(sin(a)) * 65)
            }
            // outer containing circle
            Circle().stroke(col, lineWidth: lw).frame(width: 260)
            // inner star lines
            ForEach(0..<6) { i in
                let a = Double(i) * .pi / 3
                Path { p in
                    p.move(to: .zero)
                    p.addLine(to: CGPoint(x: CGFloat(cos(a)) * 65, y: CGFloat(sin(a)) * 65))
                }
                .stroke(col.opacity(0.35), lineWidth: lw * 0.6)
            }
        }
        .frame(width: 300, height: 300)
    }
}


// MARK: - 14. Sun Mandala


struct SunMandalaShape: View {
    var body: some View {
        GeometryReader { geo in
            let cx = geo.size.width / 2
            let cy = geo.size.height / 2
            let s = min(geo.size.width, geo.size.height) * 0.44
            ZStack {
                ForEach([0.15, 0.3, 0.5, 0.7, 0.9] as [CGFloat], id: \.self) { f in
                    Circle().stroke(col, lineWidth: lw * 0.8)
                        .frame(width: s * f * 2, height: s * f * 2)
                        .position(x: cx, y: cy)
                }
                ForEach(0..<24) { i in
                    let a = Double(i) * .pi / 12
                    Path { p in
                        p.move(to: CGPoint(x: cx + CGFloat(cos(a)) * s * 0.7, y: cy + CGFloat(sin(a)) * s * 0.7))
                        p.addLine(to: CGPoint(x: cx + CGFloat(cos(a)) * s, y: cy + CGFloat(sin(a)) * s))
                    }
                    .stroke(col, lineWidth: i % 2 == 0 ? lw : lw * 0.6)
                }
                ForEach(0..<12) { i in
                    let a = Double(i) * .pi / 6
                    Path { p in
                        p.move(to: CGPoint(x: cx + CGFloat(cos(a)) * s * 0.5, y: cy + CGFloat(sin(a)) * s * 0.5))
                        p.addCurve(
                            to: CGPoint(x: cx + CGFloat(cos(a + .pi/12)) * s * 0.65, y: cy + CGFloat(sin(a + .pi/12)) * s * 0.65),
                            control1: CGPoint(x: cx + CGFloat(cos(a - .pi/18)) * s * 0.62, y: cy + CGFloat(sin(a - .pi/18)) * s * 0.62),
                            control2: CGPoint(x: cx + CGFloat(cos(a + .pi/18)) * s * 0.62, y: cy + CGFloat(sin(a + .pi/18)) * s * 0.62))
                        p.addCurve(
                            to: CGPoint(x: cx + CGFloat(cos(a + .pi/6)) * s * 0.5, y: cy + CGFloat(sin(a + .pi/6)) * s * 0.5),
                            control1: CGPoint(x: cx + CGFloat(cos(a + .pi/9)) * s * 0.62, y: cy + CGFloat(sin(a + .pi/9)) * s * 0.62),
                            control2: CGPoint(x: cx + CGFloat(cos(a + .pi/8)) * s * 0.62, y: cy + CGFloat(sin(a + .pi/8)) * s * 0.62))
                    }
                    .stroke(col, lineWidth: lw)
                }
                Circle().fill(col).frame(width: 10).position(x: cx, y: cy)
                Circle().stroke(col, lineWidth: lw).frame(width: 20).position(x: cx, y: cy)
            }
        }
    }
}


// MARK: - 17. Rose Window


struct RoseWindowShape: View {
    var body: some View {
        GeometryReader { geo in
            let cx = geo.size.width / 2
            let cy = geo.size.height / 2
            let s = min(geo.size.width, geo.size.height) * 0.44
            ZStack {
                Circle().stroke(col, lineWidth: lw).frame(width: s*2).position(x: cx, y: cy)
                Circle().stroke(col, lineWidth: lw*0.5).frame(width: s*1.88).position(x: cx, y: cy)
                ForEach(0..<12) { i in
                    let a = Double(i) * .pi / 6
                    Path { p in
                        p.move(to: CGPoint(x: cx, y: cy))
                        p.addLine(to: CGPoint(x: cx + CGFloat(cos(a))*s, y: cy + CGFloat(sin(a))*s))
                    }
                    .stroke(col, lineWidth: lw * 0.6)
                }
                ForEach(0..<12) { i in
                    let a = Double(i) * .pi / 6
                    let na = a + .pi / 6
                    Path { p in
                        p.move(to: CGPoint(x: cx + CGFloat(cos(a))*s*0.42, y: cy + CGFloat(sin(a))*s*0.42))
                        p.addCurve(
                            to: CGPoint(x: cx + CGFloat(cos(na))*s*0.42, y: cy + CGFloat(sin(na))*s*0.42),
                            control1: CGPoint(x: cx + CGFloat(cos(a + .pi/12))*s*0.68, y: cy + CGFloat(sin(a + .pi/12))*s*0.68),
                            control2: CGPoint(x: cx + CGFloat(cos(a + .pi/12))*s*0.68, y: cy + CGFloat(sin(a + .pi/12))*s*0.68))
                    }
                    .stroke(col, lineWidth: lw)
                }
                ForEach(0..<6) { i in
                    let a = Double(i) * .pi / 3
                    let na = a + .pi / 3
                    Path { p in
                        p.move(to: CGPoint(x: cx + CGFloat(cos(a))*s*0.68, y: cy + CGFloat(sin(a))*s*0.68))
                        p.addCurve(
                            to: CGPoint(x: cx + CGFloat(cos(na))*s*0.68, y: cy + CGFloat(sin(na))*s*0.68),
                            control1: CGPoint(x: cx + CGFloat(cos(a + .pi/6))*s, y: cy + CGFloat(sin(a + .pi/6))*s),
                            control2: CGPoint(x: cx + CGFloat(cos(a + .pi/6))*s, y: cy + CGFloat(sin(a + .pi/6))*s))
                    }
                    .stroke(col, lineWidth: lw)
                }
                Circle().stroke(col, lineWidth: lw).frame(width: s*0.8).position(x: cx, y: cy)
                Circle().stroke(col, lineWidth: lw).frame(width: s*0.4).position(x: cx, y: cy)
                Circle().fill(col).frame(width: 10).position(x: cx, y: cy)
            }
        }
    }
}


struct PatternImage: View {
    let name: String
    var body: some View {
        GeometryReader { geo in
            Image(name)
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .opacity(0.35)
                .clipped()
        }
    }
}
// MARK: - Existing shapes kept as-is (your originals)
// ============================================================
// MandalaShape, LotusShape, SacredGeometryShape, ButterflyShape,
// MoonPhasesShape, HeartFlowerShape — keep these exactly as they
// are in your current DoodleRoomView.swift. Only ADD the new ones above.
