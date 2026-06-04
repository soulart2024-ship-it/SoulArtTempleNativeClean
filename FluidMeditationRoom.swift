import SwiftUI
import MetalKit

struct FluidMeditationRoom: View {
    
    @State private var renderer: FluidRenderer?
    
    var body: some View {
        
        ZStack {
            
            FluidMetalView(renderer: $renderer)
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                paletteBar
                    .padding(.bottom, 30)
            }
        }
    }   // ✅ BODY ENDS HERE
    
    
    // 🌿 PALETTE BAR (OUTSIDE BODY)
    var paletteBar: some View {
        
        HStack {
            
            ColorButton(color: .blue)
            ColorButton(color: .cyan)
            ColorButton(color: .purple)
            ColorButton(color: .yellow)
            ColorButton(color: .systemPink)
        }
        .frame(height: 60)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Theme.cardPrimary.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Theme.goldSoft.opacity(0.15), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
    
    
    // 🌿 COLOR BUTTON (OUTSIDE BODY)
    func ColorButton(color: UIColor) -> some View {
        
        Button {
            renderer?.setBrushColor(color)
        } label: {
            Circle()
                .fill(Color(color))
                .frame(width: 40, height: 40)
        }
        .padding(6)
    }
}
    
    struct FluidMetalView: UIViewRepresentable {
        
        @Binding var renderer: FluidRenderer?
        
        func makeUIView(context: Context) -> MTKView {
            
            let view = MTKView()
            
            view.device = MTLCreateSystemDefaultDevice()
            
            let fluidRenderer = FluidRenderer(mtkView: view)
            
            view.delegate = fluidRenderer
            
            DispatchQueue.main.async {
                renderer = fluidRenderer
            }
            
            let gesture = UIPanGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.handlePan(_:))
            )
            
            view.addGestureRecognizer(gesture)
            
            context.coordinator.renderer = fluidRenderer
            
            return view
        }
        
        func updateUIView(_ uiView: MTKView, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator()
        }
        
        class Coordinator: NSObject {
            
            var renderer: FluidRenderer?
            
            @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
                
                guard let view = gesture.view as? MTKView else { return }
                
                let location = gesture.location(in: view)
                
                if gesture.state == .began {
                    renderer?.addPaint(at: location)
                    renderer?.setFingerPosition(location)
                }
                
                if gesture.state == .changed {
                    renderer?.addPaint(at: location)
                    renderer?.setFingerPosition(location)
                }
                
                if gesture.state == .ended {
                    renderer?.setFingerPosition(nil)
                }
            }
        }
    }

