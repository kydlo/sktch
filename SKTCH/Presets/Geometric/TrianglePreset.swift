import SwiftUI

final class TrianglePreset: Preset {
    let name = "Triangle"
    let category: PresetCategory = .geometric

    private var driftedPositions: [CGPoint] = []

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        guard points.count >= 3 else { return }

        while driftedPositions.count < points.count {
            driftedPositions.append(points[driftedPositions.count].position)
        }

        let driftRange = params.scale * 4
        for i in 0..<driftedPositions.count {
            driftedPositions[i].x += CGFloat.random(in: -driftRange...driftRange)
            driftedPositions[i].y += CGFloat.random(in: -driftRange...driftRange)
        }

        let filled = Color(red: 1-params.red, green: 1-params.green,
                           blue: 1-params.blue, opacity: max(0, params.opacity - 0.04))
        let stroked = Color(red: 1-params.red, green: 1-params.green,
                            blue: 1-params.blue, opacity: min(1, params.opacity * 3))

        for i in stride(from: 3, to: driftedPositions.count, by: 1) {
            let tri = triangle(driftedPositions[i], driftedPositions[i-1], driftedPositions[i-2])
            context.fill(tri, with: .color(filled))
            context.stroke(tri, with: .color(stroked), lineWidth: 1)
        }
    }

    func resetState() {
        driftedPositions.removeAll()
    }

    private func triangle(_ a: CGPoint, _ b: CGPoint, _ c: CGPoint) -> Path {
        Path { p in
            p.move(to: a); p.addLine(to: b); p.addLine(to: c); p.closeSubpath()
        }
    }
}
