import SwiftUI
import UIKit

struct TouchOverlay: UIViewRepresentable {
    let onTouchDown: (CGPoint, CGFloat) -> Void
    let onTouchMoved: (CGPoint, CGFloat) -> Void
    let onTouchUp: () -> Void

    func makeUIView(context: Context) -> _TouchView {
        let view = _TouchView()
        view.onTouchDown = onTouchDown
        view.onTouchMoved = onTouchMoved
        view.onTouchUp = onTouchUp
        view.backgroundColor = .clear
        view.isMultipleTouchEnabled = true
        return view
    }

    func updateUIView(_ uiView: _TouchView, context: Context) {}

    class _TouchView: UIView {
        var onTouchDown: ((CGPoint, CGFloat) -> Void)?
        var onTouchMoved: ((CGPoint, CGFloat) -> Void)?
        var onTouchUp: (() -> Void)?

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            touches.forEach { t in
                let force = t.maximumPossibleForce > 0 ? t.force / t.maximumPossibleForce : 1.0
                onTouchDown?(t.location(in: self), force)
            }
        }

        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            touches.forEach { t in
                let force = t.maximumPossibleForce > 0 ? t.force / t.maximumPossibleForce : 1.0
                onTouchMoved?(t.location(in: self), force)
            }
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            onTouchUp?()
        }

        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            onTouchUp?()
        }
    }
}
