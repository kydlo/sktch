import SwiftUI

final class Jocabola2Preset: Preset {
    let name = "Jocabola 2"
    let category: PresetCategory = .organic

    private struct Firefly {
        var trail: [CGPoint]
        var vx: CGFloat
        var vy: CGFloat
    }

    private var fireflies: [Firefly] = []

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        while fireflies.count < points.count {
            let pos = points[fireflies.count].position
            fireflies.append(Firefly(
                trail: [pos],
                vx: CGFloat.random(in: -4...4),
                vy: CGFloat.random(in: -4...4)
            ))
        }

        for i in 0..<fireflies.count {
            guard abs(fireflies[i].vx) > 0.1 || abs(fireflies[i].vy) > 0.1 else { continue }
            let last = fireflies[i].trail.last!
            fireflies[i].trail.append(CGPoint(x: last.x + fireflies[i].vx,
                                               y: last.y + fireflies[i].vy))
            fireflies[i].vx *= 0.75
            fireflies[i].vy *= 0.75
        }

        let particleScale = (params.scale - 0.5) / 4.1
        let r = max(1, particleScale * 10)
        let alpha = max(0, params.opacity - 0.04)
        let primary = Color(red: 1-params.red, green: 1-params.green,
                            blue: 1-params.blue, opacity: alpha)
        let secondary = Color(red: min(1, params.red/255 + params.green),
                              green: min(1, params.green/255 + params.blue),
                              blue: min(1, params.blue/255 + params.red),
                              opacity: alpha)

        for (fi, ff) in fireflies.enumerated() {
            for pt in ff.trail {
                let ellipse = Path(ellipseIn: CGRect(x: pt.x-r, y: pt.y-r,
                                                      width: r*2, height: r*2))
                context.fill(ellipse, with: .color(fi == 0 ? primary : secondary))
            }
            if fi > 0, let prev = fireflies[fi-1].trail.first {
                let l = Path { p in p.move(to: prev); p.addLine(to: ff.trail.first!) }
                context.stroke(l, with: .color(secondary), lineWidth: 1)
            }
        }
    }

    func resetState() {
        fireflies.removeAll()
    }
}
