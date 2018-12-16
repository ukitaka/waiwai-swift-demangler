//
//  ParserTests.swift
//  SwiftDemanglerTests
//
//  Created by ukitaka on 2018/12/16.
//

import XCTest
@testable import SwiftDemangler

class ParserTest: XCTestCase {
    func testParseInt() {
        var parser = Parser(name: "0")
        XCTAssertEqual(parser.parseInt(), 0)
        XCTAssertEqual(parser.remains, "")
        parser = Parser(name: "1")
        XCTAssertEqual(parser.parseInt(), 1)
        XCTAssertEqual(parser.remains, "")
        parser = Parser(name: "12")
        XCTAssertEqual(parser.parseInt(), 12)
        XCTAssertEqual(parser.remains, "")
        parser = Parser(name: "12A")
        XCTAssertEqual(parser.parseInt(), 12)
        XCTAssertEqual(parser.remains, "A")
        parser = Parser(name: "1B2A")
        XCTAssertEqual(parser.parseInt(), 1)
        XCTAssertEqual(parser.remains, "B2A")
        XCTAssertEqual(parser.parseInt(), nil)
    }
    
    func testParseIdentifierWithLength() {
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
    
    func testParseKnownType() {
        XCTAssertEqual(Parser(name: "Si").parseKnownType(), .int)
        XCTAssertEqual(Parser(name: "Sb").parseKnownType(), .bool)
        XCTAssertEqual(Parser(name: "SS").parseKnownType(), .string)
        XCTAssertEqual(Parser(name: "Sf").parseKnownType(), .float)
    }
    
    func testParseType() {
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
}
