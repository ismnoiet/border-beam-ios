//
//  Examples.swift
//  BorderBeamDemo
//
//  Author: ismnoiet
//  Minimum supported: iOS 17 (macOS 14, visionOS 1)
//
//  Open Package.swift in Xcode, pick the BorderBeamDemo scheme and use the canvas
//  (or call `BorderBeamExamples()` from an app). Add demos by appending a `DemoSection`.
//
import SwiftUI
import BorderBeam

private extension View {
    /// Wraps any view in a real `Button` that does nothing (demo only).
    func asButton() -> some View {
        Button(action: {}) { self }.buttonStyle(.plain)
    }
}

struct DemoSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.4))
            content
        }
    }
}

private struct SwatchCard: View {
    let label: String
    let colors: [Color]
    let active: Bool
    var body: some View {
        BorderBeam(shape: .rounded(20), active: active, colors: colors) {
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(.white.opacity(0.6))
                .frame(width: 100, height: 70)
        }
    }
}

private struct PromptBox: View {
    let placeholder: String
    let icon: String
    let colors: [Color]
    let active: Bool
    @State private var text = ""
    @State private var mode = "Agent"
    @State private var model = "Auto"

    var body: some View {
        BorderBeam(shape: .rounded(26), active: active, colors: colors) {
            VStack(alignment: .leading, spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 26, height: 26)
                    .background(Circle().fill(.white.opacity(0.06)))
                // Any control works inside: TextField, Menu, Picker, Button…
                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .font(.system(size: 15))
                HStack(spacing: 8) {
                    menu($mode, ["Agent", "Ask", "Plan"])
                    menu($model, ["Auto", "Fast", "Pro"])
                    Spacer()
                    Button {} label: {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 12, weight: .medium))
                            .frame(width: 30, height: 30)
                            .background(Circle().fill(.white.opacity(0.08)))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(12)
            .frame(width: 340)
        }
    }

    private func menu(_ sel: Binding<String>, _ options: [String]) -> some View {
        Menu {
            Picker("", selection: sel) { ForEach(options, id: \.self) { Text($0).tag($0) } }
        } label: {
            HStack(spacing: 4) {
                Text(sel.wrappedValue).font(.system(size: 12))
                Image(systemName: "chevron.down").font(.system(size: 8, weight: .semibold))
            }
            .foregroundStyle(.white.opacity(0.75))
            .padding(.horizontal, 10).padding(.vertical, 7)
            .background(Capsule().fill(.white.opacity(0.07)))
        }
        .menuStyle(.button).buttonStyle(.plain).menuIndicator(.hidden)
    }
}

private struct AskAnythingBox: View {
    let active: Bool
    @State private var text = ""
    // Muted tones sampled from the reference (a dim, soft glow, not a bright rainbow).
    // Along the bottom edge it reads teal -> blue -> lavender -> mauve -> red -> orange.
    private let colors: [Color] = [
        Color(red: 0.80, green: 0.52, blue: 0.30),  // orange
        Color(red: 0.82, green: 0.30, blue: 0.30),  // red
        Color(red: 0.78, green: 0.42, blue: 0.55),  // mauve
        Color(red: 0.58, green: 0.52, blue: 0.78),  // lavender
        Color(red: 0.26, green: 0.46, blue: 0.76),  // blue
        Color(red: 0.22, green: 0.58, blue: 0.72),  // cyan-blue
        Color(red: 0.22, green: 0.66, blue: 0.60)   // teal
    ]

    var body: some View {
        BorderBeam(shape: .rounded(28), direction: .rightToLeft, active: active,
                   colors: colors, intensity: 0.75,
                   surface: Color(white: 0.06), borderColor: .white.opacity(0.06)) {
            VStack(alignment: .leading, spacing: 22) {
                TextField("Ask Anything...", text: $text)
                    .textFieldStyle(.plain)
                    .font(.system(size: 17))
                HStack(spacing: 14) {
                    Text("Name/Model Name")
                        .font(.system(size: 12.5))
                        .lineLimit(1)
                        .fixedSize()
                        .foregroundStyle(.white.opacity(0.85))
                        .padding(.horizontal, 16).padding(.vertical, 9)
                        .background(Capsule().fill(.white.opacity(0.12)))
                        .asButton()
                    Spacer()
                    Image(systemName: "plus").asButton()
                    Image(systemName: "cloud").asButton()
                    Image(systemName: "mic").asButton()
                    Image(systemName: "arrow.up")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(.black))
                        .asButton()
                }
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.85))
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
            .frame(width: 360)
        }
    }
}

