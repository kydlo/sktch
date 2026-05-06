import SwiftUI

struct ControlsSheet: View {
    @ObservedObject var params: DrawingParameters
    let presetName: String

    private let swatches: [(Color, Double, Double, Double)] = [
        (.blue,   0.0, 0.0, 1.0),
        (.orange, 1.0, 0.6, 0.0),
        (.red,    1.0, 0.0, 0.0),
        (.green,  0.0, 0.8, 0.2),
        (.purple, 0.5, 0.0, 0.8),
        (.pink,   1.0, 0.2, 0.4),
        (.black,  0.0, 0.0, 0.0),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(presetName)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .overlay(alignment: .bottom) { Divider() }

            ScrollView {
                VStack(spacing: 0) {
                    paramSlider(label: "Scale", value: $params.scale, range: 0.1...3.0)
                    Divider().padding(.leading)
                    paramSlider(label: "Opacity", value: $params.opacity, range: 0...1)
                    Divider().padding(.leading)

                    HStack(spacing: 12) {
                        Text("Color")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(width: 60, alignment: .leading)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(swatches, id: \.0) { (color, r, g, b) in
                                    Circle()
                                        .fill(color)
                                        .frame(width: 28, height: 28)
                                        .overlay {
                                            if isSelected(r: r, g: g, b: b) {
                                                Circle()
                                                    .stroke(Color.accentColor, lineWidth: 2.5)
                                                    .padding(-3)
                                            }
                                        }
                                        .onTapGesture {
                                            params.red = r
                                            params.green = g
                                            params.blue = b
                                        }
                                }
                            }
                            .padding(.horizontal, 2)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    Divider().padding(.leading)
                    paramSlider(label: "R", value: $params.red, range: 0...1, tint: .red)
                    Divider().padding(.leading)
                    paramSlider(label: "G", value: $params.green, range: 0...1, tint: .green)
                    Divider().padding(.leading)
                    paramSlider(label: "B", value: $params.blue, range: 0...1, tint: .blue)
                }
            }
        }
    }

    private func paramSlider(label: String, value: Binding<Double>,
                              range: ClosedRange<Double>,
                              tint: Color = .accentColor) -> some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .leading)
            Slider(value: value, in: range)
                .tint(tint)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private func isSelected(r: Double, g: Double, b: Double) -> Bool {
        abs(params.red - r) < 0.01 &&
        abs(params.green - g) < 0.01 &&
        abs(params.blue - b) < 0.01
    }
}
