import SwiftUI

final class CirclePreset: Preset {
    let name = "Circle"
    let category: PresetCategory = .geometric

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        guard points.count > 1 else { return }
        let primary = Color(red: 1-params.red, green: 1-params.green,
                            blue: 1-params.blue, opacity: params.opacity)
        let secondary = Color(red: max(0, 0.2-params.red),
                              green: max(0, 0.2-params.green),
                              blue: max(0, 0.2-params.blue),
                              opacity: params.opacity)
        for i in 1..<points.count {
            let p = points[i].position
            let bigR = params.scale * 10
            let smallR = params.scale
            context.fill(ellipse(center: p, radius: bigR), with: .color(primary))
            context.fill(ellipse(center: p, radius: smallR), with: .color(secondary))
            context.stroke(ellipse(center: p, radius: bigR), with: .color(primary), lineWidth: 1)
        }
    }

    func resetState() {}

    private func ellipse(center: CGPoint, radius: CGFloat) -> Path {
        Path(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius,
                               width: radius * 2, height: radius * 2))
    }
}
