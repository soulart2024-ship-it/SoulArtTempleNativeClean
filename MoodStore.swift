//
//  MoodStore.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 10/04/2026.
//
import SwiftUI
import Combine

class MoodStore: ObservableObject {
    
    @Published var selectedMood: MoodTheme = MoodManager.load()
    
    func setMood(_ mood: MoodTheme) {
        selectedMood = mood
        MoodManager.save(mood)
    }
}
