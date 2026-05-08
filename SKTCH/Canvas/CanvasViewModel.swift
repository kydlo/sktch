import SwiftUI
import Combine

struct PresetSession {
    let preset: any Preset
    var points: [DrawingPoint] = []
    var strokeBoundaries: [Int] = []
}

final class CanvasViewModel: ObservableObject {
    @Published var completedSessions: [PresetSession] = []
    @Published var activeSession: PresetSession

    init() {
        activeSession = PresetSession(preset: PresetRegistry.makeFresh(like: PresetRegistry.all[0]))
    }

    var activePreset: any Preset { activeSession.preset }

    func addPoint(_ point: DrawingPoint) {
        activeSession.points.append(point)
    }

    func endStroke() {
        let lastBoundary = activeSession.strokeBoundaries.last ?? 0
        guard activeSession.points.count > lastBoundary else { return }
        activeSession.strokeBoundaries.append(activeSession.points.count)
    }

    func undo() {
        guard let lastBoundary = activeSession.strokeBoundaries.popLast() else {
            if !completedSessions.isEmpty {
                activeSession = completedSessions.removeLast()
            }
            return
        }
        let previousBoundary = activeSession.strokeBoundaries.last ?? 0
        activeSession.points.removeSubrange(previousBoundary..<lastBoundary)
        activeSession.preset.resetState()
    }

    func setPreset(_ preset: any Preset) {
        if !activeSession.points.isEmpty {
            completedSessions.append(activeSession)
        }
        activeSession = PresetSession(preset: PresetRegistry.makeFresh(like: preset))
    }

    func clear() {
        completedSessions.removeAll()
        activeSession = PresetSession(preset: PresetRegistry.makeFresh(like: activeSession.preset))
    }
}
