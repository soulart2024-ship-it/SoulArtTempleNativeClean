//
//  FrequencyCalibrationView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 30/04/2026.
//
import SwiftUI

// MARK: - Hawkins Level Model

struct HawkinsLevel {
    let frequency: Int
    let name: String
    let description: String
    let guidance: String
    let color: Color
}

// MARK: - Calibration Question

struct CalibrationQuestion {
    let text: String
    let yesFrequency: Int
    let noFrequency: Int
}

// MARK: - FrequencyCalibrationView

struct FrequencyCalibrationView: View {

    @Environment(\.dismiss) var dismiss
    var onComplete: (Int) -> Void

    @State private var phase: CalibrationPhase = .welcome
    @State private var methodChoice: CalibrationMethod = .muscleTest
    @State private var currentQuestion = 0
    @State private var answers: [Bool] = []
    @State private var sliderValue: Double = 200
    @State private var resultFrequency: Int = 200
    @State private var appeared = false

    enum CalibrationPhase {
        case welcome, methodChoice, muscleTestIntro, questions, sliderChoice, result
    }

    enum CalibrationMethod {
        case muscleTest, slider, both
    }

    let questions: [CalibrationQuestion] = [
        CalibrationQuestion(
            text: "When you get angry, are you able to recalibrate and return to calm within one hour?",
            yesFrequency: 400, noFrequency: 150
        ),
        CalibrationQuestion(
            text: "If a friend hurts your feelings, are you able to still care for this person within one hour of that hurt?",
            yesFrequency: 500, noFrequency: 175
        ),
        CalibrationQuestion(
            text: "If a loved one does something illegal, are you able to still love them?",
            yesFrequency: 540, noFrequency: 175
        ),
        CalibrationQuestion(
            text: "Do you have clear boundaries with your boss or partner?",
            yesFrequency: 310, noFrequency: 130
        ),
        CalibrationQuestion(
            text: "Do you tend to agree with others mainly to avoid confrontation?",
            yesFrequency: 150, noFrequency: 310
        ),
        CalibrationQuestion(
            text: "When you feel threatened or overwhelmed, do you tend to shut down or withdraw rather than respond?",
            yesFrequency: 100, noFrequency: 250
        ),
        CalibrationQuestion(
            text: "Do you seem to attract the same type of partner, or notice the same patterns repeating in relationships?",
            yesFrequency: 175, noFrequency: 350
        ),
        CalibrationQuestion(
            text: "Are you able to forgive your ex — not for them, but for your own peace?",
            yesFrequency: 350, noFrequency: 175
        ),
        CalibrationQuestion(
            text: "If you have experienced trauma, are you able to forgive the person who caused it?",
            yesFrequency: 500, noFrequency: 150
        ),
        CalibrationQuestion(
            text: "Do you know your personal emotional triggers?",
            yesFrequency: 310, noFrequency: 175
        ),
        CalibrationQuestion(
            text: "Are you aware of how your body responds when you first meet someone new?",
            yesFrequency: 350, noFrequency: 200
        ),
        CalibrationQuestion(
            text: "Do you find yourself resistant to change, even when you know it would be good for you?",
            yesFrequency: 150, noFrequency: 310
        ),
        CalibrationQuestion(
            text: "Do you spend a significant amount of time watching or reading the news each day?",
            yesFrequency: 150, noFrequency: 310
        ),
        CalibrationQuestion(
            text: "Do you find yourself emotionally moved or unsettled by political events?",
            yesFrequency: 150, noFrequency: 350
        ),
        CalibrationQuestion(
            text: "Do you find it easy to ask for help when you need it?",
            yesFrequency: 350, noFrequency: 150
        ),
        CalibrationQuestion(
            text: "Do you generally trust that things will work out, even when you can't see how?",
            yesFrequency: 400, noFrequency: 150
        )
    ]

    // MARK: - Hawkins Levels

