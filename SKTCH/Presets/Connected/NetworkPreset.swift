import SwiftUI

final class NetworkPreset: Preset {
    let name = "Network"
    let category: PresetCategory = .connected

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        guard points.count > 1 else { return }
        let primary = Color(red: 1-params.red, green: 1-params.green,
                            blue: 1-params.blue, opacity: params.opacity)
        let secondary = Color(red: params.red, green: params.green,
                              blue: params.blue, opacity: params.opacity)

        for i in 1..<points.count {
            let a = points[i-1].position
            let b = points[i].position
            let dist = hypot(b.x - a.x, b.y - a.y)
            guard dist > 1 else { continue }

            let circleR = (params.scale / 3) * dist
            let dotR = params.n

            context.fill(ellipse(center: b, radius: circleR), with: .color(primary))
            context.stroke(line(from: a, to: b), with: .color(secondary), lineWidth: 1)
            context.fill(ellipse(center: b, radius: dotR), with: .color(secondary))
            context.stroke(ellipse(center: b, radius: circleR), with: .color(secondary), lineWidth: 1)
        }
    }

    func resetState() {}

    private func ellipse(center: CGPoint, radius: CGFloat) -> Path {
        Path(ellipseIn: CGRect(x: center.x-radius, y: center.y-radius,
                               width: radius*2, height: radius*2))
    }

    private func line(from a: CGPoint, to b: CGPoint) -> Path {
        Path { p in p.move(to: a); p.addLine(to: b) }
    }
}
