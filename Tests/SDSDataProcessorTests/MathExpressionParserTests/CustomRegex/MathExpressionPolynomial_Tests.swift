//
//  MathExpressionPolynomial_Tests.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/01/16.
//

import XCTest
@testable import SDSDataProcessor

final class MathExpressionPolynomial_Tests: XCTestCase {

//    func test_polynomial_two_terms() async throws {
//        let expression = "1 + 2"
//        
//        let regex = Regex {
//            MathExpressionPolynomial(locale: .init(identifier: "ja-JP"), variableNames: [])
//        }
//        
//        let match = try regex.wholeMatch(in: expression)
//        let output = try XCTUnwrap(match?.output)
//        XCTAssertEqual(output.count, 3)
//        XCTAssertEqual(output[0], MathExpressionToken.numeric(1.0, "1"))
//        XCTAssertEqual(output[1], MathExpressionToken.binaryOperator("+"))
//        XCTAssertEqual(output[2], MathExpressionToken.numeric(2.0, "2"))
//    }
//    
//    func test_polynomial_two_terms_brancket() async throws {
//        let expression = "(1 + 2)"
//        
//        let regex = Regex {
//            MathExpressionPolynomial(locale: .init(identifier: "ja-JP"), variableNames: [])
//        }
//        
//        let match = try regex.wholeMatch(in: expression)
//        let output = try XCTUnwrap(match?.output)
//        XCTAssertEqual(output.count, 5)
//        XCTAssertEqual(output[0], MathExpressionToken.openBracket)
//        XCTAssertEqual(output[1], MathExpressionToken.numeric(1.0, "1"))
//        XCTAssertEqual(output[2], MathExpressionToken.binaryOperator("+"))
//        XCTAssertEqual(output[3], MathExpressionToken.numeric(2.0, "2"))
//        XCTAssertEqual(output[4], MathExpressionToken.closeBracket)
//    }
//    
//    func test_polynomial_three_terms() async throws {
//        let expression = "1 - 2 + 3"
//        
//        let regex = Regex {
//            MathExpressionPolynomial(locale: .init(identifier: "ja-JP"), variableNames: [])
//        }
//        
//        let match = try regex.wholeMatch(in: expression)
//        let output = try XCTUnwrap(match?.output)
//        XCTAssertEqual(output.count, 5)
//        XCTAssertEqual(output[0], MathExpressionToken.numeric(1.0, "1"))
//        XCTAssertEqual(output[1], MathExpressionToken.binaryOperator("-"))
//        XCTAssertEqual(output[2], MathExpressionToken.numeric(2.0, "2"))
//        XCTAssertEqual(output[3], MathExpressionToken.binaryOperator("+"))
//        XCTAssertEqual(output[4], MathExpressionToken.numeric(3.0, "3"))
//    }
//    
//    func test_polynomial_three_terms_variables() async throws {
//        let expression = "1 - 2 + x"
//        
//        let regex = Regex {
//            MathExpressionPolynomial(locale: .init(identifier: "ja-JP"), variableNames: ["x"])
//        }
//        
//        let match = try regex.wholeMatch(in: expression)
//        let output = try XCTUnwrap(match?.output)
//        XCTAssertEqual(output.count, 5)
//        XCTAssertEqual(output[0], MathExpressionToken.numeric(1.0, "1"))
//        XCTAssertEqual(output[1], MathExpressionToken.binaryOperator("-"))
//        XCTAssertEqual(output[2], MathExpressionToken.numeric(2.0, "2"))
//        XCTAssertEqual(output[3], MathExpressionToken.binaryOperator("+"))
//        XCTAssertEqual(output[4], MathExpressionToken.variable("x"))
//    }
}
