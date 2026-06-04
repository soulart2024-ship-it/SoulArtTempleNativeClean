//
//  KinesiologyMiniCourse.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 24/04/2026.
//

import SwiftUI

// MARK: - Colour Palette

private extension Color {
    static let sage       = Color(red: 0.659, green: 0.710, blue: 0.627)
    static let sagePale   = Color(red: 0.933, green: 0.945, blue: 0.929)
    static let sageMid    = Color(red: 0.831, green: 0.867, blue: 0.820)
    static let clay       = Color(red: 0.769, green: 0.659, blue: 0.510)
    static let clayPale   = Color(red: 0.961, green: 0.937, blue: 0.902)
    static let blushLight = Color(red: 0.941, green: 0.894, blue: 0.878)
    static let warmWhite  = Color(red: 0.980, green: 0.973, blue: 0.961)
    static let stone      = Color(red: 0.478, green: 0.447, blue: 0.408)
    static let stoneDark  = Color(red: 0.239, green: 0.220, blue: 0.188)
}

// MARK: - Data Models

struct KLesson: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let steps: [KStep]
}

enum KStep {
    case info(InfoStep)
    case stepsList(StepsListStep)
    case testMethods(TestMethodsStep)
    case yesNoCalibration(YesNoStep)
    case realWorldPractice(RealWorldStep)
    case quiz(QuizStep)
    case checklist(ChecklistStep)
}

struct InfoStep {
    let label: String
    let heading: String
    let body: String
    let tip: TipContent?
    let visualType: VisualType?

    enum VisualType { case fingerRub, pendulum, bodyCheck }
    init(label: String, heading: String, body: String, tip: TipContent? = nil, visualType: VisualType? = nil) {
        self.label = label; self.heading = heading; self.body = body
        self.tip = tip; self.visualType = visualType
    }
}

struct TipContent {
    let label: String
    let text: String
}

struct StepsListStep {
    let label: String
    let heading: String
    let intro: String?
    let steps: [(number: String, text: String)]
    let tip: TipContent?
    init(label: String, heading: String, intro: String? = nil,
         steps: [(String, String)], tip: TipContent? = nil) {
        self.label = label; self.heading = heading; self.intro = intro
        self.steps = steps; self.tip = tip
    }
}

struct TestMethodsStep {
    let label: String
    let heading: String
    let methods: [TestMethod]
}

struct TestMethod: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let tagline: String
    let howTo: [String]
    let feeling: String
    let bestFor: String
}

struct YesNoStep {
    let label: String
    let heading: String
    let body: String
}

struct RealWorldStep {
    let label: String
    let heading: String
    let scenario: String
    let steps: [(String, String)]
}

struct QuizStep {
    let label: String
    let heading: String
    let question: String
    let options: [QuizOption]
    let correctFeedback: String
    let incorrectFeedback: String
}

struct QuizOption: Identifiable {
    let id = UUID()
    let text: String
    let isCorrect: Bool
}

struct ChecklistStep {
    let label: String
    let heading: String
    let intro: String?
    let items: [String]
}

// MARK: - Course Content

