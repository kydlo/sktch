import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @ObservedObject var params: DrawingParameters

    var body: some View {
        TimelineView(.animation) { _ in
            Canvas { context, size in
                context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.white))
                for session in viewModel.completedSessions {
                    session.preset.draw(points: session.points, params: params, in: &context, size: size)
                }
                viewModel.activeSession.preset.draw(
                    points: viewModel.activeSession.points, params: params, in: &context, size: size
                )
            }
        }
        .overlay(
            TouchOverlay(
                onTouchDown: { position, force in
                    viewModel.addPoint(DrawingPoint(
                        position: position,
                        timestamp: Date().timeIntervalSinceReferenceDate,
                        force: force
                    ))
                },
                onTouchMoved: { position, force in
                    viewModel.addPoint(DrawingPoint(
                        position: position,
                        timestamp: Date().timeIntervalSinceReferenceDate,
                        force: force
                    ))
                },
                onTouchUp: {
                    viewModel.endStroke()
                }
            )
        )
    }
}
