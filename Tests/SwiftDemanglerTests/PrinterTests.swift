//
//  PrinterTests.swift
//  SwiftDemanglerTests
//
//  Created by Yudai.Hirose on 2018/12/16.
//

import XCTest
@testable import SwiftDemangler

class PrinterTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPrinter() {
        let printer = Printer(parser: Parser(name: "$S13ExampleNumber6isEven6numberSbSi_tF"))
        XCTAssertEqual(printer.output(), "$S13ExampleNumber6isEven6numberSbSi_tF ---> ExampleNumber.isEven(number: Swift.Int) -> Swift.Bool")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
