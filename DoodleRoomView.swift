import SwiftUI
import Photos

struct DoodleRoomView: View {
    
    @EnvironmentObject var moodStore: MoodStore
    
    @State private var strokes: [Stroke] = []
    @State private var currentStroke: Stroke? = nil
    @State private var brushSize: CGFloat = 4
    @State private var savedImage: UIImage? = nil
    @State private var navigateToJournal = false
    @State private var selectedColor: Color = .black
    
    struct Stroke {
        var points: [CGPoint]
        var color: Color
        var lineWidth: CGFloat
    }
    
    var body: some View {
        
        ZStack {
            
            // 🌊 MOOD BACKGROUND
            MoodBackgroundView(mood: moodStore.selectedMood)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Spacer(minLength: 20)
                
                // 🌿 TITLE
                Text("Express Freely")
                    .font(Theme.sectionTitle)
                    .foregroundStyle(Theme.textPrimary)
                
                Text("Let your feeling move through your hand")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textSecondary.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                // 🎨 CANVAS CONTAINER
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.15))
                        .shadow(radius: 10)
                    
                    Canvas { context, size in
                        
                        // ✅ DRAW COMPLETED STROKES
                        for stroke in strokes {
                            
                            var path = Path()
                            
                            guard stroke.points.count > 1 else { continue }
                            
                            path.move(to: stroke.points[0])
                            
                            for i in 1..<stroke.points.count {
                                let mid = CGPoint(
                                    x: (stroke.points[i - 1].x + stroke.points[i].x) / 2,
                                    y: (stroke.points[i - 1].y + stroke.points[i].y) / 2
                                )
                                
                                path.addQuadCurve(to: mid, control: stroke.points[i - 1])
                            }
                            
                            path.addLine(to: stroke.points.last!)
                            
                            // 🌿 OUTER GLOW
                            context.stroke(
                                path,
                                with: .color(stroke.color.opacity(0.15)),
                                style: StrokeStyle(
                                    lineWidth: stroke.lineWidth * 3,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )

                            // 🌿 MID GLOW
                            context.stroke(
                                path,
                                with: .color(stroke.color.opacity(0.25)),
                                style: StrokeStyle(
                                    lineWidth: stroke.lineWidth * 1.8,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )

                            // 🌿 CORE LINE
                            context.stroke(
                                path,
                                with: .color(stroke.color.opacity(0.9)),
                                style: StrokeStyle(
                                    lineWidth: stroke.lineWidth,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                        }
                        
                        // 🚀 DRAW LIVE STROKE (THIS FIXES DELAY)
                        if let liveStroke = currentStroke {
                            
                            var path = Path()
                            
                            guard liveStroke.points.count > 1 else { return }
                            
                            path.move(to: liveStroke.points[0])
                            
                            for i in 1..<liveStroke.points.count {
                                let mid = CGPoint(
                                    x: (liveStroke.points[i - 1].x + liveStroke.points[i].x) / 2,
                                    y: (liveStroke.points[i - 1].y + liveStroke.points[i].y) / 2
                                )
                                
                                path.addQuadCurve(to: mid, control: liveStroke.points[i - 1])
                            }
                            
                            path.addLine(to: liveStroke.points.last!)
                            
                            // 🌿 LIVE OUTER
                            context.stroke(
                                path,
                                with: .color(liveStroke.color.opacity(0.15)),
                                style: StrokeStyle(
                                    lineWidth: liveStroke.lineWidth * 3,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )

                            // 🌿 LIVE MID
                            context.stroke(
                                path,
                                with: .color(liveStroke.color.opacity(0.25)),
                                style: StrokeStyle(
                                    lineWidth: liveStroke.lineWidth * 1.8,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )

                            // 🌿 LIVE CORE
                            context.stroke(
                                path,
                                with: .color(liveStroke.color.opacity(0.9)),
                                style: StrokeStyle(
                                    lineWidth: liveStroke.lineWidth,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                        }
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                
                                if currentStroke == nil {
                                    currentStroke = Stroke(
                                        points: [],
                                        color: selectedColor,
                                        lineWidth: brushSize
                                    )
                                }
                                
                                currentStroke?.points.append(value.location)
                            }
                            .onEnded { _ in
                                
                                if let stroke = currentStroke {
                                    strokes.append(stroke)
                                }
                                
                                currentStroke = nil
                            }
                    )
                }
                .frame(height: 400)
                .padding(.horizontal, 20)
                
                    VStack(spacing: 12) {
                        
                        // 🎚 BRUSH SIZE
                        VStack(spacing: 4) {
                            
                            Text("Brush Size")
                                .font(Theme.smallText)
                                .foregroundStyle(Theme.textSecondary.opacity(0.7))
                            
                            Slider(value: $brushSize, in: 1...12)
                                .tint(strokeColor)
                                .padding(.horizontal, 20)
                        }
                        
                        // 🎨 COLOR PALETTE
                        VStack(spacing: 8) {
                            
                            Text("Colour")
                                .font(Theme.smallText)
                                .foregroundStyle(Theme.textSecondary.opacity(0.7))
                            
                            HStack(spacing: 12) {
                                
                                ForEach([
                                    Color.black,
                                    .orange,
                                    .blue,
                                    .green,
                                    .purple,
                                    .pink,
                                    .yellow
                                ], id: \.self) { color in
                                    
                                    Circle()
                                        .fill(color)
                                        .frame(width: 28, height: 28)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: selectedColor == color ? 3 : 0)
                                        )
                                        .onTapGesture {
                                            selectedColor = color
                                        }
                                }
                            }
                        }
                        
                        
                        // 🎛 ACTION BUTTONS
                        HStack(spacing: 16) {

                            Button("Clear") {
                                strokes.removeAll()
                            }

                            Button("Undo") {
                                if !strokes.isEmpty {
                                    strokes.removeLast()
                                }
                            }
                            
                            Button("Save") {
                                saveDrawing()
                                
                            }
                            
                            
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(14)
                    }
                
                // 🌿 REFLECTION PROMPT
                Text("What did that express or release?")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textSecondary.opacity(0.6))
                
                Spacer(minLength: 80)
            }
        }
        .navigationTitle("")
        .navigationDestination(isPresented: $navigateToJournal) {
            JournalViewWithImage(image: savedImage)
        }
    }
    
    func saveDrawing() {
        
        let renderer = ImageRenderer(
            content:
                ZStack {
                    
                    Color.clear
                    
                    Canvas { context, size in
                        
                        for stroke in strokes {
                            
                            var path = Path()
                            
                            guard stroke.points.count > 1 else { continue }
                            
                            path.move(to: stroke.points[0])
                            
                            for i in 1..<stroke.points.count {
                                let mid = CGPoint(
                                    x: (stroke.points[i - 1].x + stroke.points[i].x) / 2,
                                    y: (stroke.points[i - 1].y + stroke.points[i].y) / 2
                                )
                                
                                path.addQuadCurve(to: mid, control: stroke.points[i - 1])
                            }
                            
                            path.addLine(to: stroke.points.last!)
                            
                            context.stroke(
                                path,
                                with: .color(stroke.color),
                                style: StrokeStyle(
                                    lineWidth: stroke.lineWidth,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                        }
                    }
                }
                .frame(width: 300, height: 400)
        )
        
        if let image = renderer.uiImage {
            
            savedImage = image
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            navigateToJournal = true
        }
    }
    
    var strokeColor: Color {
        switch moodStore.selectedMood {
        case .warm: return .orange
        case .calm: return .blue
        case .heart: return .green
        case .intuitive: return .purple
        case .none: return .black
        }
    }
}