// MARK: - More examples

/// Chat composer: neon beam travelling right to left.
private struct NeonComposer: View {
    let active: Bool
    @State private var text = ""
    var body: some View {
        BorderBeam(shape: .rounded(22), direction: .rightToLeft, active: active,
                   colors: BeamPalette.neon, surface: Color(white: 0.05)) {
            VStack(alignment: .leading, spacing: 14) {
                TextField("Message...", text: $text)
                    .textFieldStyle(.plain)
                    .font(.system(size: 16))
                HStack(spacing: 8) {
                    ForEach(["Summarize", "Translate", "Explain"], id: \.self) { chip in
                        Text(chip)
                            .font(.system(size: 12))
                            .foregroundStyle(.white.opacity(0.75))
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(Capsule().fill(.white.opacity(0.08)))
                            .asButton()
                    }
                    Spacer()
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 13))
                        .foregroundStyle(.black)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(.white))
                        .asButton()
                }
            }
            .padding(14)
            .frame(width: 340)
        }
    }
}

/// Beam only while the field has focus: any state can drive `active`.
private struct FocusField: View {
    @State private var email = ""
    @FocusState private var focused: Bool
    var body: some View {
        BorderBeam(shape: .rounded(16), active: focused, colors: BeamPalette.aurora,
                   surface: Color(white: 0.1)) {
            HStack(spacing: 10) {
                Image(systemName: "envelope").foregroundStyle(.white.opacity(0.5))
                TextField("you@example.com", text: $email)
                    .textFieldStyle(.plain)
                    .focused($focused)
            }
            .font(.system(size: 15))
            .padding(.horizontal, 14)
            .frame(width: 300, height: 52)
        }
    }
}

/// Pricing card with a warm sunset beam.
private struct SunsetCard: View {
    let active: Bool
    var body: some View {
        BorderBeam(shape: .rounded(28), active: active, colors: BeamPalette.sunset,
                   surface: Color(white: 0.08)) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Pro").font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                    Spacer()
                    Text("Popular").font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Capsule().fill(.white.opacity(0.1)))
                }
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("$19").font(.system(size: 40, weight: .semibold))
                    Text("/ month").font(.system(size: 13)).foregroundStyle(.white.opacity(0.5))
                }
                VStack(alignment: .leading, spacing: 8) {
                    feature("Unlimited projects")
                    feature("Priority support")
                    feature("Team sharing")
                }
                Text("Get started")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(.white))
                    .asButton()
            }
            .padding(20)
            .frame(width: 300)
        }
    }

    private func feature(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark").font(.system(size: 10, weight: .bold))
            Text(text).font(.system(size: 13))
        }
        .foregroundStyle(.white.opacity(0.7))
    }
}

/// Now-playing capsule: slow, subtle silver beam.
private struct NowPlaying: View {
    let active: Bool
    var body: some View {
        BorderBeam(shape: .capsule, active: active, colors: BeamPalette.silver,
                   intensity: 0.85, timing: BeamTiming(rotateDuration: 4.5),
                   surface: Color(white: 0.07)) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(LinearGradient(colors: [.purple, .indigo, .blue],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 48, height: 48)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Midnight City").font(.system(size: 14, weight: .semibold))
                    Text("M83").font(.system(size: 12)).foregroundStyle(.white.opacity(0.5))
                }
                Spacer()
                Image(systemName: "play.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(.black)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(.white))
                    .asButton()
            }
            .padding(10)
            .frame(width: 320)
        }
    }
}

