import XCTest
@testable import SKTCH

final class CanvasViewModelTests: XCTestCase {
    func test_addPoint_appendsToActiveSession() {
        let vm = CanvasViewModel()
        vm.addPoint(DrawingPoint(position: .init(x: 10, y: 20), timestamp: 0, force: 1))
        XCTAssertEqual(vm.activeSession.points.count, 1)
        XCTAssertEqual(vm.activeSession.points[0].position.x, 10)
    }

    func test_clear_removesAllPoints() {
        let vm = CanvasViewModel()
        vm.addPoint(DrawingPoint(position: .zero, timestamp: 0, force: 1))
        vm.clear()
        XCTAssertTrue(vm.activeSession.points.isEmpty)
        XCTAssertTrue(vm.completedSessions.isEmpty)
    }

    func test_undo_removesLastStroke() {
        let vm = CanvasViewModel()
        vm.addPoint(DrawingPoint(position: .init(x: 1, y: 1), timestamp: 0, force: 1))
        vm.endStroke()
        vm.addPoint(DrawingPoint(position: .init(x: 2, y: 2), timestamp: 0, force: 1))
        vm.endStroke()
        vm.undo()
        XCTAssertEqual(vm.activeSession.points.count, 1)
    }

    func test_initialPreset_isSquare() {
        let vm = CanvasViewModel()
        XCTAssertEqual(vm.activePreset.name, "Square")
    }

    func test_setPreset_preservesDrawnStrokes() {
        let vm = CanvasViewModel()
        vm.addPoint(DrawingPoint(position: .zero, timestamp: 0, force: 1))
        vm.endStroke()
        vm.setPreset(PresetRegistry.all[1]) // Circle
        XCTAssertEqual(vm.completedSessions.count, 1)
        XCTAssertEqual(vm.completedSessions[0].points.count, 1)
        XCTAssertEqual(vm.activePreset.name, "Circle")
    }

    func test_setPreset_withNoStrokes_doesNotCreateEmptySession() {
        let vm = CanvasViewModel()
        vm.setPreset(PresetRegistry.all[1]) // Switch without drawing anything
        XCTAssertTrue(vm.completedSessions.isEmpty)
    }

    func test_undo_acrossPresetSessions() {
        let vm = CanvasViewModel()
        vm.addPoint(DrawingPoint(position: .zero, timestamp: 0, force: 1))
        vm.endStroke()
        vm.setPreset(PresetRegistry.all[1]) // Circle — seals session 1
        vm.undo() // Should pop back to the completed session
        XCTAssertTrue(vm.completedSessions.isEmpty)
        XCTAssertEqual(vm.activeSession.points.count, 1)
    }
}
