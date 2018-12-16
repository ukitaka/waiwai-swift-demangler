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
    
    struct Const {
        struct Step1 {
            static let mangled = "$S13ExampleNumber6isEven6numberSbSi_tF"
            static let noPrefixMangled = "13ExampleNumber6isEven6numberSbSi_tF"
        }
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
        let parser = Parser(name: Const.Step1.mangled)
        let _ = parser.parsePrefix()
        XCTAssertEqual(parser.remains, "13ExampleNumber6isEven6numberSbSi_tF")
        XCTAssertEqual(parser.parseModule(), "ExampleNumber")
    }
    
    func testParseDeclName() {
        let parser = Parser(name: Const.Step1.mangled)
        let _ = parser.parsePrefix()
        XCTAssertEqual(parser.remains, "13ExampleNumber6isEven6numberSbSi_tF")
        XCTAssertEqual(parser.parseModule(), "ExampleNumber")
        XCTAssertEqual(parser.parseDeclName(), "isEven")
    }
    
    func testParseLabelList() {
        let parser = Parser(name: Const.Step1.mangled)
        let _ = parser.parsePrefix()
        XCTAssertEqual(parser.remains, "13ExampleNumber6isEven6numberSbSi_tF")
        XCTAssertEqual(parser.parseModule(), "ExampleNumber")
        XCTAssertEqual(parser.parseDeclName(), "isEven")
        XCTAssertEqual(parser.parseLabelList(), ["number"])
    }
    
    func testParseKnownType() {
        XCTAssertEqual(Parser(name: "Si").parseKnownType(), Type.int)
        XCTAssertEqual(Parser(name: "Sb").parseKnownType(), Type.bool)
        XCTAssertEqual(Parser(name: "SS").parseKnownType(), Type.string)
        XCTAssertEqual(Parser(name: "Sf").parseKnownType(), Type.float)//        XCTAssertEqual(Parser(name: "Sf_SfSft").parseKnownType(), .list([.float, .float, .float]))
        
        
        XCTAssertEqual(Parser(name: "Si").parseType(), .int)
        XCTAssertEqual(Parser(name: "Sb").parseType(), .bool)
        XCTAssertEqual(Parser(name: "SS").parseType(), .string)
        XCTAssertEqual(Parser(name: "Sf").parseType(), .float)
        XCTAssertEqual(Parser(name: "Sf_SfSft").parseType(), .list([.float, .float, .float]))

    }
    
    func testParseFunctionSignature() {
        XCTAssertEqual(Parser(name: "SbSi_t").parseFunctionSignature(), FunctionSignature(returnType: .bool, argsType: .list([.int])))

    }
    
    func testParseFunctionEntity() {
        let sig = FunctionSignature(returnType: .bool, argsType: .list([.int]))
        XCTAssertEqual(Parser(name: "13ExampleNumber6isEven6numberSbSi_tF").parseFunctionEntity(),
                       FunctionEntity(module: "ExampleNumber", declName: "isEven", labelList: ["number"], functionSignature: sig))
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
