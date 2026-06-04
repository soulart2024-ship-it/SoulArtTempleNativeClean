import SwiftUI

// NOTE: TracingShape enum, TracingOverlay, and all pattern shapes
// now live in ZenTracingPatterns.swift — do NOT redeclare them here.

struct MandalaShape: View {
    var body: some View {
        ZStack {
            ForEach(0..<12) { i in
                Ellipse()
                    .stroke(Theme.deepBrown.opacity(0.15), lineWidth: 1.8)
                    .frame(width: 280, height: 110)
                    .rotationEffect(.degrees(Double(i) * 30))
            }
            ForEach(0..<8) { i in
                Ellipse()
                    .stroke(Theme.deepBrown.opacity(0.12), lineWidth: 1.8)
                    .frame(width: 160, height: 70)
                    .rotationEffect(.degrees(Double(i) * 45))
            }
            Circle()
                .stroke(Theme.deepBrown.opacity(0.20), lineWidth: 2.0)
                .frame(width: 80)
            Circle()
                .stroke(Theme.deepBrown.opacity(0.15), lineWidth: 2.0)
                .frame(width: 160)
            Circle()
                .stroke(Theme.deepBrown.opacity(0.12), lineWidth: 2.0)
                .frame(width: 270)
        }
    }
}

struct LotusShape: View {
    var body: some View {
        ZStack {
            ForEach(0..<8) { i in
                Ellipse()
                    .stroke(Theme.deepBrown.opacity(0.15), lineWidth: 1.5)
                    .frame(width: 70, height: 130)
                    .offset(y: -40)
                    .rotationEffect(.degrees(Double(i) * 45))
            }
            ForEach(0..<5) { i in
                Ellipse()
                    .stroke(Theme.deepBrown.opacity(0.12), lineWidth: 1)
                    .frame(width: 50, height: 90)
                    .offset(y: -25)
                    .rotationEffect(.degrees(Double(i) * 72))
            }
            Circle()
                .stroke(Theme.deepBrown.opacity(0.15), lineWidth: 1.5)
                .frame(width: 40)
        }
    }
}

struct SacredGeometryShape: View {
    var body: some View {
        ZStack {
            ForEach(0..<6) { i in
                Circle()
                    .stroke(Theme.deepBrown.opacity(0.13), lineWidth: 1)
                    .frame(width: 120)
                    .offset(x: 60 * cos(Double(i) * .pi / 3),
                            y: 60 * sin(Double(i) * .pi / 3))
            }
            Circle()
                .stroke(Theme.deepBrown.opacity(0.15), lineWidth: 1)
                .frame(width: 120)
            Circle()
                .stroke(Theme.deepBrown.opacity(0.10), lineWidth: 1)
                .frame(width: 240)
        }
    }
}

struct ButterflyShape: View {
    var body: some View {
        ZStack {
            ForEach(0..<2) { i in
                Ellipse()
                    .stroke(Theme.deepBrown.opacity(0.15), lineWidth: 1.5)
                    .frame(width: 110, height: 140)
                    .offset(x: i == 0 ? -45 : 45, y: -30)
                    .rotationEffect(.degrees(i == 0 ? -20 : 20))
            }
            ForEach(0..<2) { i in
                Ellipse()
                    .stroke(Theme.deepBrown.opacity(0.12), lineWidth: 1)
                    .frame(width: 80, height: 100)
                    .offset(x: i == 0 ? -40 : 40, y: 50)
                    .rotationEffect(.degrees(i == 0 ? 15 : -15))
            }
            Capsule()
                .stroke(Theme.deepBrown.opacity(0.15), lineWidth: 1.5)
                .frame(width: 12, height: 100)
        }
    }
}

