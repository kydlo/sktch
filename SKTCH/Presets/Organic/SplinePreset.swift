import SwiftUI

final class SplinePreset: Preset {
    let name = "Spline"
    let category: PresetCategory = .organic

    private var scattered: [CGPoint] = []

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        while scattered.count < points.count * 2 {
            let idx = scattered.count / 2
            let base = points[min(idx, points.count-1)].position
            let spread = params.scale * 20
            scattered.append(CGPoint(
                x: base.x + CGFloat.random(in: -spread...spread),
                y: base.y + CGFloat.random(in: -spread...spread)
            ))
        }
        guard scattered.count > 2 else { return }

        let primary = Color(red: max(0, 0.8-params.red),
                            green: max(0, 0.8-params.green),
                            blue: max(0, 0.8-params.blue),
                            opacity: params.opacity)
        let dot = Color(red: 1-params.red, green: 1-params.green,
                        blue: 1-params.blue, opacity: params.opacity)

        let poly = Path { p in
            p.move(to: scattered[0])
            for pt in scattered.dropFirst() { p.addLine(to: pt) }
        }
        context.stroke(poly, with: .color(primary), lineWidth: 1)

        var curve = Path()
        var started = false
        for i in 1..<scattered.count {
            let prev = scattered[i-1]
            let cur = scattered[i]
            let dist = hypot(cur.x - prev.x, cur.y - prev.y)
            if dist > params.scale * 35 {
                let offset = params.n / 2
                let cp = CGPoint(x: cur.x + offset, y: cur.y - offset)
                if !started { curve.move(to: prev); started = true }
                curve.addQuadCurve(to: cur, control: cp)
            }
        }
        let curveColor = Color(red: 1-params.red, green: max(0, 0.88-params.green),
                               blue: 1-params.blue, opacity: params.opacity)
        context.stroke(curve, with: .color(curveColor), lineWidth: 1)

        for pt in scattered.dropFirst(3) {
            context.fill(Path(ellipseIn: CGRect(x: pt.x-1, y: pt.y-1, width: 2, height: 2)),
                         with: .color(dot))
        }
    }

    func resetState() {
        scattered.removeAll()
    }
}
