//
//  SwiftDemanglerTest.swift
//  SwiftDemanglerTests
//
//  Created by Yuki Takahashi on 2018/12/08.
//

import XCTest
@testable import SwiftDemangler

class SwiftDemanglerTest: XCTestCase {
    func testIsSwiftSymbol() {
        XCTAssertTrue(isSwiftSymbol(name: "$S13ExampleNumber6isEven6numberSbSi_tF"))
        XCTAssertFalse(isSwiftSymbol(name: "ABCDEFG"))
    }
    
    func testIsFunctionEntitySpec() {
        XCTAssertTrue(isFunctionEntitySpec(name: "$S13ExampleNumber6isEven6numberSbSi_tF"))
        XCTAssertFalse(isFunctionEntitySpec(name: "ABCDEFG"))
    }
}