struct MoonPhasesShape: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 30) {
                ForEach(0..<3) { i in
                    ZStack {
                        Circle()
                            .stroke(Theme.deepBrown.opacity(0.18), lineWidth: 2.0)
                            .frame(width: 70)
                        Circle()
                            .stroke(Theme.deepBrown.opacity(0.12), lineWidth: 1.5)
                            .frame(width: 55)
                            .offset(x: i == 0 ? -18 : i == 2 ? 18 : 0)
                    }
                }
            }
            HStack(spacing: 30) {
                ForEach(0..<2) { i in
                    ZStack {
                        Circle()
                            .stroke(Theme.deepBrown.opacity(0.18), lineWidth: 2.0)
                            .frame(width: 70)
                        if i == 0 {
                            Circle()
                                .stroke(Theme.deepBrown.opacity(0.14), lineWidth: 1.5)
                                .frame(width: 55)
                        }
                    }
                }
            }
            ZStack {
                Circle()
                    .stroke(Theme.deepBrown.opacity(0.20), lineWidth: 2.0)
                    .frame(width: 90)
                Circle()
                    .stroke(Theme.deepBrown.opacity(0.10), lineWidth: 1.5)
                    .frame(width: 70)
                Circle()
                    .stroke(Theme.deepBrown.opacity(0.07), lineWidth: 1.5)
                    .frame(width: 50)
            }
        }
    }
}

struct HeartFlowerShape: View {
    var body: some View {
        ZStack {
            ForEach(0..<8) { i in
                HeartPath()
                    .stroke(Theme.deepBrown.opacity(0.15), lineWidth: 2.0)
                    .frame(width: 130, height: 130)
                    .rotationEffect(.degrees(Double(i) * 45))
            }
            ForEach(0..<6) { i in
                HeartPath()
                    .stroke(Theme.deepBrown.opacity(0.12), lineWidth: 1.8)
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(Double(i) * 60 + 30))
            }
            Circle()
                .stroke(Theme.deepBrown.opacity(0.18), lineWidth: 2.0)
                .frame(width: 60)
            Circle()
                .stroke(Theme.deepBrown.opacity(0.10), lineWidth: 1.5)
                .frame(width: 35)
        }
    }
}

struct HeartPath: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height
        path.move(to: CGPoint(x: w/2, y: h*0.85))
        path.addCurve(to: CGPoint(x: w/2, y: h*0.25),
                      control1: CGPoint(x: -w*0.1, y: h*0.6),
                      control2: CGPoint(x: -w*0.1, y: h*0.1))
        path.addCurve(to: CGPoint(x: w/2, y: h*0.85),
                      control1: CGPoint(x: w*1.1, y: h*0.1),
                      control2: CGPoint(x: w*1.1, y: h*0.6))
        return path
    }
}

// MARK: - DOODLE ROOM VIEW

struct DoodleRoomView: View {
    
    @EnvironmentObject var moodStore: MoodStore
    
    @State private var strokes: [Stroke] = []
    @State private var currentStroke: Stroke? = nil
    @State private var brushSize: CGFloat = 4
    @State private var savedImage: UIImage? = nil
    @State private var navigateToJournal = false
    @State private var selectedColor: Color = Theme.deepBrown
    @State private var selectedTracing: TracingShape = .none
    @State private var showTracingPicker = false
    @State private var showSaveConfirm = false
    @State private var showPalette = false
    @State private var showBrush = false
    @State private var zoomScale: CGFloat = 1.0
    @State private var lastZoomScale: CGFloat = 1.0
    
    struct Stroke {
        var points: [CGPoint]
        var color: Color
        var lineWidth: CGFloat
    }
    
    let moodPalette: [[Color]] = [
        [.black, Theme.deepBrown, Color(red: 0.55, green: 0.35, blue: 0.20),
         Color(red: 0.72, green: 0.52, blue: 0.32), Theme.goldSoft],
        [Color(red: 0.30, green: 0.45, blue: 0.65), .blue, .cyan,
         Color(red: 0.40, green: 0.70, blue: 0.75), .teal],
        [.pink, Color(red: 0.85, green: 0.40, blue: 0.55), .red,
         Color(red: 0.90, green: 0.60, blue: 0.60), Color(red: 0.95, green: 0.80, blue: 0.80)],
        [.purple, Color(red: 0.55, green: 0.30, blue: 0.70), .indigo,
         Color(red: 0.70, green: 0.55, blue: 0.85), .white]
    ]
    