/// Toast: single green color, faster lap.
private struct Toast: View {
    let active: Bool
    var body: some View {
        BorderBeam(shape: .capsule, active: active,
                   colors: BeamPalette.single(Color(red: 0.25, green: 0.85, blue: 0.5)),
                   timing: BeamTiming(rotateDuration: 1.6),
                   surface: Color(white: 0.09)) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color(red: 0.25, green: 0.85, blue: 0.5))
                Text("Saved to library").font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 18)
            .frame(height: 44)
            .asButton()
        }
    }
}

/// Avatar ring.
private struct AvatarBeam: View {
    let active: Bool
    var body: some View {
        BorderBeam(.small, shape: .circle, active: active, colors: BeamPalette.neon,
                   surface: Color(white: 0.12)) {
            Text("IS")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white.opacity(0.85))
                .frame(width: 68, height: 68)
                .asButton()
        }
    }
}

/// Gradient-border button: tight beam on a capsule.
private struct UpgradeButton: View {
    let active: Bool
    var body: some View {
        BorderBeam(.small, shape: .capsule, active: active, colors: BeamPalette.sunset,
                   surface: Color(white: 0.07)) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                Text("Upgrade").font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 28)
            .frame(height: 48)
            .asButton()
        }
    }
}

public struct BorderBeamExamples: View {
    @State private var active = true
    @State private var query = ""

    public init() {}

    public var body: some View {
        ZStack {
            Color(white: 0.09).ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    DemoSection(title: "Large") {
                        PromptBox(placeholder: "Build anything...", icon: "at",
                                  colors: BeamPalette.spectrum, active: active)
                    }
                    DemoSection(title: "Ask Anything (right to left)") {
                        AskAnythingBox(active: active)
                    }
                    DemoSection(title: "Small") {
                        BorderBeam(.small, shape: .circle, active: active) {
                            RoundedRectangle(cornerRadius: 2).fill(.white.opacity(0.75))
                                .frame(width: 9, height: 9)
                                .frame(width: 36, height: 36)
                                .asButton()
                        }
                    }
                    DemoSection(title: "Line") {
                        BorderBeam(.line, shape: .capsule, active: active) {
                            HStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                TextField("Search", text: $query)
                                    .textFieldStyle(.plain)
                            }
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.horizontal, 14)
                            .frame(width: 280, height: 42)
                        }
                    }
                    DemoSection(title: "Chat composer (neon, right to left)") {
                        NeonComposer(active: active)
                    }
                    DemoSection(title: "Beam while focused (tap the field)") {
                        FocusField()
                    }
                    DemoSection(title: "Pricing card (sunset)") {
                        SunsetCard(active: active)
                    }
                    DemoSection(title: "Now playing (slow silver)") {
                        NowPlaying(active: active)
                    }
                    DemoSection(title: "Toast (single color, fast)") {
                        Toast(active: active)
                    }
                    DemoSection(title: "Avatar + gradient button") {
                        HStack(spacing: 24) {
                            AvatarBeam(active: active)
                            UpgradeButton(active: active)
                        }
                    }
                    DemoSection(title: "Search (aurora line)") {
                        BorderBeam(.line, shape: .capsule, active: active, colors: BeamPalette.aurora,
                                   surface: Color(white: 0.08)) {
                            HStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                Text("Search the docs").frame(maxWidth: .infinity, alignment: .leading)
                                Text("⌘K").font(.system(size: 11, weight: .medium))
                                    .padding(.horizontal, 6).padding(.vertical, 3)
                                    .background(RoundedRectangle(cornerRadius: 5).fill(.white.opacity(0.1)))
                            }
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.horizontal, 14)
                            .frame(width: 300, height: 44)
                        }
                    }
                    DemoSection(title: "Single color") {
                        HStack(spacing: 20) {
                            SwatchCard(label: "Blue", colors: BeamPalette.single(.blue), active: active)
                            SwatchCard(label: "Green", colors: BeamPalette.single(.green), active: active)
                            SwatchCard(label: "White", colors: BeamPalette.single(.white), active: active)
                        }
                    }
                    Button { active.toggle() } label: {
                        Text(active ? "Pause" : "Play")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.white.opacity(0.85))
                            .padding(.horizontal, 18).padding(.vertical, 8)
                            .background(Capsule().fill(.white.opacity(0.08)))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview { BorderBeamExamples() }
