import SwiftUI

final class SquarePreset: Preset {
    let name = "Square"
    let category: PresetCategory = .geometric

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {}

    func resetState() {}
}
