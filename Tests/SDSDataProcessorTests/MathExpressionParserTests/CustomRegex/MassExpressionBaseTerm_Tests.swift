//
//  MassExpressionNumericTerm_Tests.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/01/16.
//

import XCTest
import RegexBuilder

@testable import SDSDataProcessor

final class MassExpressionBaseTerm_Tests: XCTestCase {

    func test_MathExpressionNumericTerm() async throws {
        let sut = Regex<MathExpressionToken> {
            MathExpressionNumericTerm(locale: .init(identifier: "ja-JP"))
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
    
    func test_MathExpressionVariableTerm() async throws {
        let sut = Regex {
            MathExpressionVariableTerm(variableNames: ["x", "y"])
        }
        
        let simpleMatch = try sut.wholeMatch(in: "x")
        var output = try XCTUnwrap(simpleMatch?.output)
        XCTAssertEqual(output, "x")

        let anotherMatch = try sut.wholeMatch(in: "y")
        output = try XCTUnwrap(anotherMatch?.output)
        XCTAssertEqual(output, "y")

        let unkownMatch = try sut.wholeMatch(in: "z")
        XCTAssertNil(unkownMatch)
    }
}
