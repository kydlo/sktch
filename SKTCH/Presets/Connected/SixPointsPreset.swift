import SwiftUI

final class SixPointsPreset: Preset {
    let name = "Six Points"
    let category: PresetCategory = .connected

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        guard points.count > 1 else { return }
        let n = params.n
        let s = params.scale
        let primary = Color(red: 1-params.red, green: 1-params.green,
                            blue: 1-params.blue, opacity: params.opacity)
        let secondary = Color(red: max(0, 0.86-params.red),
                              green: max(0, 0.86-params.green),
                              blue: max(0, 0.86-params.blue),
                              opacity: params.opacity)

        let offsets: [(CGFloat, CGFloat)] = [
            (2*n, -4*n), (4*n, 0), (2*n, 4*n),
            (-2*n, 4*n), (-4*n, 0), (-2*n, -4*n)
        ]

        let sat: [[CGPoint]] = offsets.map { (dx, dy) in
            points.map { CGPoint(x: $0.position.x + dx, y: $0.position.y + dy) }
        }

        for i in 1..<points.count {
            for k in 0..<6 {
                let l = Path { p in p.move(to: sat[k][i]); p.addLine(to: sat[k][i-1]) }
                context.stroke(l, with: .color(secondary), lineWidth: s / 4)
            }
            for k in 0..<6 {
                let p = sat[k][i]
                let rect = CGRect(x: p.x - s, y: p.y - s, width: s*4, height: s*4)
                context.fill(Path(rect), with: .color(primary))
            }
        }
    }

    func resetState() {}
}
