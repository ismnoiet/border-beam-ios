import XCTest
import SwiftUI
@testable import BorderBeam

/// Pure configuration tests: no rendering, no Metal. Mirrors BeamConfigurationTest.kt on Android.
final class BeamConfigurationTests: XCTestCase {
    private func resolved(_ color: Color) -> Color.Resolved { color.resolve(in: EnvironmentValues()) }

    func testSingleColorPaletteFadesInAndOut() {
        let palette = BeamPalette.single(.red)
        XCTAssertEqual(palette.count, 3)
        XCTAssertEqual(resolved(palette[0]).opacity, 0.3, accuracy: 0.01)
        XCTAssertEqual(resolved(palette[1]).opacity, 1.0, accuracy: 0.001)
        XCTAssertEqual(resolved(palette[2]).opacity, 0.3, accuracy: 0.01)
    }

    func testReadyMadePalettesHaveEnoughColorsForABeam() {
        let all = [BeamPalette.colorful, BeamPalette.gemini, BeamPalette.spectrum, BeamPalette.neon,
                   BeamPalette.sunset, BeamPalette.aurora, BeamPalette.silver, BeamPalette.mono]
        for palette in all { XCTAssertGreaterThanOrEqual(palette.count, 3) }
    }

    func testCapsuleAndCircleUseAHugeRadiusThatTheShaderClamps() {
        XCTAssertGreaterThan(BeamShape.capsule.cornerRadius, 1000)
        XCTAssertGreaterThan(BeamShape.circle.cornerRadius, 1000)
        XCTAssertEqual(BeamShape.rounded(26).cornerRadius, 26)
    }

    func testDirectionsMapToOppositeShaderSigns() {
        XCTAssertEqual(BeamDirection.leftToRight.shaderValue, 1)
        XCTAssertEqual(BeamDirection.rightToLeft.shaderValue, -1)
    }

    func testDefaultTimingIsStable() {
        let t = BeamTiming.default
        XCTAssertEqual(t.rotateDuration, 2.4)
        XCTAssertEqual(t.lineDuration, 2.0)
        XCTAssertEqual(t.fade, 0.6)
    }

    func testTimingCanBeOverriddenPerField() {
        let t = BeamTiming(rotateDuration: 5)
        XCTAssertEqual(t.rotateDuration, 5)
        XCTAssertEqual(t.lineDuration, 2.0)
    }
}
