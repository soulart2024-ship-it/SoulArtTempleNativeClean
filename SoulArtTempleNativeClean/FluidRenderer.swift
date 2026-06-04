import MetalKit
import UIKit

class FluidRenderer: NSObject, MTKViewDelegate {
    
    // MARK: - SETUP
    
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    
    // MARK: - PARTICLES
    
    struct Particle {
        var position: CGPoint
        var velocity: CGPoint
        var life: CGFloat
    }
    
    var particles: [Particle] = []
    var touchPoint: CGPoint?
    
    // MARK: - INIT
    
    init(mtkView: MTKView) {
        self.device = mtkView.device
        self.commandQueue = device.makeCommandQueue()
        super.init()
    }
    
    // MARK: - INPUT
    
    func addPaint(at point: CGPoint) {
        touchPoint = point
        
        for _ in 0..<4 {
            particles.append(
                Particle(
                    position: point,
                    velocity: CGPoint(
                        x: CGFloat.random(in: -1...1),
                        y: CGFloat.random(in: -1...1)
                    ),
                    life: 1.0
                )
            )
        }
    }
    
    func setFingerPosition(_ point: CGPoint?) {
        touchPoint = point
    }
    
    func setBrushColor(_ color: UIColor) {
        // later
    }
    
    // MARK: - UPDATE
    
    func updateParticles() {
        
        for i in particles.indices {
            
            particles[i].position.x += particles[i].velocity.x
            particles[i].position.y += particles[i].velocity.y
            
            particles[i].velocity.x *= 0.97
            particles[i].velocity.y *= 0.97
            
            particles[i].life -= 0.08
        }
        
        particles.removeAll { $0.life <= 0 }
    }
    
    // MARK: - DRAW
    
    func draw(in view: MTKView) {
        
        updateParticles()
        
        guard
            let drawable = view.currentDrawable,
            let commandBuffer = commandQueue.makeCommandBuffer(),
            let passDescriptor = view.currentRenderPassDescriptor
        else { return }
        
        passDescriptor.colorAttachments[0].clearColor =
            MTLClearColor(red: 0.02, green: 0.02, blue: 0.04, alpha: 1)
        
        let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDescriptor)!
        
        let path = UIBezierPath()
        
        for particle in particles {
            let rect = CGRect(
                x: particle.position.x,
                y: particle.position.y,
                width: 12,
                height: 12
            )
            
            path.append(UIBezierPath(ovalIn: rect))
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.withAlphaComponent(0.03).cgColor
        shapeLayer.shadowRadius = 20
        shapeLayer.shadowOpacity = 0.2
        
        view.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        view.layer.addSublayer(shapeLayer)
        
        encoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    // MARK: - REQUIRED
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // required but unused
    }
}
