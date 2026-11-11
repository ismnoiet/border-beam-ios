//
//  ExamplesLight.swift
//  BorderBeamDemo
//
//  Author: ismnoiet
//  Minimum supported: iOS 17 (macOS 14, visionOS 1)
//
//  Light-theme demos on real-world UI. Open Package.swift in Xcode, pick the
//  BorderBeamDemo scheme and use the canvas (or call `BorderBeamExamplesLight()` from an app).
//  Add demos by appending a `LightSection`.
//
import SwiftUI
import BorderBeam

private extension View {
    /// Wraps any view in a real `Button` that does nothing (demo only).
    func asButton() -> some View {
        Button(action: {}) { self }.buttonStyle(.plain)
    }

    /// Soft card shadow used on light surfaces.
    func lightShadow() -> some View {
        shadow(color: .black.opacity(0.06), radius: 14, y: 6)
    }
}

/// Saturated colors so the beam stays visible on white surfaces.
private enum LightPalette {
    static let blue = Color(red: 0.20, green: 0.52, blue: 1.00)
    static let violet = Color(red: 0.55, green: 0.36, blue: 0.96)
    static let pink = Color(red: 0.95, green: 0.33, blue: 0.62)
    static let orange = Color(red: 1.00, green: 0.55, blue: 0.25)
    static let green = Color(red: 0.12, green: 0.72, blue: 0.45)
    static let teal = Color(red: 0.10, green: 0.72, blue: 0.78)

    static let aiGlow: [Color] = [blue, violet, pink, orange]
    static let ocean: [Color] = [teal, blue, violet]
    static let candy: [Color] = [pink, violet, blue]
    static let focus: [Color] = [green, teal, blue]
    static let sunrise: [Color] = [
        Color(red: 1.00, green: 0.45, blue: 0.30),
        Color(red: 1.00, green: 0.70, blue: 0.20),
        Color(red: 0.98, green: 0.35, blue: 0.55)
    ]
    static let recording: [Color] = [
        Color(red: 1.00, green: 0.27, blue: 0.33),
        Color(red: 0.98, green: 0.40, blue: 0.55),
        Color(red: 1.00, green: 0.60, blue: 0.30)
    ]
}

private let paper = Color(red: 0.96, green: 0.96, blue: 0.97)
private let ink = Color(red: 0.10, green: 0.11, blue: 0.14)
private let subtle = Color(red: 0.45, green: 0.47, blue: 0.52)
private let hairline = Color.black.opacity(0.06)

private func gradient(_ a: Color, _ b: Color) -> LinearGradient {
    LinearGradient(colors: [a, b], startPoint: .topLeading, endPoint: .bottomTrailing)
}

private struct LightSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(subtle)
            content
        }
    }
}

/// AI composer: large multi-color beam around a message box.
private struct ComposerCard: View {
    @State private var text = ""
    var body: some View {
        BorderBeam(shape: .rounded(28), colors: LightPalette.aiGlow,
                   surface: .white, borderColor: hairline) {
            VStack(alignment: .leading, spacing: 14) {
                TextField("Message Assistant…", text: $text, axis: .vertical)
                    .textFieldStyle(.plain)
                    .font(.system(size: 17))
                    .foregroundStyle(ink)
                    .lineLimit(1...4)
                HStack(spacing: 10) {
                    Image(systemName: "plus")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(ink)
                        .frame(width: 34, height: 34)
                        .background(Circle().fill(.black.opacity(0.05)))
                        .asButton()
                    Label("Search", systemImage: "globe")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(ink)
                        .padding(.horizontal, 12)
                        .frame(height: 34)
                        .background(Capsule().fill(.black.opacity(0.05)))
                        .asButton()
                    Spacer()
                    Image(systemName: "arrow.up")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 34)
                        .background(Circle().fill(ink))
                        .asButton()
                }
            }
            .padding(18)
        }
        .lightShadow()
    }
}

/// Suggestion chips: small single-color beams on capsules.
private struct SuggestionChips: View {
    private let items: [(title: String, icon: String, color: Color)] = [
        ("Plan a trip", "airplane", LightPalette.blue),
        ("Write code", "chevron.left.forwardslash.chevron.right", LightPalette.violet),
        ("Surprise me", "sparkles", LightPalette.pink),
        ("Recipe ideas", "fork.knife", LightPalette.orange)
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(items, id: \.title) { item in
                    BorderBeam(.small, shape: .capsule, colors: BeamPalette.single(item.color),
                               intensity: 0.9, timing: BeamTiming(rotateDuration: 3.2),
                               surface: .white, borderColor: hairline) {
                        Label(item.title, systemImage: item.icon)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(ink)
                            .padding(.horizontal, 16)
                            .frame(height: 40)
                    }
                    .lightShadow()
                    .asButton()
                }
            }
            .padding(.vertical, 8).padding(.horizontal, 20)
        }
        .padding(.horizontal, -20)
    }
}

/// Voice recorder: the beam runs only while recording, with a live waveform and timer.
private struct VoiceRecorder: View {
    @State private var recording = true
    @State private var elapsed = 0

