//
//  AurumService.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 15/04/2026.
//
import Foundation

class AurumService {
    
    static let shared = AurumService()
 
    private var conversationHistory: [[String: String]] = []
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let config = try? PropertyListSerialization.propertyList(from: xml, format: nil) as? [String: Any],
              let key = config["OPENAI_API_KEY"] as? String else {
            return ""
        }
        return key
    }
  
    func sendMessage(_ message: String) async throws -> String {
        print("API KEY:", apiKey)
        
        guard let url = URL(string: "https://api.openai.com/v1/responses") else {
            return "Something went quiet… try again."
        }
        
        let systemPrompt = """
        You are Aurum.

        A calm, grounded, emotionally intelligent guide.

        You meet the user exactly where they are, without judgement.
        You acknowledge what they feel first — always.

        Then you guide them inward toward awareness, clarity, and self-trust.

        You naturally shift between two modes:

        1. Gentle Presence (default)
        - soft, reflective, grounding
        - helps the user feel seen and safe
        - invites awareness through subtle questions

        2. Gentle Authority (when needed)
        - used when the user is overwhelmed, stuck, anxious, or looping
        - calm but clear direction
        - short, grounded instructions (e.g. pause, breathe, feel, stop)

        In this mode you may say things like:
        - “Pause for a moment.”
        - “Stay here. Breathe slowly.”
        - “Come back to your body.”
        - “You don’t need to solve this right now.”

        You do not overwhelm.
        You do not give long explanations.
        You do not sound clinical or scripted.

        You may guide users toward tools in the app such as:
        - journaling
        - emotion decoding
        - breathwork
        - stillness

        Your role is to help the user:
        see themselves clearly,
        feel grounded,
        and return to inner calm and alignment.

        Keep responses short, human, and supportive.
        """
        
        conversationHistory.append([
            "role": "user",
            "content": message
        ])

        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "input": [
                [
                    "role": "system",
                    "content": [
                        ["type": "input_text", "text": systemPrompt]
                    ]
                ],
                [
                    "role": "user",
                    "content": [
                        ["type": "input_text", "text": message]
                    ]
                ]
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let raw = String(data: data, encoding: .utf8) {
            print("RAW JSON:", raw)
        }
        
        if let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            
            print("FULL RESPONSE:", response) // 🔍 IMPORTANT DEBUG
            
            if let output = response["output"] as? [[String: Any]],
               let first = output.first,
               let contentArray = first["content"] as? [[String: Any]],
               let textBlock = contentArray.first,
               let content = textBlock["text"] as? String {
                
                let reply = content.trimmingCharacters(in: .whitespacesAndNewlines)

                conversationHistory.append([
                    "role": "assistant",
                    "content": reply
                ])

                return reply
            }
            
            return "I’m still here… something didn’t come through."
        }
        
        // ✅ THIS IS THE FIX — ADD THIS LINE
             return "The connection feels quiet… try again."
    }
}
