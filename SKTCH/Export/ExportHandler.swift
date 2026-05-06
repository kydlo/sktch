import SwiftUI
import Photos

@MainActor
final class ExportHandler: ObservableObject {
    @Published var exportedImage: UIImage?
    @Published var showingShareSheet = false

    func export(viewModel: CanvasViewModel, params: DrawingParameters, canvasSize: CGSize) async {
        guard canvasSize.width > 0, canvasSize.height > 0 else { return }
        let renderer = ImageRenderer(
            content: CanvasView(viewModel: viewModel, params: params)
                .frame(width: canvasSize.width, height: canvasSize.height)
        )
        renderer.scale = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.screen.scale ?? 3.0
        guard let image = renderer.uiImage else { return }
        exportedImage = image
        showingShareSheet = true
    }
}
