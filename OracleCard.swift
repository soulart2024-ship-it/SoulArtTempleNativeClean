//
//  OracleCard.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 02/04/2026.
//
import Foundation

struct OracleCard: Identifiable, Codable {
    
    var id: UUID = UUID()
    
    let title: String
    let message: String
    
    // 🌿 NEW STRUCTURE
    let frequency: Int?
    let colour: String?
    let activation: String?
    let affirmation: String?
    
    let type: CardType
    
}

enum CardType: String, Codable {
    case soulArt
    case sacredSignature
    case blessing
}
