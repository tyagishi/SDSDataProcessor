//
//  MathExpressionNumericOperator_Tests.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/01/16.
//

import XCTest
@testable import SDSDataProcessor

final class MathExpressionNumericOperator_Tests: XCTestCase {
    func test_NumericAndOperator_simple() async throws {
        let expressionString = "1 + 1"
        
        let sut = Regex {
            MathExpressionNumericTerm(locale: .init(identifier: "ja-JP"))
            " "
            MathExpressionOperator()
            " "
            MathExpressionNumericTerm(locale: .init(identifier: "ja-JP"))
        }
        
        let match = try sut.wholeMatch(in: expressionString)
        var output = try XCTUnwrap(match?.output)
        print(output)
    }
}
