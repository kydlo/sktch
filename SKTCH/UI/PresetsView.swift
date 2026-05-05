import SwiftUI

struct PresetsView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @Environment(\.dismiss) private var dismiss

    private var byCategory: [(PresetCategory, [Preset])] {
        PresetCategory.allCases.compactMap { cat in
            let presets = PresetRegistry.all.filter { $0.category == cat }
            return presets.isEmpty ? nil : (cat, presets)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(byCategory, id: \.0) { (category, presets) in
                    Section(category.rawValue) {
                        ForEach(presets, id: \.name) { preset in
                            Button {
                                viewModel.setPreset(preset)
                                dismiss()
                            } label: {
                                HStack {
                                    Text(preset.name)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if viewModel.activePreset.name == preset.name {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Presets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
