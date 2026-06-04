import SwiftUI
import MetalKit

struct FluidInkCanvas: View {

    @State private var pigment = [[SIMD3<Float>]](
        repeating: Array(repeating: SIMD3<Float>(0,0,0), count: 300),
        count: 500
    )

    @State private var velocity = [[SIMD2<Float>]](
        repeating: Array(repeating: SIMD2<Float>(0,0), count: 300),
        count: 500
    )

    @State private var currentColor = SIMD3<Float>(1,0,0)

    var body: some View {

        Canvas { context, size in

            let cellWidth = size.width / CGFloat(pigment[0].count)
            let cellHeight = size.height / CGFloat(pigment.count)

            for y in pigment.indices {
                for x in pigment[y].indices {

                    let c = pigment[y][x]

                    let rect = CGRect(
                        x: CGFloat(x) * cellWidth,
                        y: CGFloat(y) * cellHeight,
                        width: cellWidth,
                        height: cellHeight
                    )

                    context.fill(
                        Path(rect),
                        with: .color(
                            Color(
                                red: Double(c.x),
                                green: Double(c.y),
                                blue: Double(c.z)
                            )
                        )
                    )
                }
            }

        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    injectPigment(at: value.location)
                }
        )
        .onAppear {
            startFluidSimulation()
        }
    }

    func injectPigment(at location: CGPoint) {

        let x = Int(location.x)
        let y = Int(location.y)

        guard y >= 1 && y < pigment.count-1 else { return }
        guard x >= 1 && x < pigment[0].count-1 else { return }

        pigment[y][x] = currentColor
    }

    func mix(_ a: SIMD3<Float>, _ b: SIMD3<Float>) -> SIMD3<Float> {

        return SIMD3(
            sqrt(a.x * b.x + 0.001),
            sqrt(a.y * b.y + 0.001),
            sqrt(a.z * b.z + 0.001)
        )
    }

    func startFluidSimulation() {

        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in

            for y in 1..<pigment.count-1 {
                for x in 1..<pigment[0].count-1 {

                    pigment[y][x] *= 0.999

                    pigment[y][x] += (
                        pigment[y-1][x] +
                        pigment[y+1][x] +
                        pigment[y][x-1] +
                        pigment[y][x+1]
                    ) * 0.0005
                }
            }
        }
    }
}