let kinesiologyCourse: [KLesson] = [

    KLesson(
        icon: "🌿",
        title: "What is Self-Testing?",
        subtitle: "How your body already knows",
        steps: [
            .info(InfoStep(
                label: "Introduction",
                heading: "Your Body Never Lies",
                body: "Muscle testing for self-use — sometimes called **self-kinesiology** or **ideomotor testing** — is the practice of using subtle physical responses in your own body to access deeper intelligence.\n\nUnlike practitioner-based testing, **self-testing requires no equipment and no partner.** It works by training yourself to notice tiny changes in muscle resistance or ease in response to a question or stimulus.",
                tip: TipContent(label: "Key Insight", text: "This isn't magic — it's your nervous system. Your body responds to stimuli before your conscious mind catches up.")
            )),
            .info(InfoStep(
                label: "The Science",
                heading: "Why the Body Responds",
                body: "When you hold an intention, question, or physical object, your nervous system is already processing it. Research into **ideomotor responses** shows that muscles can reflect subconscious knowledge through micro-movements and changes in tone.\n\nSelf-testing taps into this. You are not guessing — you are listening to a signal that is already there. The skill is in learning to **quieten the mental noise** so the signal becomes clear.",
                tip: TipContent(label: "Practice Truth", text: "The biggest obstacle to self-testing isn't the method — it's the thinking mind interrupting the signal. Stillness and practice solve this.")
            ))
        ]
    ),

    KLesson(
        icon: "✋",
        title: "Finding Your Yes & No",
        subtitle: "Calibrate before you test",
        steps: [
            .yesNoCalibration(YesNoStep(
                label: "Calibration",
                heading: "Your Yes & No Are Unique",
                body: "Before you can trust any self-test, you must establish what **yes** and **no** feel like **in your body, with your method.** These signals are personal — they are not the same for everyone.\n\nThe most important rule: **always calibrate first.** Start every session by confirming your yes and no with something you know to be true."
            )),
            .stepsList(StepsListStep(
                label: "Calibration Protocol",
                heading: "How to Find Your Yes & No",
                intro: "Use the finger-rub method or any method in the next module. Follow these steps each time you begin:",
                steps: [
                    ("1", "**Ground yourself first.** Sit or stand quietly. Take three slow breaths. Let your shoulders drop."),
                    ("2", "**State your name aloud or in your mind.** Say: 'My name is [your actual name].' Notice the quality of the response — ease, flow, no resistance. This is your **YES**."),
                    ("3", "**State a false name.** Say: 'My name is [a name that isn't yours].' Notice what changes — a catch, a drag, a slight stickiness or resistance. This is your **NO**."),
                    ("4", "**Repeat 2–3 times** until the difference is clear and consistent. Don't force it — just observe."),
                    ("5", "**Make a mental note** of exactly how your yes and no feel. Some people feel ease vs drag. Others feel warm vs cool. Others feel smooth vs sticky. Trust what you notice.")
                ],
                tip: TipContent(label: "Your Personal Signal", text: "With the finger-rub method: ease and smooth circular motion = YES. Resistance, stickiness, or the fingers wanting to stop = NO.")
            ))
        ]
    ),

    KLesson(
        icon: "👌",
        title: "Self-Testing Methods",
        subtitle: "Three techniques to try",
        steps: [
            .testMethods(TestMethodsStep(
                label: "The Methods",
                heading: "Choose Your Technique",
                methods: [
                    TestMethod(
                        icon: "👆",
                        name: "Finger Rub Method",
                        tagline: "Your personal method — ease vs resistance",
                        howTo: [
                            "Bring your forefinger and thumb together",
                            "Begin rubbing them in gentle circles",
                            "Hold your question or intention in mind",
                            "Notice: does the motion feel easy and smooth? Or does it catch, drag, or want to stop?"
                        ],
                        feeling: "YES = smooth, effortless circular motion. NO = friction, drag, stickiness, or the urge to stop.",
                        bestFor: "Discreet testing in public — supermarkets, shops, anywhere. Invisible and quick."
                    ),
                    TestMethod(
                        icon: "🫰",
                        name: "Two-Finger Pull Test",
                        tagline: "Link and pull — strong vs weak",
                        howTo: [
                            "Make an O-shape with your non-dominant thumb and middle finger (a loop)",
                            "Hook your dominant forefinger through the loop",
                            "Hold your question in mind",
                            "Try to pull the loop apart with your forefinger",
                            "Notice: does the loop hold firm, or does it easily break open?"
                        ],
                        feeling: "YES = the loop holds strong and resists pulling apart. NO = the loop weakens and your finger pulls through easily.",
                        bestFor: "Clear, physical responses. Great for practice at home when learning your signals."
                    ),
                    TestMethod(
                        icon: "🔮",
                        name: "Sway / Body Pendulum",
                        tagline: "Let your whole body answer",
                        howTo: [
                            "Stand with feet hip-width apart, knees soft, eyes closed",
                            "Relax your whole body — arms loose, jaw unclenched",
                            "Hold your question or object to your chest",
                            "Simply notice: does your body gently lean forward, or drift backward?"
                        ],
                        feeling: "YES = a gentle, involuntary forward lean or sense of openness. NO = a subtle backward sway or sense of closing.",
                        bestFor: "Big-picture questions, decisions, or when you want a whole-body confirmation. More obvious for beginners."
                    )
                ]
            )),
            .info(InfoStep(
                label: "Choosing Your Method",
                heading: "One Method at a Time",
                body: "Try all three methods, but **focus on mastering one first** before combining them. Most people have a method that clicks naturally for them.\n\nThe finger-rub method is ideal for public use. The two-finger pull gives strong physical feedback for beginners. The body sway works beautifully for decisions and emotions.\n\nOnce you trust one method, a second becomes easy to learn.",
                tip: TipContent(label: "Golden Rule", text: "Never test when you are emotionally invested in a particular answer. If you 'want' a yes, your conscious mind can override the signal. Step back, breathe, and test neutrally."),
                visualType: .fingerRub
            ))
        ]
    ),

    KLesson(
        icon: "🛒",
        title: "Real-World Testing",
        subtitle: "In the supermarket & beyond",
        steps: [
            .realWorldPractice(RealWorldStep(
                label: "Practical Session",
                heading: "Testing Food in a Supermarket",
                scenario: "This is one of the most practical and immediate uses of self-kinesiology. You're standing in the aisle. You pick up a product. Is it good for you right now? Your body already knows.",
                steps: [
                    ("🧘", "**Ground yourself first.** Take one slow breath. Let your feet feel the floor. You need 10 seconds of stillness before a reliable test."),
                    ("✅", "**Calibrate your yes.** Quickly run through your name test mentally. Confirm your yes feels clear. This only takes a moment once you've practised."),
                    ("🛒", "**Pick up the item** in your non-dominant hand, or simply place your hand on it if it's on the shelf. You don't need to hold it — proximity and intention are enough."),
                    ("🤔", "**Hold a clear, neutral question** in mind: 'Is this food beneficial for my body right now?' Keep it simple. The more neutral and specific the question, the cleaner the answer."),
                    ("👆", "**Run your test method.** For the finger-rub: begin the circular motion and observe. For the two-finger pull: feel the strength or weakness. For the sway: feel the forward or backward drift."),
                    ("📝", "**Note the response without analysis.** Don't immediately think 'but I love this biscuit.' Just notice: ease or resistance. Yes or no. Then act on it or explore further."),
                    ("🔄", "**Test again if unclear.** A single unclear result is fine — simply reset (breathe, reground) and test once more. If two tests give different answers, you may need more stillness or a clearer question.")
                ]
            )),
            .info(InfoStep(
                label: "Going Deeper",
                heading: "Beyond Food — What Else Can You Test?",
                body: "Once you trust your signals with food, the same process applies to:\n\n**Supplements & remedies** — Hold the bottle and test before buying or taking.\n\n**Decisions** — 'Is it in my highest good to attend this event?' Use the sway or finger-rub.\n\n**Physical locations** — Some people test whether a seat, room, or environment feels beneficial.\n\n**Timing** — 'Is now a good time to make this call?' Your nervous system is sensitive to timing in ways the mind often misses.\n\n**Always remember:** self-testing is a tool for guidance, not a replacement for medical advice or careful reasoning.",
                tip: TipContent(label: "Supermarket Tip", text: "The finger-rub is perfect here — it looks completely natural. No one around you will notice you testing the pasta sauce while they're choosing theirs.")
            ))
        ]
    ),

    KLesson(
        icon: "🌱",
        title: "Accuracy & Practice",
        subtitle: "Building a reliable signal",
        steps: [
            .quiz(QuizStep(
                label: "Check Your Understanding",
                heading: "Which is most important before any self-test?",
                question: "Before testing anything, what is the essential first step?",
                options: [
                    QuizOption(text: "Hold the object with both hands for at least 30 seconds", isCorrect: false),
                    QuizOption(text: "Ground yourself and confirm your yes & no with something you know", isCorrect: true),
                    QuizOption(text: "Close your eyes and think about what you want the answer to be", isCorrect: false),
                    QuizOption(text: "Test with the dominant hand for the strongest signal", isCorrect: false)
                ],
                correctFeedback: "✓ Exactly right. Calibrating your yes and no with known truths anchors your nervous system before any real test. Without this, results are unreliable.",
                incorrectFeedback: "Not quite. The most important step is always calibration — confirming your yes and no signals are clear using something you already know to be true."
            )),
            .checklist(ChecklistStep(
                label: "Building Accuracy",
                heading: "Daily Practice Habits",
                intro: "Reliable self-testing comes from consistent, calm practice. Tick these habits as you build them:",
                items: [
                    "I calibrate my yes and no at the start of every session",
                    "I test in a calm, grounded state — not when stressed or rushed",
                    "I keep my questions simple, clear and neutral",
                    "I don't test when I have a strong emotional preference for one answer",
                    "I practice on things I can verify (food I know my body likes/dislikes)",
                    "I use the finger-rub method in public — it's discreet and quick",
                    "I reset with a breath when a result feels unclear",
                    "I treat self-testing as one input — not the only input — in decisions"
                ]
            )),
            .info(InfoStep(
                label: "Final Note",
                heading: "Trust Builds Over Time",
                body: "When you first begin, you may doubt your signals. This is completely normal. The thinking mind is not used to yielding to body intelligence — it wants to analyse, second-guess, and override.\n\nThe solution is **gentle repetition.** Test things you can verify. Notice when you were right. Notice when doubt was the interference.\n\nOver weeks of practice, something shifts. The signal becomes quieter but clearer. You begin to trust it not because you believe in it — but because it has been **consistently accurate.**",
                tip: TipContent(label: "A Closing Thought", text: "The body has been answering your questions your whole life. Self-testing is simply learning to hear what it's already been saying.")
            ))
        ]
    )
]

