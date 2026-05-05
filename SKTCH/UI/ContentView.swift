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

// MARK: - Stubs (replaced in Tasks 8, 9, 10)

private struct ShareButton: View {
    let viewModel: CanvasViewModel
    let params: DrawingParameters
    let canvasSize: CGSize
    var body: some View {
        Image(systemName: "square.and.arrow.up").foregroundColor(.secondary)
    }
}

struct PresetsView: View {
    let viewModel: CanvasViewModel
    var body: some View { Text("Presets — coming in Task 8") }
}

struct ControlsSheet: View {
    let params: DrawingParameters
    let presetName: String
    var body: some View { Text("Controls — coming in Task 9") }
}
