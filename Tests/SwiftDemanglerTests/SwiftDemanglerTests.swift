import XCTest
@testable import SwiftDemangler

final class SwiftDemanglerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftDemangler().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
