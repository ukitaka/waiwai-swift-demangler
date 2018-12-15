import XCTest
@testable import SwiftDemangler

final class SwiftDemanglerTests: XCTestCase {
    func testEx1() {
        XCTAssertEqual(demangle(name: "$S13ExampleNumber6isEven6numberSbSi_tF"),
                       "ExampleNumber.isEven(number: Swift.Int) -> Swift.Bool")
    }


    static var allTests = [
        ("testEx1", testEx1),
    ]
}
