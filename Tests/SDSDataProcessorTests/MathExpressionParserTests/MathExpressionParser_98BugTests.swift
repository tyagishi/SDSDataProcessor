//
//  MathExpressionParser_98BugTests.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2024/12/16.
//

import XCTest
@testable import SDSDataProcessor

final class MathExpressionParser_98BugTests: XCTestCase {

    func test_BugAt20241216_0() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("22931 * 20 / (90 - 20 * 1.021)"))
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 6591.262, accuracy: 0.001)
    }

    func test_BugAt20241216_1() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("90 - 20 * 1.021"))
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 69.58, accuracy: 0.001)
    }

}
