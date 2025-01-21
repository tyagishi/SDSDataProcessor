//
//  MassExpressionTerm_Tests.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/01/21.
//

import XCTest
import RegexBuilder
@testable import SDSDataProcessor

final class MassExpressionTerm_Tests: XCTestCase {
    func test_MassExpressionTerm_numeric() async throws {
        let sut = Regex<MathExpressionToken> {
            MathExpressionTerm(locale: .init(identifier: "ja-JP"), variableNames: ["x", "y"])
        }
        
        let simpleMatch = try sut.wholeMatch(in: "12.34")
        var output = try XCTUnwrap(simpleMatch?.output)
        XCTAssertEqual(output, MathExpressionToken.numeric(12.34, "12.34"))

        let plusMatch = try sut.wholeMatch(in: "+12.34")
        output = try XCTUnwrap(plusMatch?.output)
        XCTAssertEqual(output, MathExpressionToken.numeric(12.34, "+12.34"))

        let groupMatch = try sut.wholeMatch(in: "+1,234.5")
        output = try XCTUnwrap(groupMatch?.output)
        XCTAssertEqual(output, MathExpressionToken.numeric(1234.5, "+1,234.5"))
    }

    
    func test_MassExpressionTerm_variable() async throws {
        let sut = Regex<MathExpressionToken> {
            MathExpressionTerm(locale: .init(identifier: "ja-JP"), variableNames: ["x", "y"])
        }
        
        let xMatch = try sut.wholeMatch(in: "x")
        var output = try XCTUnwrap(xMatch?.output)
        XCTAssertEqual(output, MathExpressionToken.variable("x"))

        let yMatch = try sut.wholeMatch(in: "y")
        output = try XCTUnwrap(yMatch?.output)
        XCTAssertEqual(output, MathExpressionToken.variable("y"))

    }
}
