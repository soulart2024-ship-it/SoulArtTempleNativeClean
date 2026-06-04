import SwiftUI

struct FluidArtView: View {

    @State private var strokes: [PaintStroke] = []
    @State private var currentPoints: [CGPoint] = []
    @State private var selectedColor: Color = Color(red: 0.20, green: 0.40, blue: 0.75)
    @State private var brushSize: CGFloat = 14
    @State private var paintMode: PaintMode = .flow
    @State private var showSaveSheet = false
    @State private var savedImage: UIImage? = nil
    @State private var showShareSheet = false
    @State private var showPalette = true
    @State private var canvasBackground: Color = Color(red: 0.04, green: 0.04, blue: 0.08)

    let inkPalette: [[Color]] = [
        // Row 1 — Deep inks
        [
            Color(red: 0.05, green: 0.10, blue: 0.40),
            Color(red: 0.20, green: 0.40, blue: 0.75),
            Color(red: 0.00, green: 0.65, blue: 0.85),
            Color(red: 0.10, green: 0.70, blue: 0.60),
            Color(red: 0.05, green: 0.45, blue: 0.30)
        ],
        // Row 2 — Warm pigments
        [
            Color(red: 0.70, green: 0.10, blue: 0.15),
            Color(red: 0.85, green: 0.35, blue: 0.10),
            Color(red: 0.90, green: 0.65, blue: 0.10),
            Color(red: 0.75, green: 0.20, blue: 0.50),
            Color(red: 0.55, green: 0.10, blue: 0.55)
        ],
        // Row 3 — Light and metallic
        [
            Color.white,
            Color(red: 0.85, green: 0.80, blue: 0.65),
            Color(red: 0.82, green: 0.74, blue: 0.55),
            Color(red: 0.70, green: 0.70, blue: 0.75),
            Color(red: 0.40, green: 0.40, blue: 0.45)
        ]
    ]

    let backgroundOptions: [Color] = [
        Color(red: 0.04, green: 0.04, blue: 0.08),
        Color(red: 0.08, green: 0.05, blue: 0.12),
        Color.white,
        Color(red: 0.96, green: 0.94, blue: 0.90),
        Color(red: 0.05, green: 0.12, blue: 0.08)
    ]

