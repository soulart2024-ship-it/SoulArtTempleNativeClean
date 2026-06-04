import SwiftUI

struct FluidCanvas: View {
    
    var strokes: [PaintStroke]
    
    var paintMode: PaintMode
    
    
    var body: some View {
        
        Canvas { context, size in
            
            for stroke in strokes {
                
                guard stroke.points.count > 1 else { continue }
                
                var path = Path()
                path.move(to: stroke.points.first!)
                
                for index in 1..<stroke.points.count {
                    
                    let velocity = CGSize(
                        width: stroke.points[index].x - stroke.points[index - 1].x,
                        height: stroke.points[index].y - stroke.points[index - 1].y
                    )
                    
                    let swirl = CGSize(
                        width: velocity.height * 0.12,
                        height: -velocity.width * 0.12
                    )
                    
                    var attraction = CGSize(width: 0, height: 0)
                    
                    if paintMode == .blend && index > 2 {
                        
                        let previous = stroke.points[index - 2]
                        
                        attraction.width = (previous.x - stroke.points[index].x) * 0.08
                        attraction.height = (previous.y - stroke.points[index].y) * 0.08
                    }
                    
                    let drift = paintMode == .blend
                    ? displaced(
                        stroke.points[index],
                        by: CGSize(
                            width: velocity.width + swirl.width + attraction.width,
                            height: velocity.height + swirl.height + attraction.height
                        )
                    )
                    : stroke.points[index]
                    
                    let mid = midpoint(
                        stroke.points[index - 1],
                        drift
                    )
                    
                    let control = midpoint(stroke.points[index - 1], mid)
                    
                    path.addQuadCurve(
                        to: mid,
                        control: control
                        
                    )
                }
                
                let opacity = paintMode == .blend ? 0.22 : 0.82
                let width = paintMode == .blend ? stroke.lineWidth * 0.95 : stroke.lineWidth * 1.0
                let bloomWidth = width * 2.2
                
                
                let mixedColor = stroke.color
                
                context.stroke(
                    path,
                    with: .color(mixedColor.opacity(opacity)),
                    style: StrokeStyle(
                        lineWidth: width,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                context.stroke(
                    path,
                    with: .color(mixedColor.opacity(0.10)),
                    style: StrokeStyle(
                        lineWidth: bloomWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                
                context.stroke(
                    path,
                    with: .color(stroke.color.opacity(opacity)),
                    style: StrokeStyle(
                        lineWidth: width,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                
                if paintMode == .blend {
                    
                    context.stroke(
                        path,
                        with: .color(stroke.color.opacity(0.12)),
                        style: StrokeStyle(
                            lineWidth: width * 1.9,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    
                }
            }
            
        }
        .drawingGroup()
    }
    func midpoint(_ p1: CGPoint, _ p2: CGPoint) -> CGPoint {
        CGPoint(
            x: (p1.x + p2.x) / 2,
            y: (p1.y + p2.y) / 2
        )
    }
    
    func displaced(_ point: CGPoint, by velocity: CGSize) -> CGPoint {
        CGPoint(
            x: point.x + velocity.width * 0.09,
            y: point.y + velocity.height * 0.09
        )
    }
    
    func blendColor(at point: CGPoint, from strokes: [PaintStroke]) -> Color {
        
        var totalR: CGFloat = 0
        var totalG: CGFloat = 0
        var totalB: CGFloat = 0
        var count: CGFloat = 0
        
        for stroke in strokes {
            for p in stroke.points {
                
                let dx = p.x - point.x
                let dy = p.y - point.y
                let distance = sqrt(dx*dx + dy*dy)
                
                if distance < 40 {
                    
                    let uiColor = UIColor(stroke.color)
                    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
                    uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
                    
                    totalR += r
                    totalG += g
                    totalB += b
                    count += 1
                }
            }
        }
        
        if count == 0 {
            return .clear
        }
        
        return Color(
            red: totalR / count,
            green: totalG / count,
            blue: totalB / count
        )
    }
}

