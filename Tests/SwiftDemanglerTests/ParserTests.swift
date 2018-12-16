//
//  ParserTests.swift
//  SwiftDemanglerTests
//
//  Created by Yudai.Hirose on 2018/12/16.
//

import XCTest
@testable import SwiftDemangler

class ParserTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParseInt() {
        var parser = Parser(name: "0")
//
//        // 0
        XCTAssertEqual(parser.parseInt(), 0)
        XCTAssertEqual(parser.remains, "")

        // 1
        parser = Parser(name: "1")
        XCTAssertEqual(parser.parseInt(), 1)
        XCTAssertEqual(parser.remains, "")

        // 12
        parser = Parser(name: "12")
        XCTAssertEqual(parser.parseInt(), 12)
        XCTAssertEqual(parser.remains, "")

        // 12
        parser = Parser(name: "12A")
        XCTAssertEqual(parser.parseInt(), 12)
        XCTAssertEqual(parser.remains, "A")

        // 1
        parser = Parser(name: "1B2A")
        XCTAssertEqual(parser.parseInt(), 1)
        XCTAssertEqual(parser.remains, "B2A")
        XCTAssertEqual(parser.parseInt(), nil)
    }
    
    func testParseIdentifierLenght() {
        let parser = Parser(name: "3ABC4DEFG")
        
        XCTAssertEqual(parser.parseInt(), 3)
        XCTAssertEqual(parser.remains, "ABC4DEFG")
        XCTAssertEqual(parser.parseIdentifier(length: 3), "ABC")
        XCTAssertEqual(parser.remains, "4DEFG")
        
        XCTAssertEqual(parser.parseInt(), 4)
        XCTAssertEqual(parser.remains, "DEFG")
        XCTAssertEqual(parser.parseIdentifier(length: 4), "DEFG")
    }
    
    func testParseIdentifier() {
        let parser = Parser(name: "3ABC4DEFG")
        XCTAssertEqual(parser.parseIdentifier(), "ABC")
        XCTAssertEqual(parser.remains, "4DEFG")
        XCTAssertEqual(parser.parseIdentifier(), "DEFG")
    }
    
    func testParsePrefixAndParseModule() {
        let parser = Parser(name: "$S13ExampleNumber6isEven6numberSbSi_tF")
        let _ = parser.parsePrefix()
        XCTAssertEqual(parser.remains, "13ExampleNumber6isEven6numberSbSi_tF")
        XCTAssertEqual(parser.parseModule(), "ExampleNumber")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
