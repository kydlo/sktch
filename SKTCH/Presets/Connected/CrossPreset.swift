import SwiftUI

final class CrossPreset: Preset {
    let name = "Cross"
    let category: PresetCategory = .connected

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        guard points.count > 1 else { return }

        for i in 1..<points.count {
            let a = points[i-1].position
            let b = points[i].position
            let maxSize = params.scale * 20
            let weight = params.n * 2
            var s = maxSize - hypot(b.x-a.x, b.y-a.y) * 1.6
            if s < 1 { s = hypot(b.x-a.x, b.y-a.y) / maxSize }
            let rot = cos(floor(a.x * a.y / 8000)) * 45
            drawCross(at: a, size: s, weight: weight, rotation: rot, params: params, in: &context)
        }
    }

    func resetState() {}

    private func drawCross(at center: CGPoint, size: CGFloat, weight: CGFloat,
                           rotation: CGFloat, params: DrawingParameters,
                           in context: inout GraphicsContext) {
        let s = size / 2
        let w = weight / 2
        let col = min(1.0, abs(rotation) / 255.0)
        let color = Color(red: max(0, 1-params.red-col),
                          green: max(0, 1-params.green-col),
                          blue: max(0, 1-params.blue-col),
                          opacity: min(1, params.opacity + 0.08))

        let shape = Path { p in
            p.move(to: CGPoint(x: -s, y: -w))
            p.addLine(to: CGPoint(x: -s, y: w))
            p.addLine(to: CGPoint(x: -w, y: w))
            p.addLine(to: CGPoint(x: -w, y: s))
            p.addLine(to: CGPoint(x: w, y: s))
            p.addLine(to: CGPoint(x: w, y: w))
            p.addLine(to: CGPoint(x: s, y: w))
            p.addLine(to: CGPoint(x: s, y: -w))
            p.addLine(to: CGPoint(x: w, y: -w))
            p.addLine(to: CGPoint(x: w, y: -s))
            p.addLine(to: CGPoint(x: -w, y: -s))
            p.addLine(to: CGPoint(x: -w, y: -w))
            p.closeSubpath()
        }

        var ctx = context
        ctx.translateBy(x: center.x, y: center.y)
        ctx.rotate(by: .degrees(Double(rotation)))
        ctx.fill(shape, with: .color(color))
    }
}
