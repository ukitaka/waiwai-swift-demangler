import XCTest
@testable import waiwai_swift_demangler

final class waiwai_swift_demanglerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(waiwai_swift_demangler().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
