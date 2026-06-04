import SwiftUI
import AVFoundation
import Combine

class MusicPlayer: ObservableObject {
    
    static let shared = MusicPlayer()
    
    @Published var isPlaying = false
    @Published var currentTrack: String? = nil
    @Published var isPaused: Bool = false
    @Published var showPlayer: Bool = false
    
    private var player: AVAudioPlayer?
    
    func playTrack(_ name: String) {
        
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Sound file not found: \(name)")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.volume = 0.0
            player?.prepareToPlay()
            player?.play()
       
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                guard let player = self.player else {
                    timer.invalidate()
                    return
                }

                if player.volume < 0.15 {
                    player.volume += 0.01
                } else {
                    player.volume = 0.15
                    timer.invalidate()
                }
            }
            
            currentTrack = name   // ✅ FIXED
            isPlaying = true
            isPaused = false
            showPlayer = true
            
        } catch {
            print("Audio error:", error)
        }
    }
    
    func playFrequency(_ fileName: String) {
        playTrack(fileName)
    }
    
    func stopSound() {
        player?.stop()
        currentTrack = nil        // ✅ ADD THIS
        isPlaying = false
        isPaused = false         // ✅ ADD THIS
    }
    func pauseSound() {
        player?.pause()
        isPlaying = false
        isPaused = true
    }
    
    func resumeSound() {
        player?.play()
        isPlaying = true
        isPaused = false
    }
}
