//
//  ScannerTest.swift
//  SwiftDemanglerTests
//
//  Created by Yuki Takahashi on 2018/12/08.
//

import XCTest
@testable import SwiftDemangler

class ScannerTest: XCTestCase {
    func testScanner() {
        var scanner = Scanner(name: "0")
        XCTAssertEqual(scanner.nextInt(), 0)
        scanner = Scanner(name: "1")
        XCTAssertEqual(scanner.nextInt(), 1)
        scanner = Scanner(name: "12")
        XCTAssertEqual(scanner.nextInt(), 12)
        scanner = Scanner(name: "12A")
        XCTAssertEqual(scanner.nextInt(), 12)
        scanner = Scanner(name: "1B2A")
        XCTAssertEqual(scanner.nextInt(), 1)
    }
}
