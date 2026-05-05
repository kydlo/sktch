import SwiftUI

final class PlanesPreset: Preset {
    let name = "Planes"
    let category: PresetCategory = .expressive

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        guard points.count > 1 else { return }

        for i in 1..<points.count {
            let p = points[i].position
            let rectSize = p.y * params.scale / 20

            let stroked = Color(red: 1-params.red, green: 1-params.green,
                                blue: 1-params.blue, opacity: params.opacity)
            let rect = CGRect(x: p.x, y: p.y, width: rectSize, height: rectSize)
            context.stroke(Path(rect), with: .color(stroked), lineWidth: 1)

            let yFrac = min(1, p.y / max(1, size.height))
            let filled1 = Color(red: max(0, 1-params.red-yFrac),
                                green: max(0, 1-params.green),
                                blue: max(0, 1-params.blue),
                                opacity: min(1, params.opacity + 0.59 - yFrac))
            context.fill(Path(rect), with: .color(filled1))

            let filled2 = Color(red: 1-params.red, green: 1-params.green,
                                blue: 1-params.blue,
                                opacity: max(0, params.opacity - yFrac))
            context.fill(Path(rect), with: .color(filled2))
        }
    }

    func resetState() {}
}
