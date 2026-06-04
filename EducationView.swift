//
//  EducationView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 07/04/2026.

import SwiftUI

enum EducationTopic {
    case emotionDecoding
    case kinesiology
    case bodyAwareness
}

struct EducationView: View {
    
    let topic: EducationTopic
    
    var body: some View {
        
        ZStack {
            
            Theme.templeParchment
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text(title)
                        .font(Theme.sectionTitle)
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text(content)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textPrimary)
                        .lineSpacing(4)
                }
                .padding(20)
            }
        }
    }
    
    private var title: String {
        switch topic {
        case .emotionDecoding: return "Emotional Decoding"
        case .kinesiology: return "Kinesiology"
        case .bodyAwareness: return "Body Awareness"
        }
    }
    
    private var content: String {
        switch topic {
            
        case .emotionDecoding:
            return "Emotional decoding helps you identify stored emotional patterns without needing to relive them. The body already knows what is ready to be released."
            
        case .kinesiology:
            return "Kinesiology works with the body's natural feedback system. Subtle responses guide awareness toward what is out of balance."
            
        case .bodyAwareness:
            return "The body holds experiences. When we bring awareness to sensation, we allow natural recalibration to occur."
        }
    }
}