// MARK: - Main Entry View

public struct KinesiologyMiniCourse: View {
    let startAtModule: Int?
    
    public init(startAtModule: Int? = nil) {
        self.startAtModule = startAtModule
    }
    
    public var body: some View {
        CourseRootView(startAtModule: startAtModule)
    }
}

// Must be defined BEFORE CourseRootView
enum CourseNavItem: Hashable {
    case moduleList
    case lesson(Int)
    case complete(Int)
}

private struct CourseRootView: View {

    let startAtModule: Int?
    @State private var path: [CourseNavItem] = []

    var body: some View {
        NavigationStack(path: $path) {
            if let moduleIndex = startAtModule {
                // Deep-link: Skip welcome, go straight to module list
                ModuleListView(path: $path)
                    .navigationDestination(for: CourseNavItem.self) { item in
                        switch item {
                        case .moduleList:
                            ModuleListView(path: $path)
                        case .lesson(let index):
                            LessonView(lessonIndex: index, path: $path)
                        case .complete(let index):
                            CompletionView(lessonIndex: index, path: $path)
                        }
                    }
                    .onAppear {
                        // Navigate to the specific module
                        path = [.lesson(moduleIndex)]
                    }
            } else {
                // Normal flow: Show welcome screen
                WelcomeView(path: $path, startAtModule: nil)
                    .navigationDestination(for: CourseNavItem.self) { item in
                        switch item {
                        case .moduleList:
                            ModuleListView(path: $path)
                        case .lesson(let index):
                            LessonView(lessonIndex: index, path: $path)
                        case .complete(let index):
                            CompletionView(lessonIndex: index, path: $path)
                        }
                    }
            }
        }
        .navigationBarHidden(true)
    }
}
// MARK: - Welcome View

