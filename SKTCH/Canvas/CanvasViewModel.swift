import SwiftUI
import Combine

final class CanvasViewModel: ObservableObject {
    @Published var points: [DrawingPoint] = []
    @Published var activePreset: Preset = PresetRegistry.all[0]

    private var strokeBoundaries: [Int] = []

    func addPoint(_ point: DrawingPoint) {
        points.append(point)
    }

    func endStroke() {
        if !points.isEmpty {
            strokeBoundaries.append(points.count)
        }
    }

    func undo() {
        guard let boundary = strokeBoundaries.popLast() else { return }
        let previousBoundary = strokeBoundaries.last ?? 0
        points.removeSubrange(previousBoundary..<boundary)
        activePreset.resetState()
    }

    func clear() {
        points.removeAll()
        strokeBoundaries.removeAll()
        activePreset.resetState()
    }

    func setPreset(_ preset: Preset) {
        activePreset = preset
        clear()
    }
}
