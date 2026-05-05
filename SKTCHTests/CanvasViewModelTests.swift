import XCTest
@testable import SKTCH

final class CanvasViewModelTests: XCTestCase {
    func test_addPoint_appendsToArray() {
        let vm = CanvasViewModel()
        vm.addPoint(DrawingPoint(position: .init(x: 10, y: 20), timestamp: 0, force: 1))
        XCTAssertEqual(vm.points.count, 1)
        XCTAssertEqual(vm.points[0].position.x, 10)
    }

    func test_clear_removesAllPoints() {
        let vm = CanvasViewModel()
        vm.addPoint(DrawingPoint(position: .zero, timestamp: 0, force: 1))
        vm.clear()
        XCTAssertTrue(vm.points.isEmpty)
    }

    func test_undo_removesLastStroke() {
        let vm = CanvasViewModel()
        vm.addPoint(DrawingPoint(position: .init(x: 1, y: 1), timestamp: 0, force: 1))
        vm.endStroke()
        vm.addPoint(DrawingPoint(position: .init(x: 2, y: 2), timestamp: 0, force: 1))
        vm.endStroke()
        vm.undo()
        XCTAssertEqual(vm.points.count, 1)
    }

    func test_initialPreset_isSquare() {
        let vm = CanvasViewModel()
        XCTAssertEqual(vm.activePreset.name, "Square")
    }
}
