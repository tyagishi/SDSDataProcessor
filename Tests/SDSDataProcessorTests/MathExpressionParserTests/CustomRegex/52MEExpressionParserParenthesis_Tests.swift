//
//  52MEExpressionParserParenthesis_Tests.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/08/15.
//

import XCTest
@testable import SDSDataProcessor

final class _52MEExpressionParserParenthesis_Tests: XCTestCase {

    func test_MEExpression_parenthesis_singleTerm_num() async throws {
        let sut = Regex {
            MEExpression(locale: .init(identifier: "ja-JP"), variableNames: ["x", "y"])
        }
        
        let numMatch = try sut.wholeMatch(in: "(12.34)")
        let output = try XCTUnwrap(numMatch?.output)
        XCTAssertEqual(output, [.openParenthesis("("), .numeric(12.34, "12.34"), .closeParenthesis(")")])
        
        let parseResult = try MEParser.parseExpression(output)
        XCTAssertEqual(parseResult.value, METoken.unaryOperator("(", ")"))
        XCTAssertEqual(parseResult.right?.value, METoken.numeric(12.34, "12.34"))
        XCTAssertEqual(try parseResult.evaluate(), 12.34, accuracy: 0.01)
    }

    func test_MEExpression_parenthesis_singleTerm_var() async throws {
        let sut = Regex {
            MEExpression(locale: .init(identifier: "ja-JP"), variableNames: ["x", "y"])
        }
        
        let variables: [String: Double] = ["x": 1, "y": 2, "z": 3]

        let numMatch = try sut.wholeMatch(in: "(x)")
        let output = try XCTUnwrap(numMatch?.output)
        XCTAssertEqual(output, [.openParenthesis("("), .variable("x"), .closeParenthesis(")")])
        
        let parseResult = try MEParser.parseExpression(output)
        XCTAssertEqual(parseResult.value, .unaryOperator("(", ")"))
        XCTAssertEqual(parseResult.right?.value, .variable("x"))
        XCTAssertEqual(try parseResult.evaluate(variables), 1, accuracy: 0.01)
    }

    func test_MEExpression_nestedParenthesis_singleTerm_num() async throws {
        let sut = Regex {
            MEExpression(locale: .init(identifier: "ja-JP"), variableNames: ["x", "y"])
        }
        
        let numMatch = try sut.wholeMatch(in: "((12.34))")
        let output = try XCTUnwrap(numMatch?.output)
        XCTAssertEqual(output, [.openParenthesis("("), .openParenthesis("("), .numeric(12.34, "12.34"), .closeParenthesis(")"), .closeParenthesis(")")])
        
        let parseResult = try MEParser.parseExpression(output)
        XCTAssertEqual(parseResult.value, METoken.unaryOperator("(", ")"))
        XCTAssertEqual(parseResult.right?.value, METoken.numeric(12.34, "12.34"))
        XCTAssertEqual(try parseResult.evaluate(), 12.34, accuracy: 0.01)
    }
//
//    
//    func test_MEExpression_parenthesis_singleTerm_______temp() async throws {
//        let sut = Regex {
//            MEExpression(locale: .init(identifier: "ja-JP"), variableNames: ["x", "y"])
//        }
//        
//        let numMatch = try sut.wholeMatch(in: "(12.34)")
//        var output = try XCTUnwrap(numMatch?.output)
//        XCTAssertEqual(output, [.openParenthesis("("), .numeric(12.34, "12.34"), .closeParenthesis(")")])
//
//        let varMatch = try sut.wholeMatch(in: "(x)")
//        output = try XCTUnwrap(varMatch?.output)
//        XCTAssertEqual(output, [.openParenthesis("("), .variable("x"), .closeParenthesis(")")])
//
//        let num2Match = try sut.wholeMatch(in: "(12.34 * 3)")
//        output = try XCTUnwrap(num2Match?.output)
//        XCTAssertEqual(output, [.openParenthesis("("), .numeric(12.34, "12.34"), .binaryOperator("*"), .numeric(3, "3"), .closeParenthesis(")")])
//
//        let var2Match = try sut.wholeMatch(in: "(x + y)")
//        output = try XCTUnwrap(var2Match?.output)
//        XCTAssertEqual(output, [.openParenthesis("("), .variable("x"), .binaryOperator("+"), .variable("y"), .closeParenthesis(")")])
//
//        let numVarMatch = try sut.prefixMatch(in: "(y - 13.2 )")
//        output = try XCTUnwrap(numVarMatch?.output)
//        XCTAssertEqual(output, [.openParenthesis("("), .variable("y"), .binaryOperator("-"),  .numeric(13.2, "13.2"), .closeParenthesis(")")])
//
//        let varNumMatch = try sut.prefixMatch(in: "(13.2 + x )")
//        output = try XCTUnwrap(varNumMatch?.output)
//        XCTAssertEqual(output, [.openParenthesis("("), .numeric(13.2, "13.2"), .binaryOperator("+"), .variable("x"), .closeParenthesis(")")])
//    }
}