    var body: some View {
        ZStack {
            MoodBackgroundView(mood: moodStore.selectedMood)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                VStack(spacing: 4) {
                    Text("Doodle Room")
                        .font(Theme.sectionTitle)
                        .foregroundStyle(Theme.textPrimary)
                    Text("Let your feeling move through your hand")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary.opacity(0.7))
                }
                .padding(.top, 12)
                .padding(.bottom, 8)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(TracingShape.allCases) { shape in
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTracing = shape
                                }
                            } label: {
                                Text(shape.rawValue)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(selectedTracing == shape
                                                  ? Theme.deepBrown
                                                  : Theme.warmParchment.opacity(0.6))
                                    )
                                    .foregroundStyle(selectedTracing == shape
                                                     ? Theme.warmParchment
                                                     : Theme.textSecondary)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 8)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.85))
                        .shadow(color: Color.black.opacity(0.08), radius: 10)
                    
                    if selectedTracing != .none {
                        GeometryReader { geo in
                            ZStack {
                                TracingOverlay(shape: selectedTracing)
                                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                            }
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                            .allowsHitTesting(false)
                        }
                    }
                    
                    Canvas { context, size in
                        for stroke in strokes {
                            var path = Path()
                            guard stroke.points.count > 1 else { continue }
                            path.move(to: stroke.points[0])
                            for i in 1..<stroke.points.count {
                                let mid = CGPoint(
                                    x: (stroke.points[i-1].x + stroke.points[i].x) / 2,
                                    y: (stroke.points[i-1].y + stroke.points[i].y) / 2
                                )
                                path.addQuadCurve(to: mid, control: stroke.points[i-1])
                            }
                            path.addLine(to: stroke.points.last!)
                            context.stroke(path, with: .color(stroke.color.opacity(0.15)),
                                           style: StrokeStyle(lineWidth: stroke.lineWidth * 3, lineCap: .round, lineJoin: .round))
                            context.stroke(path, with: .color(stroke.color.opacity(0.25)),
                                           style: StrokeStyle(lineWidth: stroke.lineWidth * 1.8, lineCap: .round, lineJoin: .round))
                            context.stroke(path, with: .color(stroke.color.opacity(0.9)),
                                           style: StrokeStyle(lineWidth: stroke.lineWidth, lineCap: .round, lineJoin: .round))
                        }
                        if let liveStroke = currentStroke {
                            var path = Path()
                            guard liveStroke.points.count > 1 else { return }
                            path.move(to: liveStroke.points[0])
                            for i in 1..<liveStroke.points.count {
                                let mid = CGPoint(
                                    x: (liveStroke.points[i-1].x + liveStroke.points[i].x) / 2,
                                    y: (liveStroke.points[i-1].y + liveStroke.points[i].y) / 2
                                )
                                path.addQuadCurve(to: mid, control: liveStroke.points[i-1])
                            }
                            path.addLine(to: liveStroke.points.last!)
                            context.stroke(path, with: .color(liveStroke.color.opacity(0.15)),
                                           style: StrokeStyle(lineWidth: liveStroke.lineWidth * 3, lineCap: .round, lineJoin: .round))
                            context.stroke(path, with: .color(liveStroke.color.opacity(0.9)),
                                           style: StrokeStyle(lineWidth: liveStroke.lineWidth, lineCap: .round, lineJoin: .round))
                        }
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if currentStroke == nil {
                                    currentStroke = Stroke(points: [], color: selectedColor, lineWidth: brushSize)
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
                .scaleEffect(zoomScale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / lastZoomScale
                            lastZoomScale = value
                            zoomScale = min(max(zoomScale * delta, 1.0), 4.0)
                        }
                        .onEnded { _ in
                            lastZoomScale = 1.0
                        }
                )
                
                
                .frame(minHeight: 420)
                .padding(.horizontal, 16)
                
                VStack(spacing: 6) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) { showPalette.toggle() }
                    } label: {
                        HStack {
                            Circle()
                                .fill(selectedColor)
                                .frame(width: 20, height: 20)
                                .overlay(Circle().stroke(Theme.goldSoft.opacity(0.5), lineWidth: 1))
                            Text("Colour")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(Theme.textSecondary)
                            Spacer()
                            Image(systemName: showPalette ? "chevron.up" : "chevron.down")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary.opacity(0.5))
                        }
                        .padding(.horizontal, 20)
                    }
                    if showPalette {
                        VStack(spacing: 6) {
                            ForEach(moodPalette.indices, id: \.self) { row in
                                HStack(spacing: 8) {
                                    ForEach(moodPalette[row].indices, id: \.self) { col in
                                        let color = moodPalette[row][col]
                                        Circle()
                                            .fill(color)
                                            .frame(width: 30, height: 30)
                                            .overlay(Circle().stroke(
                                                selectedColor == color ? Theme.goldSoft : Color.clear,
                                                lineWidth: 2.5))
                                            .shadow(color: color.opacity(0.3), radius: 4)
                                            .onTapGesture { selectedColor = color }
                                    }
                                }
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.vertical, 6)
                
                VStack(spacing: 8) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) { showBrush.toggle() }
                    } label: {
                        HStack {
                            Image(systemName: "pencil.tip")
                                .foregroundStyle(Theme.textSecondary.opacity(0.5))
                                .font(.caption)
                            Text("Brush Size")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(Theme.textSecondary)
                            Spacer()
                            Image(systemName: showBrush ? "chevron.up" : "chevron.down")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary.opacity(0.5))
                        }
                        .padding(.horizontal, 20)
                    }
                    if showBrush {
                        HStack {
                            Image(systemName: "pencil.tip")
                                .foregroundStyle(Theme.textSecondary.opacity(0.5))
                                .font(.caption)
                            Slider(value: $brushSize, in: 1...20)
                                .tint(selectedColor)
                            Image(systemName: "pencil.tip")
                                .foregroundStyle(Theme.textSecondary.opacity(0.5))
                                .font(.title3)
                        }
                        .padding(.horizontal, 20)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    HStack(spacing: 16) {
                        Button {
                            if !strokes.isEmpty { strokes.removeLast() }
                        } label: {
                            Label("Undo", systemImage: "arrow.uturn.backward")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        Button {
                            strokes.removeAll()
                        } label: {
                            Label("Clear", systemImage: "trash")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                zoomScale = 1.0
                            }
                        } label: {
                            Label("Reset", systemImage: "arrow.counterclockwise")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        
                        
                        Spacer()
                        Button {
                            showSaveConfirm = true
                        } label: {
                            Text("Save & Journal")
                                .font(.caption.weight(.medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Theme.deepBrown)
                                .foregroundStyle(Theme.warmParchment)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                FloatingMusicPlayer()
                    .padding(.bottom, 8)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Save your doodle?",
            isPresented: $showSaveConfirm,
            titleVisibility: .visible
        ) {
            Button("Save & Open Journal") { saveDrawing() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will save your artwork and open your journal.")
        }
        .navigationDestination(isPresented: $navigateToJournal) {
            JournalViewWithImage(image: savedImage)
        }
    }
    
    func saveDrawing() {
        let capturedStrokes = strokes
        
        // Fixed size for rendering
        let renderWidth: CGFloat = 390
        let renderHeight: CGFloat = 420
        
        let content = ZStack {
            Color.white
            Canvas { context, size in
                for stroke in capturedStrokes {
                    var path = Path()
                    guard stroke.points.count > 1 else { continue }
                    path.move(to: stroke.points[0])
                    for i in 1..<stroke.points.count {
                        let mid = CGPoint(
                            x: (stroke.points[i-1].x + stroke.points[i].x) / 2,
                            y: (stroke.points[i-1].y + stroke.points[i].y) / 2
                        )
                        path.addQuadCurve(to: mid, control: stroke.points[i-1])
                    }
                    path.addLine(to: stroke.points.last!)
                    context.stroke(path, with: .color(stroke.color),
                                   style: StrokeStyle(lineWidth: stroke.lineWidth,
                                                      lineCap: .round, lineJoin: .round))
                }
            }
        }
            .frame(width: renderWidth, height: renderHeight)
        
        let renderer = ImageRenderer(content: content)
        renderer.scale = 2.0
        
        if let cgImage = renderer.cgImage {
            let image = UIImage(cgImage: cgImage)
            // Convert to JPEG to remove alpha channel warning
            if let jpegData = image.jpegData(compressionQuality: 0.9) {
                if let jpegImage = UIImage(data: jpegData) {
                    savedImage = jpegImage
                    UIImageWriteToSavedPhotosAlbum(jpegImage, nil, nil, nil)
                    navigateToJournal = true
                }
            }
        }
    }
}
