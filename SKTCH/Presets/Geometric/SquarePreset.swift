import SwiftUI

final class SquarePreset: Preset {
    let name = "Square"
    let category: PresetCategory = .geometric

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        guard points.count > 1 else { return }
        let s = params.scale * 20
        let color = Color(red: 1-params.red, green: 1-params.green,
                          blue: 1-params.blue, opacity: params.opacity)
        for i in 1..<points.count {
            let p = points[i].position
            let rect = CGRect(x: p.x - s/2, y: p.y - s/2, width: s, height: s)
            context.fill(Path(rect), with: .color(color))
        }
    }

    func resetState() {}
}
