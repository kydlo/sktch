import SwiftUI

final class PhasePreset: Preset {
    let name = "Phase"
    let category: PresetCategory = .organic

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        guard points.count > 2 else { return }
        let color = Color(red: max(0, 0.5-params.red),
                          green: max(0, 0.5-params.green),
                          blue: max(0, 0.5-params.blue),
                          opacity: min(1, params.opacity + 0.39))
        let dist = params.scale * 10.0
        let phases: [Double] = [.pi * 0.25, .pi * 0.5, .pi * 1.5, .pi]

        for i in 2..<points.count {
            let d = hypot(points[i].position.x - points[i-1].position.x,
                          points[i].position.y - points[i-1].position.y)
            guard d < 50 else { continue }

            for ph in phases {
                let phase = Double(i) * 0.2 + ph
                let p = offsetPoint(points[i].position, phase: phase, dist: dist)
                let p2 = offsetPoint(points[i-1].position, phase: phase - 0.2, dist: dist)
                let l = Path { path in path.move(to: p); path.addLine(to: p2) }
                context.stroke(l, with: .color(color), lineWidth: 1)
            }
        }
    }

    func resetState() {}

    private func offsetPoint(_ base: CGPoint, phase: Double, dist: CGFloat) -> CGPoint {
        CGPoint(
            x: base.x + CGFloat(sin(phase) * 0.5 * Double(dist) * sin(phase)),
            y: base.y + CGFloat(cos(phase) * 0.5 * Double(dist) * cos(phase))
        )
    }
}