struct WelcomeView: View {
    @Binding var path: [CourseNavItem]
    let startAtModule: Int?
    @State private var appeared = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.sagePale, Color.clayPale, Color.blushLight],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                Text("🌿")
                    .font(.system(size: 56))
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.7)
                    .animation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.1), value: appeared)
                
                VStack(spacing: 8) {
                    Text("Self-Testing")
                        .font(.custom("Georgia", size: 13))
                        .foregroundColor(.stone)
                        .tracking(3)
                        .textCase(.uppercase)
                        .opacity(appeared ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.3), value: appeared)
                    
                    Text("Kinesiology &\nMuscle Testing")
                        .font(.custom("Georgia-Italic", size: 36))
                        .foregroundColor(.stoneDark)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 10)
                        .animation(.easeOut(duration: 0.6).delay(0.4), value: appeared)
                }
                .padding(.top, 20)
                
                Text("A complete beginner's guide to testing\nfor yourself — no practitioner needed.")
                    .font(.custom("Georgia", size: 15))
                    .foregroundColor(.stone)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.top, 20)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.6), value: appeared)
                
                VStack(spacing: 8) {
                    ForEach([
                        ("🌿", "What is Self-Testing?"),
                        ("✋", "Finding Your Yes & No"),
                        ("👌", "Three Testing Methods"),
                        ("🛒", "Real-World Practice"),
                        ("🌱", "Building Accuracy")
                    ], id: \.1) { chip in
                        HStack(spacing: 10) {
                            Text(chip.0).font(.system(size: 14))
                            Text(chip.1)
                                .font(.custom("Georgia", size: 13))
                                .foregroundColor(.stone)
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.65))
                        .clipShape(Capsule())
                    }
                }
                .padding(.top, 28)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.8), value: appeared)
                
                Spacer()
                
                Button {
                    path.append(.moduleList)
                } label: {
                    Text("Begin Your Journey")
                        .font(.custom("Georgia", size: 15))
                        .tracking(1)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(Color.sage)
                        .clipShape(Capsule())
                        .shadow(color: Color.sage.opacity(0.4), radius: 12, y: 4)
                }
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(1.0), value: appeared)
                
                Spacer().frame(height: 48)
            }
            .padding(.horizontal, 24)
        }
        .navigationBarHidden(true)
                .overlay(alignment: .topLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.stone)
                            .padding(12)
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 20)
                    .padding(.top, 16)
                }
                .onAppear {
                    appeared = true
                }
            }
        }
// MARK: - Module List View

struct ModuleListView: View {
    @Binding var path: [CourseNavItem]
    @AppStorage("kinCompletedModules") private var completedRaw: String = ""
    @Environment(\.dismiss) var dismiss

    var completedIndices: Set<Int> {
        Set(completedRaw.split(separator: ",").compactMap { Int($0) })
    }

    var body: some View {
        ZStack {
            Color.warmWhite.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(Array(kinesiologyCourse.enumerated()), id: \.offset) { index, lesson in
                        ModuleCard(
                            lesson: lesson,
                            index: index,
                            isCompleted: completedIndices.contains(index)
                        ) {
                            path.append(.lesson(index))
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Choose a Module")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.stone)
                        }
                    }
                }
            }
        }

struct ModuleCard: View {
    let lesson: KLesson
    let index: Int
    let isCompleted: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isCompleted ? Color.sagePale : Color.clayPale)
                        .frame(width: 52, height: 52)
                    Text(lesson.icon)
                        .font(.system(size: 24))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(lesson.title)
                        .font(.custom("Georgia", size: 16))
                        .foregroundColor(.stoneDark)
                    Text(lesson.subtitle)
                        .font(.custom("Georgia", size: 12))
                        .foregroundColor(.stone)
                }

                Spacer()

                Text(isCompleted ? "✓ Done" : "Start")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(isCompleted ? Color(red: 0.29, green: 0.42, blue: 0.27) : .clay)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(isCompleted ? Color(red: 0.88, green: 0.94, blue: 0.86) : Color.clayPale)
                    .clipShape(Capsule())
            }
            .padding(18)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(isCompleted ? Color.sage.opacity(0.4) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Lesson View

struct LessonView: View {
    let lessonIndex: Int
    @Binding var path: [CourseNavItem]
    @State private var currentStep = 0
    @AppStorage("kinCompletedModules") private var completedRaw: String = ""

    var lesson: KLesson { kinesiologyCourse[lessonIndex] }
    var totalSteps: Int { lesson.steps.count }
    var progress: Double { Double(currentStep + 1) / Double(totalSteps) }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.warmWhite.ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar
                ProgressBar(progress: progress,
                            current: currentStep + 1,
                            total: totalSteps)

                ScrollView {
                    StepContentView(step: lesson.steps[currentStep])
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                        .id(currentStep) // forces re-render / scroll reset
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                }
            }

            // Navigation bar
            NavBar(
                canGoBack: currentStep > 0,
                isLast: currentStep == totalSteps - 1,
                onBack: { withAnimation { currentStep -= 1 } },
                onNext: {
                    if currentStep < totalSteps - 1 {
                        withAnimation { currentStep += 1 }
                    } else {
                        markComplete()
                        path.append(.complete(lessonIndex))
                    }
                }
            )
        }
        .navigationTitle(lesson.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    func markComplete() {
        var indices = Set(completedRaw.split(separator: ",").compactMap { Int($0) })
        indices.insert(lessonIndex)
        completedRaw = indices.map { String($0) }.joined(separator: ",")
    }
}

// MARK: - Progress Bar

struct ProgressBar: View {
    let progress: Double
    let current: Int
    let total: Int

