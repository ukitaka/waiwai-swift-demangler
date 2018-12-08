import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(waiwai_swift_demanglerTests.allTests),
    ]
}
#endif