    var body: some View {
        BorderBeam(shape: .rounded(28), active: recording, colors: LightPalette.recording,
                   timing: BeamTiming(rotateDuration: 2.6),
                   surface: .white, borderColor: hairline) {
            VStack(spacing: 20) {
                HStack {
                    Circle()
                        .fill(recording ? LightPalette.recording[0] : subtle)
                        .frame(width: 10, height: 10)
                    Text(recording ? "Recording" : "Paused")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(ink)
                    Spacer()
                    Text(String(format: "%d:%02d", elapsed / 60, elapsed % 60))
                        .font(.system(size: 14, weight: .medium))
                        .monospacedDigit()
                        .foregroundStyle(subtle)
                }
                TimelineView(.animation(paused: !recording)) { tl in
                    waveform(t: tl.date.timeIntervalSinceReferenceDate)
                }
                .frame(height: 56)
                HStack(spacing: 34) {
                    control("trash", size: 48, color: subtle)
                    Image(systemName: recording ? "pause.fill" : "mic.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 68, height: 68)
                        .background(Circle().fill(gradient(LightPalette.recording[0],
                                                           LightPalette.recording[2])))
                        .shadow(color: LightPalette.recording[0].opacity(0.35), radius: 12, y: 6)
                        .onTapGesture { recording.toggle() }
                    control("checkmark", size: 48, color: ink)
                }
            }
            .padding(22)
        }
        .lightShadow()
        .task(id: recording) {
            while recording && !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if recording { elapsed += 1 }
            }
        }
    }

    private func control(_ icon: String, size: CGFloat, color: Color) -> some View {
        Image(systemName: icon)
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(color)
            .frame(width: size, height: size)
            .background(Circle().fill(.black.opacity(0.05)))
            .asButton()
    }

    private func waveform(t: Double) -> some View {
        HStack(spacing: 3) {
            ForEach(0..<38, id: \.self) { i in
                let x = Double(i)
                let a = abs(sin(t * 3.2 + x * 0.55))
                let b = 0.45 + 0.55 * abs(sin(t * 1.4 + x * 0.21))
                Capsule()
                    .fill(gradient(LightPalette.recording[0], LightPalette.recording[2]))
                    .frame(width: 3, height: CGFloat(recording ? 6 + 50 * a * b : 6))
            }
        }
        .frame(maxWidth: .infinity).frame(height: 56)
    }
}

/// Stories: circular beams, each with its own palette and speed.
private struct StoriesRow: View {
    private let people: [(name: String, from: Color, to: Color, colors: [Color])] = [
        ("Mia", LightPalette.pink, LightPalette.orange, LightPalette.sunrise),
        ("Leo", LightPalette.blue, LightPalette.teal, LightPalette.ocean),
        ("Zoe", LightPalette.violet, LightPalette.pink, LightPalette.candy),
        ("Sam", LightPalette.green, LightPalette.teal, BeamPalette.single(LightPalette.green)),
        ("Ava", LightPalette.orange, LightPalette.pink, LightPalette.aiGlow)
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                // The add button gets a beam too.
                story("You", colors: LightPalette.aiGlow, speed: 2.8) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(ink)
                }
                ForEach(Array(people.enumerated()), id: \.offset) { i, p in
                    story(p.name, colors: p.colors, speed: 2.2 + Double(i) * 0.35) {
                        ZStack {
                            Circle().fill(gradient(p.from, p.to))
                            Text(String(p.name.prefix(1)))
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .padding(.vertical, 6).padding(.horizontal, 24)
        }
        .padding(.horizontal, -20)
    }

    private func story<Avatar: View>(_ name: String, colors: [Color], speed: Double,
                                     @ViewBuilder avatar: () -> Avatar) -> some View {
        VStack(spacing: 6) {
            BorderBeam(.small, shape: .circle, colors: colors,
                       timing: BeamTiming(rotateDuration: speed),
                       surface: .white, borderColor: hairline) {
                avatar().frame(width: 56, height: 56).padding(4)
            }
            Text(name).font(.system(size: 12)).foregroundStyle(subtle)
        }
        .asButton()
    }
}

/// Search bar: line beam sweeping along the bottom edge.
private struct SearchBar: View {
    var body: some View {
        BorderBeam(.line, shape: .capsule, colors: LightPalette.aiGlow,
                   timing: BeamTiming(lineDuration: 2.4),
                   surface: .white, borderColor: hairline) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                Text("Search destinations")
                Spacer()
                Image(systemName: "slider.horizontal.3").foregroundStyle(ink)
            }
            .font(.system(size: 16))
            .foregroundStyle(subtle)
            .padding(.horizontal, 20)
            .frame(height: 56)
        }
        .lightShadow()
        .asButton()
    }
}

/// Focus timer: large beam around a circle.
private struct FocusTimer: View {
    var body: some View {
        BorderBeam(shape: .circle, colors: LightPalette.focus,
                   timing: BeamTiming(rotateDuration: 3.6),
                   surface: .white, borderColor: hairline) {
            VStack(spacing: 6) {
                Text("25:00")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(ink)
                Text("Deep focus").font(.system(size: 14, weight: .medium)).foregroundStyle(subtle)
            }
            .frame(width: 200, height: 200)
            .asButton()
        }
        .lightShadow()
    }
}

public struct BorderBeamExamplesLight: View {
    public init() {}

    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                ComposerCard()
                SuggestionChips()
                LightSection(title: "Voice recording") { VoiceRecorder() }
                LightSection(title: "Stories") { StoriesRow() }
                LightSection(title: "Search") { SearchBar() }
                LightSection(title: "Focus timer") { FocusTimer() }
            }
            .padding(.horizontal, 20).padding(.vertical, 32)
        }
        .background(paper.ignoresSafeArea())
        .preferredColorScheme(.light)
    }
}

#Preview { BorderBeamExamplesLight() }