    var body: some View {
        VStack(spacing: 4) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.sageMid.opacity(0.4))
                        .frame(height: 4)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(colors: [Color.sage, Color.clay],
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: geo.size.width * progress, height: 4)
                        .animation(.easeInOut(duration: 0.4), value: progress)
                }
            }
            .frame(height: 4)
            .padding(.horizontal, 20)

            Text("\(current) of \(total)")
                .font(.system(size: 11))
                .foregroundColor(.stone)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 20)
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(Color.white)
    }
}

// MARK: - Nav Bar

struct NavBar: View {
    let canGoBack: Bool
    let isLast: Bool
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        HStack {
            if canGoBack {
                Button(action: onBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.stone)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
                }
            }

            Spacer()

            Button(action: onNext) {
                HStack(spacing: 6) {
                    Text(isLast ? "Complete Module" : "Continue")
                    Image(systemName: isLast ? "checkmark" : "chevron.right")
                }
                .font(.system(size: 14, weight: .medium))
                .tracking(0.3)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(Color.sage)
                .clipShape(Capsule())
                .shadow(color: Color.sage.opacity(0.35), radius: 10, y: 3)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .padding(.top, 12)
        .background(
            Color.warmWhite
                .shadow(color: .black.opacity(0.05), radius: 8, y: -2)
                .ignoresSafeArea()
        )
    }
}

// MARK: - Step Content Router

struct StepContentView: View {
    let step: KStep

    var body: some View {
        Group {
            switch step {
            case .info(let s):            InfoStepView(step: s)
            case .stepsList(let s):       StepsListView(step: s)
            case .testMethods(let s):     TestMethodsView(step: s)
            case .yesNoCalibration(let s):YesNoView(step: s)
            case .realWorldPractice(let s):RealWorldView(step: s)
            case .quiz(let s):            QuizView(step: s)
            case .checklist(let s):       ChecklistView(step: s)
            }
        }
    }
}

// MARK: - Info Step View

struct InfoStepView: View {
    let step: InfoStep

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepLabel(text: step.label)
            Text(step.heading)
                .font(.custom("Georgia-Italic", size: 26))
                .foregroundColor(.stoneDark)
                .lineSpacing(3)

            if let vt = step.visualType {
                VisualDiagramView(type: vt)
            }

            MarkdownText(step.body)
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 8, y: 2)

            if let tip = step.tip {
                TipBoxView(tip: tip)
            }
        }
        .padding(.top, 16)
    }
}

// MARK: - Visual Diagrams

struct VisualDiagramView: View {
    let type: InfoStep.VisualType

    var body: some View {
        Group {
            switch type {
            case .fingerRub:   FingerRubDiagram()
            case .pendulum:    PendulumDiagram()
            case .bodyCheck:   BodyCheckDiagram()
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.sagePale)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct FingerRubDiagram: View {
    @State private var rotating = false

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(Color.sage.opacity(0.25), lineWidth: 1.5)
                    .frame(width: 80, height: 80)

                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(Color.sage, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(rotating ? 360 : 0))
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotating)

                Text("👆")
                    .font(.system(size: 32))
            }
            .padding(.top, 20)

            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("YES")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color(red: 0.29, green: 0.42, blue: 0.27))
                    Text("Smooth & easy")
                        .font(.system(size: 11))
                        .foregroundColor(.stone)
                }
                Rectangle().fill(Color.sageMid).frame(width: 1, height: 30)
                VStack(spacing: 4) {
                    Text("NO")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color(red: 0.7, green: 0.35, blue: 0.3))
                    Text("Catches & drags")
                        .font(.system(size: 11))
                        .foregroundColor(.stone)
                }
            }
            .padding(.bottom, 20)
        }
        .onAppear { rotating = true }
    }
}

struct PendulumDiagram: View {
    @State private var swaying = false

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Person silhouette
                VStack(spacing: 0) {
                    Circle()
                        .fill(Color.sage.opacity(0.5))
                        .frame(width: 28, height: 28)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.sage.opacity(0.4))
                        .frame(width: 24, height: 40)
                }
                .offset(x: swaying ? -6 : 6)
                .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: swaying)

                // Labels
                HStack(spacing: 60) {
                    Text("← YES\nForward")
                        .font(.system(size: 9))
                        .foregroundColor(Color(red: 0.29, green: 0.42, blue: 0.27))
                        .multilineTextAlignment(.center)
                    Text("NO →\nBackward")
                        .font(.system(size: 9))
                        .foregroundColor(Color(red: 0.7, green: 0.35, blue: 0.3))
                        .multilineTextAlignment(.center)
                }
                .offset(y: 40)
            }
            .frame(height: 120)
        }
        .onAppear { swaying = true }
    }
}

struct BodyCheckDiagram: View {
    var body: some View {
        VStack {
            Text("🔍")
                .font(.system(size: 40))
                .padding()
        }
    }
}

// MARK: - Steps List View

struct StepsListView: View {
    let step: StepsListStep

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepLabel(text: step.label)
            Text(step.heading)
                .font(.custom("Georgia-Italic", size: 26))
                .foregroundColor(.stoneDark)

            if let intro = step.intro {
                Text(intro)
                    .font(.custom("Georgia", size: 15))
                    .foregroundColor(.stone)
                    .lineSpacing(4)
            }