    func hawkinsLevel(for frequency: Int) -> HawkinsLevel {
        switch frequency {
        case 0..<50:
            return HawkinsLevel(frequency: frequency, name: "Shame", description: "A deeply contracted state. The body holds this quietly.", guidance: "Be very gentle with yourself today. This session is an act of courage.", color: Color(red: 0.3, green: 0.1, blue: 0.1))
        case 50..<75:
            return HawkinsLevel(frequency: frequency, name: "Guilt", description: "The weight of the past sits heavy here.", guidance: "Release begins with self-compassion. You are worthy of peace.", color: Color(red: 0.4, green: 0.15, blue: 0.1))
        case 75..<100:
            return HawkinsLevel(frequency: frequency, name: "Apathy", description: "A quiet withdrawal from life.", guidance: "Even small movement matters. You showed up — that is everything.", color: Color(red: 0.35, green: 0.25, blue: 0.35))
        case 100..<125:
            return HawkinsLevel(frequency: frequency, name: "Grief", description: "Loss lives here, sometimes unnamed.", guidance: "Grief is love with nowhere to go. Let it move through you gently.", color: Color(red: 0.45, green: 0.30, blue: 0.45))
        case 125..<175:
            return HawkinsLevel(frequency: frequency, name: "Fear", description: "The nervous system is on alert.", guidance: "Fear is information. Your body is asking to feel safe. Let's help it.", color: Color(red: 0.55, green: 0.25, blue: 0.10))
        case 175..<200:
            return HawkinsLevel(frequency: frequency, name: "Desire", description: "Reaching outward, looking for more.", guidance: "Desire is energy. Channel it inward — what does your soul truly want?", color: Color(red: 0.65, green: 0.35, blue: 0.10))
        case 200..<250:
            return HawkinsLevel(frequency: frequency, name: "Anger", description: "Power that hasn't found its purpose yet.", guidance: "Anger is a boundary asking to be set. Let's find what needs protecting.", color: Color(red: 0.70, green: 0.20, blue: 0.10))
        case 250..<310:
            return HawkinsLevel(frequency: frequency, name: "Pride", description: "Standing tall, but sometimes defended.", guidance: "Pride protects. Today, can you let your guard soften just a little?", color: Color(red: 0.75, green: 0.55, blue: 0.10))
        case 310..<350:
            return HawkinsLevel(frequency: frequency, name: "Courage", description: "The turning point. You are ready to move.", guidance: "Courage is not the absence of fear — it is choosing to release anyway.", color: Theme.goldSoft)
        case 350..<400:
            return HawkinsLevel(frequency: frequency, name: "Neutrality", description: "A calm, open, undefended state.", guidance: "From here, release flows naturally. Your nervous system is ready.", color: Color(red: 0.50, green: 0.65, blue: 0.50))
        case 400..<450:
            return HawkinsLevel(frequency: frequency, name: "Willingness", description: "Open and ready. Something has shifted.", guidance: "You are in flow. Trust what comes up in this session.", color: Color(red: 0.40, green: 0.65, blue: 0.55))
        case 450..<500:
            return HawkinsLevel(frequency: frequency, name: "Acceptance", description: "Life is met with open hands.", guidance: "Release will come easily today. Your body knows how to let go.", color: Color(red: 0.30, green: 0.60, blue: 0.60))
        case 500..<540:
            return HawkinsLevel(frequency: frequency, name: "Love", description: "Unconditional. Beyond conditions.", guidance: "You carry a rare frequency. Even this session is an act of love.", color: Color(red: 0.55, green: 0.35, blue: 0.65))
        case 540..<600:
            return HawkinsLevel(frequency: frequency, name: "Joy", description: "Effortless, radiant, whole.", guidance: "You are vibrating at a transformative level. What a gift to release from here.", color: Color(red: 0.65, green: 0.45, blue: 0.75))
        default:
            return HawkinsLevel(frequency: frequency, name: "Peace", description: "Stillness beyond understanding.", guidance: "You operate from the highest awareness. This session will be profound.", color: Color(red: 0.75, green: 0.55, blue: 0.85))
        }
    }

    // MARK: - Calculate Result

