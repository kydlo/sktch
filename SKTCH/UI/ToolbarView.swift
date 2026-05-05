import SwiftUI

struct ToolbarView: View {
    @Binding var showPresets: Bool
    @Binding var showControls: Bool
    let onClear: () -> Void

    var body: some View {
        HStack {
            Spacer()
            toolButton(symbol: "scribble", label: "Draw",
                       isActive: !showPresets && !showControls) {
                showPresets = false; showControls = false
            }
            Spacer()
            toolButton(symbol: "square.grid.2x2", label: "Presets",
                       isActive: showPresets) {
                showPresets.toggle(); showControls = false
            }
            Spacer()
            toolButton(symbol: "slider.horizontal.3", label: "Controls",
                       isActive: showControls) {
                showControls.toggle(); showPresets = false
            }
            Spacer()
            toolButton(symbol: "trash", label: "Clear", isActive: false, action: onClear)
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.bottom, 4)
        .background(.regularMaterial, in: Rectangle())
        .overlay(alignment: .top) { Divider() }
    }

    private func toolButton(symbol: String, label: String,
                            isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: symbol)
                    .font(.system(size: 20))
                    .foregroundColor(isActive ? .accentColor : .secondary)
                Text(label)
                    .font(.caption2)
                    .foregroundColor(isActive ? .accentColor : .secondary)
            }
        }
    }
}
