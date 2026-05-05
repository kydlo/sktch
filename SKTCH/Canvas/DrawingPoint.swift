import CoreGraphics
import Foundation

struct DrawingPoint {
    let position: CGPoint
    let timestamp: TimeInterval
    let force: CGFloat   // 0–1; falls back to 1.0 on non-Force Touch hardware
}
