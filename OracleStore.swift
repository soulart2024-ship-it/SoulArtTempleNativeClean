import SwiftUI
import Combine   // 👈 ADD THIS LINE

class OracleStore: ObservableObject {
    
    @Published var deck: [OracleCard] = []
    @Published var drawnCards: [OracleCard] = []
    
    init() {
        loadDeck()
    }
    
    // 🃏 LOAD YOUR CARDS
    func loadDeck() {
        
        deck = [
            
                    // 🌿 1–31 SOULART CARDS
                    
            // 🌿 SOULART CARDS (1–32)

            OracleCard(
                title: "Be Safe",
                message: "You are held in this moment.\nSafety is already here.",
                frequency: 50,
                colour: "Deep Red",
                activation: "Recall a moment you felt safe.\nHold the feeling.\nGently tap your third eye to anchor it.",
                affirmation: "I am safe in my body.\nI allow support to hold me.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Courage",
                message: "You are stronger than this moment.\nCourage is already within you.",
                frequency: 200,
                colour: "Orange",
                activation: "Feel into your breath.\nLet courage rise through your chest.\nAnchor it with awareness.",
                affirmation: "I move forward with courage.\nI trust myself.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Acceptance",
                message: "What is here is asking to be seen.\nYou do not need to resist it.",
                frequency: 350,
                colour: "Yellow",
                activation: "Bring awareness to what is present.\nSoften your body.\nAllow it without judgment.",
                affirmation: "I accept what is.\nI soften into the moment.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Love",
                message: "Love is not something you find.\nIt is something you are.",
                frequency: 500,
                colour: "Green",
                activation: "Place your hand on your heart.\nFeel warmth expand.\nLet it fill your body.",
                affirmation: "I am love.\nI allow love to flow through me.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Joy",
                message: "Joy is available to you now.\nYou are allowed to feel light.",
                frequency: 540,
                colour: "Light Green",
                activation: "Recall a joyful moment.\nLet it rise in your body.\nSmile gently.",
                affirmation: "I welcome joy.\nI allow lightness to return.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Peace",
                message: "Peace is not outside of you.\nIt lives within your stillness.",
                frequency: 600,
                colour: "Blue",
                activation: "Slow your breath.\nRelax your shoulders.\nSink into stillness.",
                affirmation: "I am peace.\nI return to calm.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Truth",
                message: "Truth lives quietly within you.\nYou already know.",
                frequency: 700,
                colour: "Indigo",
                activation: "Bring awareness to your inner voice.\nNotice what feels true.\nTrust it.",
                affirmation: "I trust my truth.\nI honour what I know.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Presence",
                message: "This moment is enough.\nYou are already here.",
                frequency: 650,
                colour: "Blue",
                activation: "Bring your awareness to your breath.\nFeel your body.\nReturn to now.",
                affirmation: "I am present.\nI am here.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Calm",
                message: "Your system is safe to slow down.\nYou do not need to rush.",
                frequency: 300,
                colour: "Soft Yellow",
                activation: "Slow your breath.\nRelease tension from your shoulders.\nLet calm settle in.",
                affirmation: "I am calm.\nI move with ease.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Grounded",
                message: "You are supported by the earth beneath you.\nYou are safe to land.",
                frequency: 250,
                colour: "Earth Red",
                activation: "Feel your feet.\nImagine roots growing down.\nAnchor into the ground.",
                affirmation: "I am grounded.\nI feel supported.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Open",
                message: "You are safe to soften.\nYou do not need to close.",
                frequency: 400,
                colour: "Green",
                activation: "Relax your chest.\nBreathe into your heart.\nAllow openness.",
                affirmation: "I am open.\nI receive with ease.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Trust",
                message: "Trust is already within you.\nYou do not need to search for it.",
                frequency: 550,
                colour: "Blue Green",
                activation: "Feel into your inner knowing.\nLet it guide you.\nStay with it.",
                affirmation: "I trust myself.\nI trust the process.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Light",
                message: "You are allowed to feel light again.\nYou are not meant to carry everything.",
                frequency: 540,
                colour: "Light Yellow",
                activation: "Shake off heaviness.\nBreathe in lightness.\nLet your body soften.",
                affirmation: "I welcome lightness.\nI feel free.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Clear",
                message: "Clarity comes when you stop forcing.\nLet it arrive naturally.",
                frequency: 600,
                colour: "Soft Blue",
                activation: "Pause.\nBreathe.\nAllow your mind to quiet.",
                affirmation: "I am clear.\nI see with ease.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Flow",
                message: "Life moves through you.\nYou do not need to resist it.",
                frequency: 520,
                colour: "Turquoise",
                activation: "Relax your body.\nFollow your breath.\nLet movement happen.",
                affirmation: "I am in flow.\nI move with life.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Gentle",
                message: "You do not need to push.\nGentleness will take you further.",
                frequency: 350,
                colour: "Soft Peach",
                activation: "Soften your jaw.\nRelax your shoulders.\nSlow everything down.",
                affirmation: "I am gentle with myself.\nI allow ease.",
                type: .soulArt
            ),
            // 🔥 SACRED SIGNATURE (32–44)

            OracleCard(
                title: "Sacred Flame",
                message: "Within you burns a divine fire of transformation.\nThis flame refines and renews.",
                frequency: 500,
                colour: "Golden Red",
                activation: "Feel the flame within your core.\nLet it rise.\nAllow it to transform what is ready.",
                affirmation: "I embody the sacred flame.\nI align with its power.",
                type: .sacredSignature
            ),

            OracleCard(
                title: "Sacred Light",
                message: "Light flows through your awareness.\nYou are guided in every step.",
                frequency: 600,
                colour: "Golden White",
                activation: "Visualise light entering your crown.\nLet it move through your body.\nRest in it.",
                affirmation: "I am guided by light.\nI trust this path.",
                type: .sacredSignature
            ),

            OracleCard(
                title: "Sacred Presence",
                message: "This moment is sacred.\nYou are exactly where you need to be.",
                frequency: 650,
                colour: "Soft Gold",
                activation: "Return to your breath.\nFeel your body.\nBe here fully.",
                affirmation: "I am present.\nThis moment is enough.",
                type: .sacredSignature
            ),

            OracleCard(
                title: "Sacred Expansion",
                message: "You are expanding beyond limitation.\nAllow yourself to open.",
                frequency: 540,
                colour: "Gold Green",
                activation: "Feel your energy expand outward.\nRelease contraction.\nAllow growth.",
                affirmation: "I expand with ease.\nI welcome growth.",
                type: .sacredSignature
            ),

            OracleCard(
                title: "Sacred Stillness",
                message: "Within stillness, everything becomes clear.\nThere is nothing you need to do.",
                frequency: 700,
                colour: "White Gold",
                activation: "Sit in silence.\nNotice your breath.\nAllow stillness to deepen.",
                affirmation: "I rest in stillness.\nI am at peace.",
                type: .sacredSignature
            ),

            OracleCard(
                title: "Sacred Alignment",
                message: "You are aligning with your highest truth.\nEverything is coming into harmony.",
                frequency: 600,
                colour: "Soft Gold Blue",
                activation: "Feel your body align.\nNotice what feels true.\nStay with it.",
                affirmation: "I am aligned.\nI trust my path.",
                type: .sacredSignature
            ),

            OracleCard(
                title: "Sacred Flow",
                message: "Life moves effortlessly through you.\nThere is no need to resist.",
                frequency: 520,
                colour: "Gold Turquoise",
                activation: "Relax your body.\nFollow your breath.\nAllow natural movement.",
                affirmation: "I am in flow.\nLife moves through me.",
                type: .sacredSignature
            ),

            OracleCard(
                title: "Sacred Trust",
                message: "Trust the unfolding.\nYou are being guided beyond what you can see.",
                frequency: 550,
                colour: "Gold Blue",
                activation: "Feel into trust.\nRelease control.\nAllow guidance.",
                affirmation: "I trust deeply.\nI am guided.",
                type: .sacredSignature
            ),

            OracleCard(
                title: "Sacred Awakening",
                message: "You are awakening to your true nature.\nThere is nothing to force.",
                frequency: 700,
                colour: "Violet Gold",
                activation: "Bring awareness inward.\nNotice what is shifting.\nAllow awakening.",
                affirmation: "I awaken naturally.\nI trust this process.",
                type: .sacredSignature
            ),

            OracleCard(
                title: "Sacred Knowing",
                message: "You already know.\nTruth lives quietly within you.",
                frequency: 650,
                colour: "Indigo Gold",
                activation: "Listen inward.\nNotice what feels true.\nTrust it.",
                affirmation: "I trust my knowing.\nI honour my truth.",
                type: .sacredSignature
            ),

            OracleCard(
                title: "Sacred Unity",
                message: "You are not separate.\nYou are part of something greater.",
                frequency: 600,
                colour: "Soft Gold",
                activation: "Feel connection.\nExpand awareness beyond self.\nRest in unity.",
                affirmation: "I am connected.\nI am part of the whole.",
                type: .sacredSignature
            ),

            OracleCard(
                title: "Sacred Grace",
                message: "Grace flows through you effortlessly.\nYou are supported in unseen ways.",
                frequency: 540,
                colour: "Gold Pink",
                activation: "Soften your body.\nAllow grace to move through you.\nReceive it.",
                affirmation: "I move with grace.\nI allow ease.",
                type: .sacredSignature
            ),

            OracleCard(
                title: "Sacred Completion",
                message: "You are completing a cycle.\nAllow yourself to close this chapter.",
                frequency: 500,
                colour: "Deep Gold",
                activation: "Reflect on what has ended.\nAcknowledge it.\nLet it complete.",
                affirmation: "I honour completion.\nI move forward freely.",
                type: .sacredSignature
            ),
          
            OracleCard(
                title: "Be Steady",
                message: "You do not need to rush.\nYour pace is enough.",
                frequency: 210,
                colour: "Warm Yellow",
                activation: "Slow your movements.\nAnchor into your breath.\nStay present with each step.",
                affirmation: "I move steadily.\nI trust my pace.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Strong",
                message: "Your strength is already within you.\nYou do not need to force it.",
                frequency: 200,
                colour: "Golden Orange",
                activation: "Feel into your core.\nStand tall.\nLet strength rise naturally.",
                affirmation: "I am strong.\nI stand in myself.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Willing",
                message: "You do not need all the answers.\nOnly the willingness to begin.",
                frequency: 125,
                colour: "Burnt Orange",
                activation: "Notice resistance.\nSoften it.\nAllow willingness to open.",
                affirmation: "I am willing.\nI open to what is next.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Direction",
                message: "You are allowed to choose a path.\nEven a small step is enough.",
                frequency: 150,
                colour: "Orange",
                activation: "Ask what feels right.\nFollow gently.\nTrust the step.",
                affirmation: "I move forward.\nI trust my direction.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Permission",
                message: "You are allowed to take up space.\nYou do not need approval.",
                frequency: 160,
                colour: "Soft Orange",
                activation: "Feel your body expand.\nRelease hesitation.\nAllow yourself.",
                affirmation: "I give myself permission.\nI am enough.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Release",
                message: "You are allowed to let go.\nYou do not need to carry this.",
                frequency: 180,
                colour: "Amber",
                activation: "Exhale deeply.\nRelease tension.\nLet it leave your body.",
                affirmation: "I release what no longer serves.\nI feel lighter.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Rising",
                message: "You are already moving forward.\nEven when it feels slow.",
                frequency: 230,
                colour: "Soft Gold",
                activation: "Notice your progress.\nAcknowledge it.\nLet it build.",
                affirmation: "I am rising.\nI trust my growth.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Power",
                message: "Your power has never left you.\nIt is waiting to be claimed.",
                frequency: 250,
                colour: "Golden Yellow",
                activation: "Feel into your centre.\nExpand your awareness.\nOwn your presence.",
                affirmation: "I am powerful.\nI stand fully in myself.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Supported",
                message: "You are not doing this alone.\nSupport is already here.",
                frequency: 100,
                colour: "Deep Red",
                activation: "Recall support in your life.\nFeel it.\nLet it hold you.",
                affirmation: "I am supported.\nI allow help.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Stabilised",
                message: "Everything can settle.\nYou are safe to find your centre.",
                frequency: 90,
                colour: "Dark Red",
                activation: "Slow your breath.\nFeel your body steady.\nAnchor yourself.",
                affirmation: "I am stable.\nI am safe in this moment.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Held",
                message: "You are not alone.\nYou are held in this moment.",
                frequency: 75,
                colour: "Deep Red",
                activation: "Feel into being supported.\nAllow your body to soften.\nRest into it.",
                affirmation: "I am held.\nI allow support.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Anchored",
                message: "You can return to yourself at any time.\nYou are your anchor.",
                frequency: 120,
                colour: "Earth Orange",
                activation: "Feel your feet.\nGround into your body.\nReturn inward.",
                affirmation: "I am anchored.\nI return to myself.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Centred",
                message: "Your centre is always available.\nCome back to it.",
                frequency: 175,
                colour: "Golden Orange",
                activation: "Bring awareness to your core.\nBreathe into it.\nStay there.",
                affirmation: "I am centred.\nI am balanced.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Ready",
                message: "You are more ready than you think.\nTrust yourself.",
                frequency: 190,
                colour: "Warm Orange",
                activation: "Feel into readiness.\nAllow it.\nStep forward gently.",
                affirmation: "I am ready.\nI trust myself.",
                type: .soulArt
            ),

            OracleCard(
                title: "Be Becoming",
                message: "You are evolving.\nAllow yourself to become.",
                frequency: 220,
                colour: "Soft Gold",
                activation: "Notice change.\nWelcome it.\nAllow expansion.",
                affirmation: "I am becoming.\nI trust my evolution.",
                type: .soulArt
            ),
            
            //MARK: Louise Hays Blessings
            
            OracleCard(
                title: "I Love Myself",
                message: "I deeply and completely love and accept myself. — Louise Hay",
                frequency: nil,
                colour: nil,
                activation: nil,
                affirmation: "I love myself.",
                type: .blessing
            ),

            OracleCard(
                title: "I Am Enough",
                message: "I am enough exactly as I am. — Louise Hay",
                frequency: nil,
                colour: nil,
                activation: nil,
                affirmation: "I am enough.",
                type: .blessing
            ),

            OracleCard(
                title: "I Am At Peace",
                message: "I am at peace with all that has happened, is happening, and will happen. — Louise Hay",
                frequency: nil,
                colour: nil,
                activation: nil,
                affirmation: "I am at peace.",
                type: .blessing
            ),

            OracleCard(
                title: "I Forgive Myself",
                message: "I forgive myself and set myself free. — Louise Hay",
                frequency: nil,
                colour: nil,
                activation: nil,
                affirmation: "I forgive myself.",
                type: .blessing
            ),

            OracleCard(
                title: "I Allow Good",
                message: "I allow good things to flow into my life. — Louise Hay",
                frequency: nil,
                colour: nil,
                activation: nil,
                affirmation: "I allow good.",
                type: .blessing
            ),

            OracleCard(
                title: "I Trust Myself",
                message: "I trust myself and my inner wisdom. — Louise Hay",
                frequency: nil,
                colour: nil,
                activation: nil,
                affirmation: "I trust myself.",
                type: .blessing
            ),

            OracleCard(
                title: "I Am Supported",
                message: "Life supports me in every possible way. — Louise Hay",
                frequency: nil,
                colour: nil,
                activation: nil,
                affirmation: "I am supported.",
                type: .blessing
            ),

            OracleCard(
                title: "I Choose Joy",
                message: "I choose to feel good about myself every day. — Louise Hay",
                frequency: nil,
                colour: nil,
                activation: nil,
                affirmation: "I choose joy.",
                type: .blessing
            ),

            OracleCard(
                title: "I Release Fear",
                message: "I release all fear and trust the process of life. — Louise Hay",
                frequency: nil,
                colour: nil,
                activation: nil,
                affirmation: "I release fear.",
                type: .blessing
            ),

            OracleCard(
                title: "I Am Grateful",
                message: "Gratitude fills my heart and my life. — Louise Hay",
                frequency: nil,
                colour: nil,
                activation: nil,
                affirmation: "I am grateful.",
                type: .blessing
            ),

            OracleCard(
                title: "I Welcome Change",
                message: "I am willing to change and grow. — Louise Hay",
                frequency: nil,
                colour: nil,
                activation: nil,
                affirmation: "I welcome change.",
                type: .blessing
            ),

            OracleCard(
                title: "I Am Whole",
                message: "I am whole and complete as I am. — Louise Hay",
                frequency: nil,
                colour: nil,
                activation: nil,
                affirmation: "I am whole.",
                type: .blessing
            ),

            OracleCard(
                title: "I Deserve Love",
                message: "I deserve love, joy, and abundance. — Louise Hay",
                frequency: nil,
                colour: nil,
                activation: nil,
                affirmation: "I deserve love.",
                type: .blessing
            ),
            
                ]
            }
    func cards(of type: CardType) -> [OracleCard] {
        deck.filter { $0.type == type }
    }
            
            // 🎴 DRAW SPECIFIC NUMBER
    func draw(count: Int) {
        
        let safeCount = min(count, deck.count)
        
        let shuffled = deck.shuffled()
        drawnCards = Array(shuffled.prefix(safeCount))
    }
            
            // 🎲 RANDOM DRAW
            func drawRandom() {
                let count = Int.random(in: 1...5)
                draw(count: count)
            }
            
            // 🔁 RESET
            func reset() {
                drawnCards = []
            }
    }