            VStack(spacing: 0) {
                ForEach(Array(step.steps.enumerated()), id: \.offset) { idx, item in
                    HStack(alignment: .top, spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color.sage)
                                .frame(width: 28, height: 28)
                            Text(item.number)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 14)

                        MarkdownText(item.text)
                            .padding(.vertical, 14)
                        Spacer()
                    }
                    .padding(.horizontal, 16)

                    if idx < step.steps.count - 1 {
                        Divider().padding(.leading, 58)
                    }
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)

            if let tip = step.tip {
                TipBoxView(tip: tip)
            }
        }
        .padding(.top, 16)
    }
}

// MARK: - Test Methods View

struct TestMethodsView: View {
    let step: TestMethodsStep
    @State private var selected: UUID? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepLabel(text: step.label)
            Text(step.heading)
                .font(.custom("Georgia-Italic", size: 26))
                .foregroundColor(.stoneDark)

            VStack(spacing: 12) {
                ForEach(step.methods) { method in
                    MethodCard(method: method, isExpanded: selected == method.id) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            selected = selected == method.id ? nil : method.id
                        }
                    }
                }
            }
        }
        .padding(.top, 16)
    }
}

struct MethodCard: View {
    let method: TestMethod
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Button(action: onTap) {
                HStack(spacing: 14) {
                    Text(method.icon)
                        .font(.system(size: 28))
                        .frame(width: 44, height: 44)
                        .background(Color.sagePale)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(method.name)
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(.stoneDark)
                        Text(method.tagline)
                            .font(.system(size: 12))
                            .foregroundColor(.stone)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(.stone)
                }
                .padding(16)
            }
            .buttonStyle(.plain)

            if isExpanded {
                Divider().padding(.horizontal, 16)

                VStack(alignment: .leading, spacing: 14) {
                    // How to
                    Text("How to do it")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.sage)
                        .tracking(1)
                        .textCase(.uppercase)

                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(method.howTo.enumerated()), id: \.offset) { i, step in
                            HStack(alignment: .top, spacing: 10) {
                                Text("\(i + 1)")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                    .background(Color.clay.opacity(0.7))
                                    .clipShape(Circle())
                                Text(step)
                                    .font(.custom("Georgia", size: 14))
                                    .foregroundColor(.stone)
                                    .lineSpacing(3)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }

                    // Feeling
                    VStack(alignment: .leading, spacing: 6) {
                        Text("What you'll feel")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.clay)
                            .tracking(1)
                            .textCase(.uppercase)
                        Text(method.feeling)
                            .font(.custom("Georgia", size: 14))
                            .foregroundColor(.stone)
                            .lineSpacing(3)
                            .padding(12)
                            .background(Color.clayPale)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    // Best for
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.clay)
                        Text("Best for: \(method.bestFor)")
                            .font(.system(size: 12))
                            .foregroundColor(.stone)
                            .italic()
                    }
                }
                .padding(16)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(isExpanded ? Color.sage.opacity(0.4) : Color.clear, lineWidth: 1.5)
        )
    }
}

// MARK: - Yes/No Calibration View

struct YesNoView: View {
    let step: YesNoStep
    @State private var stage: CalibrationStage = .idle

    enum CalibrationStage { case idle, yes, no, done }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepLabel(text: step.label)
            Text(step.heading)
                .font(.custom("Georgia-Italic", size: 26))
                .foregroundColor(.stoneDark)

            Text(step.body)
                .font(.custom("Georgia", size: 15))
                .foregroundColor(.stone)
                .lineSpacing(5)
                .padding(20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 8, y: 2)

            // Interactive calibrator
            VStack(spacing: 16) {
                Text("Try It Now")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.sage)
                    .tracking(1.5)
                    .textCase(.uppercase)

                Text("Tap each to practise feeling the signal")
                    .font(.custom("Georgia", size: 13))
                    .foregroundColor(.stone)

                HStack(spacing: 16) {
                    CalibrationButton(
                        label: "YES",
                        subtitle: "My name is [your name]",
                        colour: Color.sage,
                        isActive: stage == .yes
                    ) { stage = stage == .yes ? .idle : .yes }

                    CalibrationButton(
                        label: "NO",
                        subtitle: "My name is [wrong name]",
                        colour: Color(red: 0.7, green: 0.45, blue: 0.42),
                        isActive: stage == .no
                    ) { stage = stage == .no ? .idle : .no }
                }

                if stage == .yes {
                    ResponseBubble(
                        text: "Hold 'My name is [your real name]' in mind.\nWith the finger-rub: notice smooth, easy circular motion.\nWith the two-finger pull: feel the loop hold firm.\nWith the sway: feel a gentle forward drift.\n\nThis is your YES. Memorise this feeling. 🌿",
                        colour: .sage
                    )
                } else if stage == .no {
                    ResponseBubble(
                        text: "Hold 'My name is [a name that isn't yours]' in mind.\nWith the finger-rub: notice friction, drag or wanting to stop.\nWith the two-finger pull: feel the loop weaken.\nWith the sway: feel a subtle backward pull.\n\nThis is your NO. Notice how it differs. 🛑",
                        colour: Color(red: 0.7, green: 0.45, blue: 0.42)
                    )
                }
            }
            .padding(20)
            .background(Color.sagePale)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.top, 16)
    }
}

