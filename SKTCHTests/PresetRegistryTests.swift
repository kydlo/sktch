import XCTest
@testable import SKTCH

final class PresetRegistryTests: XCTestCase {
    func test_registry_has_16_presets() {
        XCTAssertEqual(PresetRegistry.all.count, 16)
    }

    func test_all_categories_present() {
        let categories = Set(PresetRegistry.all.map(\.category))
        XCTAssertEqual(categories, Set(PresetCategory.allCases))
    }

    func test_names_are_unique() {
        let names = PresetRegistry.all.map(\.name)
        XCTAssertEqual(names.count, Set(names).count)
    }
}
