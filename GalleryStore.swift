//
//  GalleryStore.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 12/04/2026.
//
import SwiftUI
import Combine

class GalleryStore: ObservableObject {   // ✅ THIS LINE IS THE FIX
    
    @Published var artworks: [UIImage] = []
    
    func add(_ image: UIImage) {
        artworks.insert(image, at: 0)
    }
}