    func calculateFrequency() -> Int {
        guard !answers.isEmpty else { return 200 }
        var total = 0
        for (index, answer) in answers.enumerated() {
            let q = questions[index]
            total += answer ? q.yesFrequency : q.noFrequency
        }
        return total / answers.count
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Theme.templeParchment.ignoresSafeArea()

            switch phase {
            case .welcome:          welcomeView
            case .methodChoice:     methodChoiceView
            case .muscleTestIntro:  muscleTestIntroView
            case .questions:        questionView
            case .sliderChoice:     sliderView
            case .result:           resultView
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - WELCOME

    var welcomeView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                Text("⚡")
                    .font(.system(size: 52))
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.7)
                    .animation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.1), value: appeared)

                Text("Frequency Calibration")
                    .font(.custom("Georgia-Italic", size: 30))
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: appeared)

                Text("Before you begin releasing, let's discover where your energy is right now.")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.5), value: appeared)

                Text("This is based on Dr David Hawkins' Map of Consciousness — a proven scale of human frequency from 20 to 600+.")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textSecondary.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.7), value: appeared)
            }

            Spacer()

            VStack(spacing: 12) {
                Button {
                    withAnimation { phase = .methodChoice }
                } label: {
                    Text("Begin Calibration")
                        .font(Theme.cardTitle)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.deepBrown)
                        .foregroundStyle(Theme.warmParchment)
                        .cornerRadius(14)
                        .padding(.horizontal, 40)
                }

                Button {
                    dismiss()
                } label: {
                    Text("Skip for now")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary.opacity(0.6))
                }
            }
            .padding(.bottom, 50)
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.5).delay(0.9), value: appeared)
        }
        .onAppear { appeared = true }
    }

    // MARK: - METHOD CHOICE

    var methodChoiceView: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("How would you like to calibrate?")
                .font(.custom("Georgia-Italic", size: 26))
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            VStack(spacing: 16) {
                methodCard(
                    icon: "👆",
                    title: "Muscle Test",
                    subtitle: "Use your body's yes/no response to answer 15 questions",
                    method: .muscleTest
                )

                methodCard(
                    icon: "📊",
                    title: "Frequency Slider",
                    subtitle: "Intuitively slide to where you feel your energy sits today",
                    method: .slider
                )

                methodCard(
                    icon: "✨",
                    title: "Both Together",
                    subtitle: "Questions first, then refine with the slider",
                    method: .both
                )
            }
            .padding(.horizontal, 24)

            Spacer()
        }
    }

    func methodCard(icon: String, title: String, subtitle: String, method: CalibrationMethod) -> some View {
        Button {
            methodChoice = method
            withAnimation {
                if method == .slider {
                    phase = .sliderChoice
                } else {
                    phase = .muscleTestIntro
                }
            }
        } label: {
            HStack(spacing: 16) {
                Text(icon).font(.system(size: 28))
                    .frame(width: 44)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Theme.cardTitle)
                        .foregroundStyle(Theme.textPrimary)
                    Text(subtitle)
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Theme.textSecondary.opacity(0.4))
            }
            .padding(18)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Theme.goldSoft.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - MUSCLE TEST INTRO

    var muscleTestIntroView: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 16) {
                Text("👆")
                    .font(.system(size: 48))

                Text("Prepare Your Signal")
                    .font(.custom("Georgia-Italic", size: 26))
                    .foregroundStyle(Theme.textPrimary)

                VStack(spacing: 12) {
                    Text("Before we begin, calibrate your yes and no.")
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)

                    Text("Bring your forefinger and thumb together and begin rubbing them gently in circles.")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary.opacity(0.8))
                        .multilineTextAlignment(.center)

                    Text("Say your real name — notice the smooth, easy motion. That is your YES.")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary.opacity(0.8))
                        .multilineTextAlignment(.center)

                    Text("Say a name that isn't yours — notice the catch or drag. That is your NO.")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
            }

            Spacer()

            Button {
                withAnimation { phase = .questions }
            } label: {
                Text("My signal is clear — Begin")
                    .font(Theme.cardTitle)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.deepBrown)
                    .foregroundStyle(Theme.warmParchment)
                    .cornerRadius(14)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 50)
        }
    }

    // MARK: - QUESTION VIEW

    var questionView: some View {
        VStack(spacing: 0) {

            // Progress
            VStack(spacing: 4) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Theme.warmParchment)
                            .frame(height: 4)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Theme.goldSoft)
                            .frame(width: geo.size.width * Double(currentQuestion + 1) / Double(questions.count), height: 4)
                            .animation(.easeInOut(duration: 0.4), value: currentQuestion)
                    }
                }
                .frame(height: 4)
                .padding(.horizontal, 24)

                Text("\(currentQuestion + 1) of \(questions.count)")
                    .font(.system(size: 11))
                    .foregroundStyle(Theme.textSecondary.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 24)
            }
            .padding(.top, 20)
            .padding(.bottom, 8)
            .background(Color.white)

            Spacer()

            VStack(spacing: 28) {

                Text("👆 Use your body's response")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary.opacity(0.5))
                    .tracking(1)

                Text(questions[currentQuestion].text)
                    .font(.custom("Georgia", size: 20))
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            HStack(spacing: 20) {
                answerButton(label: "YES", isYes: true)
                answerButton(label: "NO", isYes: false)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
        }
    }

    func answerButton(label: String, isYes: Bool) -> some View {
        Button {
            Haptics.light()
            answers.append(isYes)

            if currentQuestion < questions.count - 1 {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentQuestion += 1
                }
            } else {
                let freq = calculateFrequency()
                resultFrequency = freq

                if methodChoice == .both {
                    sliderValue = Double(freq)
                    withAnimation { phase = .sliderChoice }
                } else {
                    withAnimation { phase = .result }
                }
            }
        } label: {
            Text(label)
                .font(.custom("Georgia", size: 22))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    isYes
                    ? Theme.deepBrown
                    : Color.white
                )
                .foregroundStyle(isYes ? Theme.warmParchment : Theme.textPrimary)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.deepBrown.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
        }
        .buttonStyle(.plain)
    }

    // MARK: - SLIDER VIEW

    var sliderView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("📊")
                    .font(.system(size: 48))

                Text("Where does your energy sit today?")
                    .font(.custom("Georgia-Italic", size: 24))
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Text("Trust your first instinct. Don't overthink it — your body already knows.")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textSecondary.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                VStack(spacing: 8) {
                    let level = hawkinsLevel(for: Int(sliderValue))

                    Text("\(Int(sliderValue))")
                        .font(.system(size: 48, weight: .light))
                        .foregroundStyle(level.color)

                    Text(level.name)
                        .font(.custom("Georgia-Italic", size: 22))
                        .foregroundStyle(Theme.textPrimary)

                    Text(level.description)
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .animation(.easeInOut(duration: 0.2), value: Int(sliderValue / 25))

                VStack(spacing: 8) {
                    HStack {
                        Text("20")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary.opacity(0.4))
                        Spacer()
                        Text("600")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary.opacity(0.4))
                    }
                    .padding(.horizontal, 32)

                    Slider(value: $sliderValue, in: 20...600, step: 5)
                        .tint(hawkinsLevel(for: Int(sliderValue)).color)
                        .padding(.horizontal, 32)
                }
            }

            Spacer()

            Button {
                resultFrequency = Int(sliderValue)
                withAnimation { phase = .result }
            } label: {
                Text("This feels right")
                    .font(Theme.cardTitle)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.deepBrown)
                    .foregroundStyle(Theme.warmParchment)
                    .cornerRadius(14)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 50)
        }
    }

    // MARK: - RESULT VIEW

    var resultView: some View {
        VStack(spacing: 0) {
            Spacer()

            let level = hawkinsLevel(for: resultFrequency)

            VStack(spacing: 20) {

                Circle()
                    .fill(level.color.opacity(0.15))
                    .frame(width: 120, height: 120)
                    .overlay(
                        VStack(spacing: 2) {
                            Text("\(resultFrequency)")
                                .font(.system(size: 36, weight: .light))
                                .foregroundStyle(level.color)
                            Text("Hz")
                                .font(.caption)
                                .foregroundStyle(level.color.opacity(0.7))
                        }
                    )
                    .overlay(
                        Circle()
                            .stroke(level.color.opacity(0.3), lineWidth: 1.5)
                    )

                VStack(spacing: 8) {
                    Text(level.name)
                        .font(.custom("Georgia-Italic", size: 30))
                        .foregroundStyle(Theme.textPrimary)

                    Text(level.description)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Text(level.guidance)
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textSecondary.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(level.color.opacity(0.08))
                    )
                    .padding(.horizontal, 32)
            }

            Spacer()

            VStack(spacing: 12) {
                Button {
                    onComplete(resultFrequency)
                    dismiss()
                } label: {
                    Text("Begin My Release")
                        .font(Theme.cardTitle)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.deepBrown)
                        .foregroundStyle(Theme.warmParchment)
                        .cornerRadius(14)
                        .padding(.horizontal, 40)
                }

                Button {
                    // Reset and try again
                    answers = []
                    currentQuestion = 0
                    sliderValue = 200
                    withAnimation { phase = .welcome }
                } label: {
                    Text("Recalibrate")
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary.opacity(0.6))
                }
            }
            .padding(.bottom, 50)
        }
    }
}
