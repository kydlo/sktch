import SwiftUI

final class KiebitzPreset: Preset {
    let name = "Kiebitz"
    let category: PresetCategory = .connected

    private static let maxDepth = 4
    private static let tail = 30

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        guard points.count > 1 else { return }

        var lastAngle: CGFloat = 0
        let startIndex = max(0, points.count - Self.tail)

        for i in startIndex..<points.count {
            guard i > 0 else { continue }
            let p = points[i].position
            let pp = CGPoint(x: points[i-1].position.x - p.x,
                             y: points[i-1].position.y - p.y)
            let angle = atan2(pp.y, pp.x)
            lastAngle += (angle - lastAngle) * params.n / 7.0

            let alpha = CGFloat(i - startIndex) / CGFloat(Self.tail)
            recurse(from: p, angle: lastAngle, depth: 0,
                    alpha: alpha, params: params, in: &context, size: size)
        }
    }

    func resetState() {}

    private func recurse(from p: CGPoint, angle: CGFloat, depth: Int,
                         alpha: CGFloat, params: DrawingParameters,
                         in context: inout GraphicsContext, size: CGSize) {
        guard depth < Self.maxDepth else { return }

        let fac = lerp(from: 0.1, to: 0.6,
                       t: CGFloat(Self.maxDepth - depth) / CGFloat(Self.maxDepth))
        let noiseVal = noise(p.x / max(1, size.width))
        let s = fac * params.scale * 90 + noiseVal * 30
        let branches = depth == 0 ? 1 : (Int(noise(p.x / max(1, size.width),
                                                    p.y / max(1, size.height)) + 0.1) + 1)
        let baseAlpha = lerp(from: 250/255.0, to: 90/255.0,
                             t: CGFloat(depth) / CGFloat(Self.maxDepth - 1))
        let color = Color(red: 1-params.red, green: 1-params.green,
                          blue: 1-params.blue,
                          opacity: Double(baseAlpha * alpha) * params.opacity)

        for i in 0..<branches {
            let t = branches == 1 ? 0.5 : CGFloat(i) / CGFloat(branches)
            let ang = lerp(from: angle + .pi/2, to: angle - .pi/2, t: t)
            let p2 = CGPoint(x: p.x + CoreFoundation.cos(ang) * s, y: p.y + CoreFoundation.sin(ang) * s)
            let branch = Path { path in path.move(to: p); path.addLine(to: p2) }
            context.stroke(branch, with: .color(color), lineWidth: 1)
            recurse(from: p2, angle: ang, depth: depth + 1,
                    alpha: alpha, params: params, in: &context, size: size)
        }
    }

    private func noise(_ x: CGFloat, _ y: CGFloat = 0) -> CGFloat {
        let v = sin(x * 127.1 + y * 311.7) * 43758.5453123
        return v - floor(v)
    }

    private func lerp(from a: CGFloat, to b: CGFloat, t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }
}
