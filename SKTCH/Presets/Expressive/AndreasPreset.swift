import SwiftUI

final class AndreasPreset: Preset {
    let name = "Andreas"
    let category: PresetCategory = .expressive

    private let text = "You cannot do much about the length of your life, but you can do a lot about its depth and width. "

    func draw(points: [DrawingPoint], params: DrawingParameters,
              in context: inout GraphicsContext, size: CGSize) {
        guard points.count > 1 else { return }
        let color = Color(red: max(0, 0.86-params.red),
                          green: max(0, 0.86-params.green),
                          blue: max(0, 0.86-params.blue),
                          opacity: params.opacity)
        let chars = Array(text)
        var textIndex = 0
        let spacing = params.n * 10.0

        for i in 0..<(points.count - 1) {
            let a = points[i].position
            let b = points[i+1].position
            let dx = a.x - b.x
            let dy = a.y - b.y
            let segLen = sqrt(dx*dx + dy*dy)
            let angle = atan2(dy, dx) - .pi
            let steps = max(1, Int(segLen / spacing))
            let stepX = -dx / CGFloat(steps)
            let stepY = -dy / CGFloat(steps)

            for j in 0..<steps {
                let char = String(chars[textIndex % chars.count])
                textIndex += 1
                let pos = CGPoint(x: a.x + CGFloat(j)*stepX,
                                  y: a.y + CGFloat(j)*stepY)
                var charContext = context
                charContext.translateBy(x: pos.x, y: pos.y)
                charContext.rotate(by: .radians(Double(angle)))
                charContext.draw(
                    Text(char).font(.system(size: 10)).foregroundColor(color),
                    at: .zero
                )
            }
        }
    }

    func resetState() {}
}
