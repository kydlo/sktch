import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: CanvasViewModel
    @EnvironmentObject var params: DrawingParameters
    @State private var showPresets = false
    @State private var showControls = false
    @State private var canvasSize: CGSize = .zero

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                GeometryReader { geo in
                    CanvasView(viewModel: viewModel, params: params)
                        .onAppear { canvasSize = geo.size }
                        .onChange(of: geo.size) { _, newSize in canvasSize = newSize }
                }
                ToolbarView(
                    showPresets: $showPresets,
                    showControls: $showControls,
                    onClear: { viewModel.clear() }
                )
            }
            .navigationTitle("SKTCH")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { viewModel.undo() } label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ShareButton(viewModel: viewModel, params: params, canvasSize: canvasSize)
                }
            }
        }
        .sheet(isPresented: $showPresets) {
            PresetsView(viewModel: viewModel)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showControls) {
            ControlsSheet(params: params, presetName: viewModel.activePreset.name)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

private struct ShareButton: View {
    let viewModel: CanvasViewModel
    let params: DrawingParameters
    let canvasSize: CGSize
    @StateObject private var handler = ExportHandler()

    var body: some View {
        Button {
            Task { await handler.export(viewModel: viewModel, params: params, canvasSize: canvasSize) }
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
        .sheet(isPresented: $handler.showingShareSheet) {
            if let image = handler.exportedImage {
                ShareSheet(image: image)
            }
        }
        .alert("Photos Access Required", isPresented: $handler.showingPermissionAlert) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Allow SKTCH to save photos in Settings.")
        }
    }
}

private struct ShareSheet: UIViewControllerRepresentable {
    let image: UIImage

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [image], applicationActivities: nil)
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
