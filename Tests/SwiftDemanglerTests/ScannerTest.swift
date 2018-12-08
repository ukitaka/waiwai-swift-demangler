//
//  ScannerTest.swift
//  SwiftDemanglerTests
//
//  Created by Yuki Takahashi on 2018/12/08.
//

import XCTest
@testable import SwiftDemangler

class ScannerTest: XCTestCase {
    func testNextInt() {
        var scanner = Scanner(name: "0")
        XCTAssertEqual(scanner.nextInt(), 0)
        XCTAssertEqual(scanner.remains, "")
        scanner = Scanner(name: "1")
        XCTAssertEqual(scanner.nextInt(), 1)
        XCTAssertEqual(scanner.remains, "")
        scanner = Scanner(name: "12")
        XCTAssertEqual(scanner.nextInt(), 12)
        XCTAssertEqual(scanner.remains, "")
        scanner = Scanner(name: "12A")
        XCTAssertEqual(scanner.nextInt(), 12)
        XCTAssertEqual(scanner.remains, "A")
        scanner = Scanner(name: "1B2A")
        XCTAssertEqual(scanner.nextInt(), 1)
        XCTAssertEqual(scanner.remains, "B2A")
        XCTAssertEqual(scanner.nextInt(), nil)
    }

    func testNextIdentifier() {
        let scanner = Scanner(name: "3ABC4DEFG")
        XCTAssertEqual(scanner.nextInt(), 3)
        XCTAssertEqual(scanner.remains, "ABC4DEFG")
        XCTAssertEqual(scanner.nextIdentifier(length: 3), "ABC")
        XCTAssertEqual(scanner.remains, "4DEFG")
        XCTAssertEqual(scanner.nextInt(), 4)
        XCTAssertEqual(scanner.remains, "DEFG")
        XCTAssertEqual(scanner.nextIdentifier(length: 4), "DEFG")
    }
}
