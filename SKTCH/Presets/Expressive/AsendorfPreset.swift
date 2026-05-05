import SwiftUI

final class AsendorfPreset: Preset {
    let name = "Asendorf"
    let category: PresetCategory = .expressive

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        let cellSize = params.scale * 1.5
        let modVal = max(1, Int(params.n))
        let primary = Color(red: params.red, green: params.green,
                            blue: params.blue, opacity: params.opacity)
        let inverted = Color(red: 1-params.red, green: 1-params.green,
                             blue: 1-params.blue, opacity: params.opacity)

        for pt in points {
            let ax = pt.position.x - 5 * params.scale
            let ay = pt.position.y - 5 * params.scale

            for j in 0..<100 {
                let xoff = CGFloat(j / 10) * cellSize
                let yoff = CGFloat(j / 10) * cellSize
                let isHighlit = (j % modVal) == 1
                let rect = CGRect(x: ax + xoff, y: ay + yoff,
                                  width: cellSize, height: cellSize)
                context.fill(Path(rect), with: .color(isHighlit ? inverted : primary))
            }
        }
    }

    func resetState() {}
}