struct CalibrationButton: View {
    let label: String
    let subtitle: String
    let colour: Color
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(label)
                    .font(.custom("Georgia", size: 22))
                    .foregroundColor(isActive ? .white : colour)
                Text(subtitle)
                    .font(.system(size: 10))
                    .foregroundColor(isActive ? .white.opacity(0.85) : .stone)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(isActive ? colour : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: colour.opacity(isActive ? 0.35 : 0.1), radius: 8, y: 3)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}

struct ResponseBubble: View {
    let text: String
    let colour: Color

    var body: some View {
        Text(text)
            .font(.custom("Georgia", size: 13))
            .foregroundColor(.stoneDark)
            .lineSpacing(4)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(colour.opacity(0.1))
            .overlay(
                Rectangle()
                    .fill(colour)
                    .frame(width: 3)
                    .clipShape(RoundedRectangle(cornerRadius: 2)),
                alignment: .leading
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .transition(.opacity.combined(with: .scale(scale: 0.97)))
    }
}

// MARK: - Real World Practice View

struct RealWorldView: View {
    let step: RealWorldStep
    @State private var checkedSteps = Set<Int>()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepLabel(text: step.label)
            Text(step.heading)
                .font(.custom("Georgia-Italic", size: 26))
                .foregroundColor(.stoneDark)

            Text(step.scenario)
                .font(.custom("Georgia", size: 15))
                .foregroundColor(.stone)
                .lineSpacing(5)
                .padding(20)
                .background(Color.blushLight)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Text("Follow each step — tap to mark it done:")
                .font(.system(size: 12))
                .foregroundColor(.stone)

            VStack(spacing: 0) {
                ForEach(Array(step.steps.enumerated()), id: \.offset) { idx, item in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if checkedSteps.contains(idx) {
                                checkedSteps.remove(idx)
                            } else {
                                checkedSteps.insert(idx)
                            }
                        }
                    } label: {
                        HStack(alignment: .top, spacing: 14) {
                            Text(item.0)
                                .font(.system(size: 18))
                                .frame(width: 32)
                                .padding(.top, 14)

                            MarkdownText(item.1)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(checkedSteps.contains(idx) ? Color.sage : Color.sagePale)
                                    .frame(width: 24, height: 24)
                                if checkedSteps.contains(idx) {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.top, 14)
                        }
                        .padding(.horizontal, 16)
                        .background(checkedSteps.contains(idx) ? Color.sagePale.opacity(0.5) : Color.white)
                    }
                    .buttonStyle(.plain)

                    if idx < step.steps.count - 1 {
                        Divider().padding(.leading, 64)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)

            if checkedSteps.count == step.steps.count {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.sage)
                    Text("Superb — you've completed the full protocol.")
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(.stoneDark)
                }
                .padding(16)
                .background(Color.sagePale)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .transition(.opacity.combined(with: .scale(scale: 0.97)))
            }
        }
        .padding(.top, 16)
    }
}

// MARK: - Quiz View

struct QuizView: View {
    let step: QuizStep
    @State private var selectedID: UUID? = nil
    @State private var answered = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepLabel(text: step.label)
            Text(step.heading)
                .font(.custom("Georgia-Italic", size: 26))
                .foregroundColor(.stoneDark)

            Text(step.question)
                .font(.custom("Georgia", size: 16))
                .foregroundColor(.stoneDark)
                .lineSpacing(4)
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.04), radius: 8, y: 2)

            VStack(spacing: 10) {
                ForEach(step.options) { option in
                    Button {
                        guard !answered else { return }
                        withAnimation {
                            selectedID = option.id
                            answered = true
                        }
                    } label: {
                        HStack {
                            Text(option.text)
                                .font(.custom("Georgia", size: 15))
                                .foregroundColor(labelColour(for: option))
                                .lineSpacing(3)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if answered && option.isCorrect {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color.sage)
                            } else if answered && selectedID == option.id && !option.isCorrect {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color(red: 0.75, green: 0.35, blue: 0.3))
                            }
                        }
                        .padding(16)
                        .background(bgColour(for: option))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(borderColour(for: option), lineWidth: 1.5)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(answered)
                }
            }

            if answered {
                let isCorrect = selectedID.flatMap { id in step.options.first(where: { $0.id == id }) }?.isCorrect ?? false
                ResponseBubble(
                    text: isCorrect ? step.correctFeedback : step.incorrectFeedback,
                    colour: isCorrect ? .sage : Color(red: 0.7, green: 0.45, blue: 0.42)
                )
                .transition(.opacity)
            }
        }
        .padding(.top, 16)
    }

    func bgColour(for option: QuizOption) -> Color {
        guard answered else { return .white }
        if option.isCorrect { return Color.sagePale }
        if selectedID == option.id { return Color.blushLight }
        return .white
    }

    func borderColour(for option: QuizOption) -> Color {
        guard answered else { return Color.sageMid.opacity(0.4) }
        if option.isCorrect { return Color.sage }
        if selectedID == option.id { return Color(red: 0.75, green: 0.35, blue: 0.3) }
        return Color.sageMid.opacity(0.2)
    }

    func labelColour(for option: QuizOption) -> Color {
        guard answered else { return .stoneDark }
        if option.isCorrect { return Color(red: 0.25, green: 0.4, blue: 0.23) }
        if selectedID == option.id { return Color(red: 0.6, green: 0.25, blue: 0.22) }
        return .stone
    }
}

// MARK: - Checklist View

struct ChecklistView: View {
    let step: ChecklistStep
    @State private var checked = Set<Int>()

