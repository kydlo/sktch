import XCTest
@testable import SKTCH

final class DrawingParametersTests: XCTestCase {
    func test_defaults() {
        let p = DrawingParameters()
        XCTAssertEqual(p.scale, 1.0)
        XCTAssertEqual(p.opacity, 1.0)
        XCTAssertEqual(p.red, 0.0)
        XCTAssertEqual(p.green, 0.5)
        XCTAssertEqual(p.blue, 1.0)
    }

    func test_n_is_scale_times_ten() {
        let p = DrawingParameters()
        p.scale = 2.0
        XCTAssertEqual(p.n, 20.0)
    }
}
