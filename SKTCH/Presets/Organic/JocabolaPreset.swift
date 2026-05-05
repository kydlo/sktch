import SwiftUI

final class JocabolaPreset: Preset {
    let name = "Jocabola"
    let category: PresetCategory = .organic

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        guard points.count > 1 else { return }
        let stroked = Color(red: 1-params.red, green: 1-params.green,
                            blue: 1-params.blue, opacity: min(1, params.opacity * 5))
        let filled = Color(red: 1-params.red, green: 1-params.green,
                           blue: 1-params.blue, opacity: max(0, params.opacity - 0.04))

        for i in 0..<(points.count - 1) {
            let a = points[i].position
            let c = points[i+1].position
            let dx = c.x - a.x
            let dy = c.y - a.y
            let d = max(0.001, sqrt(dx*dx + dy*dy))
            let mid = CGPoint(x: a.x + dx/2, y: a.y + dy/2)
            let N = d + params.scale * 10

            context.stroke(ellipse(center: mid, radius: N), with: .color(stroked), lineWidth: 1)
            context.fill(ellipse(center: mid, radius: N), with: .color(filled))
        }
    }

    func resetState() {}

    private func ellipse(center: CGPoint, radius: CGFloat) -> Path {
        Path(ellipseIn: CGRect(x: center.x-radius, y: center.y-radius,
                               width: radius*2, height: radius*2))
    }
}