    var body: some View {

        ZStack(alignment: .bottom) {

            // 🌑 OUTER BACKGROUND
            Color(red: 0.06, green: 0.06, blue: 0.10)
                .ignoresSafeArea()

            // 🎨 CANVAS FILLS FULL SCREEN
            VStack(spacing: 0) {

                // 🌿 HEADER
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Fluid Art")
                            .font(Theme.sectionTitle)
                            .foregroundStyle(.white)
                        Text("Let colour flow and blend")
                            .font(Theme.smallText)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    Spacer()
                    HStack(spacing: 0) {
                        modeButton(title: "Flow", mode: .flow)
                        modeButton(title: "Blend", mode: .blend)
                    }
                    .background(Capsule().fill(Color.white.opacity(0.08)))
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)

                // 🎨 CANVAS — FILLS ALL REMAINING SPACE
                ZStack {
                    canvasBackground
                    FluidCanvas(strokes: strokes, paintMode: paintMode)
                    if !currentPoints.isEmpty {
                        Canvas { context, _ in
                            var path = Path()
                            guard currentPoints.count > 1 else { return }
                            path.move(to: currentPoints[0])
                            for i in 1..<currentPoints.count {
                                let mid = CGPoint(
                                    x: (currentPoints[i-1].x + currentPoints[i].x) / 2,
                                    y: (currentPoints[i-1].y + currentPoints[i].y) / 2
                                )
                                path.addQuadCurve(to: mid, control: currentPoints[i-1])
                            }
                            path.addLine(to: currentPoints.last!)
                            context.stroke(path,
                                          with: .color(selectedColor.opacity(0.85)),
                                          style: StrokeStyle(lineWidth: brushSize, lineCap: .round, lineJoin: .round))
                            context.stroke(path,
                                          with: .color(selectedColor.opacity(0.12)),
                                          style: StrokeStyle(lineWidth: brushSize * 2.5, lineCap: .round, lineJoin: .round))
                        }
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if paintMode == .blend {
                                blendNearby(at: value.location)
                            } else {
                                currentPoints.append(value.location)
                            }
                        }
                        .onEnded { _ in
                            if paintMode == .flow && !currentPoints.isEmpty {
                                strokes.append(PaintStroke(
                                    points: currentPoints,
                                    color: selectedColor,
                                    lineWidth: brushSize
                                ))
                            }
                            currentPoints = []
                        }
                )
                .clipShape(Rectangle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            // 🎛 CONTROLS OVERLAY — SITS AT BOTTOM OVER CANVAS
            VStack(spacing: 8) {

                Spacer()

                VStack(spacing: 8) {

                    // Canvas background
                    HStack(spacing: 8) {
                        Text("Canvas")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.4))
                        ForEach(backgroundOptions.indices, id: \.self) { i in
                            Circle()
                                .fill(backgroundOptions[i])
                                .frame(width: 22, height: 22)
                                .overlay(Circle().stroke(
                                    canvasBackground == backgroundOptions[i]
                                    ? Theme.goldSoft : Color.white.opacity(0.15),
                                    lineWidth: 1.5))
                                .onTapGesture { canvasBackground = backgroundOptions[i] }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)

                    // Colour toggle
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) { showPalette.toggle() }
                    } label: {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(selectedColor)
                                .frame(width: 18, height: 18)
                                .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                            Text("Colour")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.white.opacity(0.6))
                            Spacer()
                            Image(systemName: showPalette ? "chevron.up" : "chevron.down")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.3))
                        }
                        .padding(.horizontal, 16)
                    }

                    if showPalette {
                        VStack(spacing: 6) {
                            ForEach(inkPalette.indices, id: \.self) { row in
                                HStack(spacing: 10) {
                                    ForEach(inkPalette[row].indices, id: \.self) { col in
                                        let color = inkPalette[row][col]
                                        Circle()
                                            .fill(color)
                                            .frame(width: 30, height: 30)
                                            .overlay(Circle().stroke(
                                                selectedColor == color ? Theme.goldSoft : Color.white.opacity(0.10),
                                                lineWidth: selectedColor == color ? 2.5 : 1))
                                            .shadow(color: color.opacity(0.4), radius: 4)
                                            .onTapGesture { selectedColor = color }
                                    }
                                }
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    // Brush
                    HStack(spacing: 10) {
                        Circle().fill(.white.opacity(0.4)).frame(width: 6, height: 6)
                        Slider(value: $brushSize, in: 2...40).tint(selectedColor)
                        Circle().fill(.white.opacity(0.4)).frame(width: 18, height: 18)
                    }
                    .padding(.horizontal, 16)

                    // Actions
                    HStack(spacing: 12) {
                        actionButton(icon: "arrow.uturn.backward", label: "Undo") {
                            if !strokes.isEmpty { strokes.removeLast() }
                        }
                        actionButton(icon: "trash", label: "Clear") {
                            strokes.removeAll()
                            currentPoints = []
                        }
                        
                        // 🎵 MUSIC TRIGGER
                        if MusicPlayer.shared.currentTrack == nil {
                            actionButton(icon: "music.note", label: "Music") {
                                MusicPlayer.shared.playTrack("432hz")
                            }
                        }
                        
                        Spacer()
                        Button {
                            if let url = URL(string: "https://www.printify.com") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Label("Print", systemImage: "printer")
                                .font(.caption.weight(.medium))
                                .lineLimit(1)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.10))
                                .foregroundStyle(.white.opacity(0.7))
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1))
                        }
                        Button { saveArtwork() } label: {
                            Label("Save & Share", systemImage: "square.and.arrow.up")
                                .font(.caption.weight(.medium))
                                .lineLimit(1)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Theme.goldSoft)
                                .foregroundStyle(Theme.deepBrown)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 4)

                
                }
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)

                        .fill(Color(red: 0.06, green: 0.06, blue: 0.10).opacity(0.92))
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }

        .sheet(isPresented: $showShareSheet) {
            if let image = savedImage {
                ShareSheet(items: [image])
            }
        }
        .preferredColorScheme(.dark)
        .toolbar(.hidden, for: .tabBar)
    }


    

    // MARK: - MODE BUTTON

    func modeButton(title: String, mode: PaintMode) -> some View {
        Button {
            paintMode = mode
        } label: {
            Text(title)
                .font(.caption.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(paintMode == mode
                              ? Theme.goldSoft
                              : Color.clear)
                )
                .foregroundStyle(paintMode == mode
                                 ? Theme.deepBrown
                                 : .white.opacity(0.5))
        }
    }

    // MARK: - ACTION BUTTON

    func actionButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                Text(label)
                    .font(.caption)
            }
            .foregroundStyle(.white.opacity(0.5))
        }
    }

    // MARK: - BLEND

    func blendNearby(at location: CGPoint) {
        let blendRadius: CGFloat = 40
        for i in strokes.indices {
            guard let lastPoint = strokes[i].points.last else { continue }
            let dx = lastPoint.x - location.x
            let dy = lastPoint.y - location.y
            let distance = sqrt(dx*dx + dy*dy)
            if distance < blendRadius {
                let uiA = UIColor(strokes[i].color)
                let uiB = UIColor(selectedColor)
                var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
                var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
                uiA.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
                uiB.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
                let mix: CGFloat = 0.15
                strokes[i].color = Color(
                    red: r1 + (r2 - r1) * mix,
                    green: g1 + (g2 - g1) * mix,
                    blue: b1 + (b2 - b1) * mix
                )
            }
        }
    }

    // MARK: - SAVE

    func saveArtwork() {
        let renderer = ImageRenderer(
            content:
                ZStack {
                    canvasBackground
                    FluidCanvas(strokes: strokes, paintMode: paintMode)
                }
                .frame(width: 390, height: 520)

        )
        renderer.scale = 3.0
        if let cgImage = renderer.cgImage {
            let image = UIImage(cgImage: cgImage)
            savedImage = image
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showShareSheet = true
            }
        }
    }
}

// MARK: - SHARE SHEET

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
