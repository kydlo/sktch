import SwiftUI

final class OrbitPreset: Preset {
    let name = "Orbit"
    let category: PresetCategory = .organic

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        guard points.count > 1 else { return }
        let color = Color(red: 1-params.red, green: 1-params.green,
                          blue: 1-params.blue, opacity: min(1, params.opacity + 0.39))

        for i in 1..<points.count {
            let cur = points[i].position
            let prev = points[i-1].position
            var dist = hypot(cur.x-prev.x, cur.y-prev.y) * params.n
            if dist > 50 { dist = 50 }

            for phase in stride(from: 0.0, through: 5.0, by: 1.0) {
                let px = cur.x + sin(Double(i)/100.0 + phase) * Double(dist) * 0.5
                let py = cur.y + cos(Double(i)/100.0 + phase) * Double(dist) * 0.5
                let r = params.scale
                context.fill(
                    Path(ellipseIn: CGRect(x: px-r, y: py-r, width: r*2, height: r*2)),
                    with: .color(color)
                )
            }
        }
    }

    func resetState() {}
}
