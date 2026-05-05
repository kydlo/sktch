import SwiftUI

final class MeshPreset: Preset {
    let name = "Mesh"
    let category: PresetCategory = .geometric

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        guard points.count > 2 else { return }
        let n = max(1, Int(params.n))
        let color = Color(red: 1-params.red, green: 1-params.green,
                          blue: 1-params.blue, opacity: params.opacity)

        for i in (2*n)..<points.count {
            let tri = Path { p in
                p.move(to: points[i].position)
                p.addLine(to: points[i-n].position)
                p.addLine(to: points[i-2*n].position)
                p.closeSubpath()
            }
            context.stroke(tri, with: .color(color), lineWidth: params.scale / 3)
        }
    }

    func resetState() {}
}
