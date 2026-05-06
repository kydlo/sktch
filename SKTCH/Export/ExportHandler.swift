import SwiftUI
import Photos

@MainActor
final class ExportHandler: ObservableObject {
    @Published var exportedImage: UIImage?
    @Published var showingShareSheet = false
    @Published var showingPermissionAlert = false

    func export(viewModel: CanvasViewModel, params: DrawingParameters, canvasSize: CGSize) async {
        let renderer = ImageRenderer(
            content: CanvasView(viewModel: viewModel, params: params)
                .frame(width: canvasSize.width, height: canvasSize.height)
        )
        renderer.scale = UIScreen.main.scale
        guard let image = renderer.uiImage else { return }
        exportedImage = image
        showingShareSheet = true
    }
}
