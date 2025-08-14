//
//  51MEExpressionParserError_Tests.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/08/14.
//

import XCTest
@testable import SDSDataProcessor

final class _51MEExpressionParserError_Tests: XCTestCase {

    func test_MEExpression_termOpeTerm_Var() async throws {
        let sut = Regex {
            MEExpression(locale: .init(identifier: "ja-JP"), variableNames: ["x", "y", "z"])
        }
        
        let varOpeVarMatch = try sut.wholeMatch(in: "1 +")
        let output = try XCTUnwrap(varOpeVarMatch?.output)
        XCTAssertEqual(output, [.numeric(1, "1"), .binaryOperator("+")])
        
        XCTAssertThrowsError(try parseExpression(output), "Hello", { error in
            XCTAssertEqual(error as? MEParserError, MEParserError.unknownStructure)
        })
    }

}
