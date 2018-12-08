//
//  SquareTest.swift
//  SwiftDemanglerTests
//
//  Created by Yuki Takahashi on 2018/12/08.
//

import XCTest
import SwiftDemangler

class SquareTest: XCTestCase {
    func testSquare() {
        XCTAssertEqual(demangle(name: "$S13ExampleSquare6square1nS2i_tF"),
                       "ExampleSquare.square(n: Swift.Int) -> Swift.Int")
    }
}