    var allDone: Bool { checked.count == step.items.count }
    var progress: Double { Double(checked.count) / Double(step.items.count) }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepLabel(text: step.label)
            Text(step.heading)
                .font(.custom("Georgia-Italic", size: 26))
                .foregroundColor(.stoneDark)

            if let intro = step.intro {
                Text(intro)
                    .font(.custom("Georgia", size: 15))
                    .foregroundColor(.stone)
                    .lineSpacing(4)
            }

            // Mini progress
            HStack {
                Text("\(checked.count) of \(step.items.count) habits building")
                    .font(.system(size: 12))
                    .foregroundColor(.stone)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.sage)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3).fill(Color.sageMid.opacity(0.3)).frame(height: 4)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(LinearGradient(colors: [.sage, .clay], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geo.size.width * progress, height: 4)
                        .animation(.easeInOut(duration: 0.35), value: progress)
                }
            }
            .frame(height: 4)

            VStack(spacing: 0) {
                ForEach(Array(step.items.enumerated()), id: \.offset) { idx, item in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if checked.contains(idx) { checked.remove(idx) }
                            else { checked.insert(idx) }
                        }
                    } label: {
                        HStack(alignment: .top, spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(checked.contains(idx) ? Color.sage : Color.sagePale)
                                    .frame(width: 26, height: 26)
                                if checked.contains(idx) {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.top, 12)

                            Text(item)
                                .font(.custom("Georgia", size: 14))
                                .foregroundColor(checked.contains(idx) ? .stoneDark : .stone)
                                .lineSpacing(3)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 16)
                        .background(checked.contains(idx) ? Color.sagePale.opacity(0.4) : Color.white)
                    }
                    .buttonStyle(.plain)

                    if idx < step.items.count - 1 {
                        Divider().padding(.leading, 56)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)

            if allDone {
                HStack(spacing: 10) {
                    Text("🌿")
                    Text("Wonderful — all habits noted. These become your foundation.")
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(.stoneDark)
                }
                .padding(16)
                .background(Color.sagePale)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .transition(.opacity.combined(with: .scale(scale: 0.97)))
            }
        }
        .padding(.top, 16)
    }
}

// MARK: - Completion View

struct CompletionView: View {
    let lessonIndex: Int
    @Binding var path: [CourseNavItem]
    @State private var appeared = false

    var lesson: KLesson { kinesiologyCourse[lessonIndex] }
    var isLastLesson: Bool { lessonIndex == kinesiologyCourse.count - 1 }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.sagePale, Color.blushLight],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                Text("🌿")
                    .font(.system(size: 60))
                    .scaleEffect(appeared ? 1 : 0.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.55).delay(0.1), value: appeared)

                Text("Module Complete")
                    .font(.custom("Georgia-Italic", size: 32))
                    .foregroundColor(.stoneDark)
                    .padding(.top, 20)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: appeared)

                Text("\"\(lesson.title)\"")
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(.stone)
                    .padding(.top, 8)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.4), value: appeared)

                HStack(spacing: 16) {
                    ForEach([("🎯", "Focused"), ("✨", "Progress"), ("🌱", "Growing")], id: \.0) { badge in
                        VStack(spacing: 6) {
                            Text(badge.0).font(.system(size: 28))
                            Text(badge.1)
                                .font(.system(size: 11))
                                .foregroundColor(.stone)
                                .tracking(0.5)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.top, 32)
                .padding(.horizontal, 24)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.55), value: appeared)

                Spacer()

                VStack(spacing: 12) {
                    if !isLastLesson {
                        Button {
                            path = [.moduleList, .lesson(lessonIndex + 1)]
                        } label: {
                            Text("Next Module →")
                                .font(.custom("Georgia", size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.sage)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .shadow(color: Color.sage.opacity(0.3), radius: 10, y: 3)
                        }
                    }

                    Button {
                        path = [.moduleList]
                    } label: {
                        Text("All Modules")
                            .font(.custom("Georgia", size: 15))
                            .foregroundColor(.stone)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.7), value: appeared)
            }
        }
        .navigationBarHidden(true)
        .onAppear { appeared = true }
    }
}

// MARK: - Shared Components

struct StepLabel: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.sage)
            .tracking(1.8)
            .textCase(.uppercase)
    }
}

struct TipBoxView: View {
    let tip: TipContent
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Rectangle()
                .fill(Color.clay)
                .frame(width: 3)
                .clipShape(RoundedRectangle(cornerRadius: 2))

            VStack(alignment: .leading, spacing: 5) {
                Text(tip.label)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.clay)
                    .tracking(1)
                    .textCase(.uppercase)
                Text(tip.text)
                    .font(.custom("Georgia", size: 13))
                    .foregroundColor(.stone)
                    .lineSpacing(3)
            }
            .padding(.leading, 14)
            .padding(.vertical, 12)
        }
        .padding(.trailing, 12)
        .background(Color.clayPale)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

/// Renders **bold** markdown inline
struct MarkdownText: View {
    let raw: String
    init(_ raw: String) { self.raw = raw }

    var body: some View {
        let attr = try? AttributedString(markdown: raw)
                return Text(attr ?? AttributedString(raw))
            .font(.custom("Georgia", size: 14))
            .foregroundColor(.stone)
            .lineSpacing(4)
    }
}

// MARK: - Preview

#Preview {
    KinesiologyMiniCourse()
}
