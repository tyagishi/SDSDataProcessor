//
//  50MEExpression_Tests.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/08/13.
//

import XCTest
@testable import SDSDataProcessor

final class _0MEExpression_Tests: XCTestCase {

    func test_MEExpression_single() async throws {
        let sut = Regex {
            MEExpression(locale: .init(identifier: "ja-JP"), variableNames: ["x", "y"])
        }
        
        let numericMatch = try sut.wholeMatch(in: "+12.34")
        var output = try XCTUnwrap(numericMatch?.output)
        XCTAssertEqual(output, [METoken.numeric(12.34, "+12.34")])
        
        var parseResult = try parseExpression(output)
        XCTAssertEqual(parseResult.value, METoken.numeric(12.34, "+12.34"))
        XCTAssertEqual(try parseResult.evaluate(), 12.34, accuracy: 0.01)

        let variableMatch = try sut.wholeMatch(in: "x")
        output = try XCTUnwrap(variableMatch?.output)
        XCTAssertEqual(output, [METoken.variable("x")])

        parseResult = try parseExpression(output)
        XCTAssertEqual(parseResult.value, METoken.variable("x"))
        XCTAssertEqual(try parseResult.evaluate(["x": 12.0]), 12.0, accuracy: 0.01)
    }
    
    func test_MEExpression_termOpeTerm_Num() async throws {
        let sut = Regex {
            MEExpression(locale: .init(identifier: "ja-JP"), variableNames: ["x", "y"])
        }
        
        let numOpeNumMatch = try sut.wholeMatch(in: "1 + 12.34")
        let output = try XCTUnwrap(numOpeNumMatch?.output)
        XCTAssertEqual(output, [.numeric(1.0, "1"), .binaryOperator("+"), .numeric(12.34, "12.34")])
        
        let parseResult = try parseExpression(output)
        XCTAssertEqual(parseResult.value, .binaryOperator("+"))
        XCTAssertEqual(parseResult.left?.value, .numeric(1.0, "1"))
        XCTAssertEqual(parseResult.right?.value, .numeric(12.34, "12.34"))
        XCTAssertEqual(try parseResult.evaluate(), 13.34, accuracy: 0.01)
    }
    
    func test_MEExpression_termOpeTerm_Var() async throws {
        let sut = Regex {
            MEExpression(locale: .init(identifier: "ja-JP"), variableNames: ["x", "y", "z"])
        }
        
        let variables: [String: Double] = ["x": 1, "y": 2, "z": 3]
        
        let varOpeVarMatch = try sut.wholeMatch(in: "x + y")
        let output = try XCTUnwrap(varOpeVarMatch?.output)
        XCTAssertEqual(output, [.variable("x"), .binaryOperator("+"), .variable("y")])
        
        let parseResult = try parseExpression(output)
        XCTAssertEqual(parseResult.value, .binaryOperator("+"))
        XCTAssertEqual(parseResult.left?.value, .variable("x"))
        XCTAssertEqual(parseResult.right?.value, .variable("y"))
        XCTAssertEqual(try parseResult.evaluate(variables), 3.0, accuracy: 0.01)
    }
    
    func test_MEExpression_termOpeTerm_NumVar() async throws {
        let sut = Regex {
            MEExpression(locale: .init(identifier: "ja-JP"), variableNames: ["x", "y", "z"])
        }
        
        let variables: [String: Double] = ["x": 1, "y": 2, "z": 3]
        
        let varOpeNumMatch = try sut.wholeMatch(in: "x + 1.2")
        var output = try XCTUnwrap(varOpeNumMatch?.output)
        XCTAssertEqual(output, [.variable("x"), .binaryOperator("+"), .numeric(1.2, "1.2")])
        
        var parseResult = try parseExpression(output)
        XCTAssertEqual(parseResult.value, .binaryOperator("+"))
        XCTAssertEqual(parseResult.left?.value, .variable("x"))
        XCTAssertEqual(parseResult.right?.value, .numeric(1.2, "1.2"))
        XCTAssertEqual(try parseResult.evaluate(variables), 2.2, accuracy: 0.01)

        let numOpeVarMatch = try sut.wholeMatch(in: "2.5 + y")
        output = try XCTUnwrap(numOpeVarMatch?.output)
        XCTAssertEqual(output, [.numeric(2.5, "2.5"), .binaryOperator("+"), .variable("y")])
        
        parseResult = try parseExpression(output)
        XCTAssertEqual(parseResult.value, .binaryOperator("+"))
        XCTAssertEqual(parseResult.left?.value, .numeric(2.5, "2.5"))
        XCTAssertEqual(parseResult.right?.value, .variable("y"))
        XCTAssertEqual(try parseResult.evaluate(variables), 4.5, accuracy: 0.01)
    }
    
    func test_MEExpression_moreThanTermOpeTerm_Num() async throws {
        let sut = Regex {
            MEExpression(locale: .init(identifier: "ja-JP"), variableNames: ["x", "y", "z"])
        }
        
        let variables: [String: Double] = ["x": 1, "y": 2, "z": 3]
        
        let varOpeNumMatch = try sut.wholeMatch(in: "2.3 + 1.2 - 4.1")
        let output = try XCTUnwrap(varOpeNumMatch?.output)
        XCTAssertEqual(output, [.numeric(2.3, "2.3"), .binaryOperator("+"), .numeric(1.2, "1.2"), .binaryOperator("-"), .numeric(4.1, "4.1")])
        
        let parseResult = try parseExpression(output)
        XCTAssertEqual(parseResult.value, .binaryOperator("-"))
        XCTAssertEqual(parseResult.left?.value, .binaryOperator("+"))
        XCTAssertEqual(parseResult.left?.left?.value, .numeric(2.3, "2.3"))
        XCTAssertEqual(parseResult.left?.right?.value, .numeric(1.2, "1.2"))
        XCTAssertEqual(parseResult.right?.value, .numeric(4.1, "4.1"))
        XCTAssertEqual(try parseResult.evaluate(variables), -0.6, accuracy: 0.01)
    }
    
    func test_MEExpression_parenthesis() async throws {
        let sut = Regex {
            MEExpression(locale: .init(identifier: "ja-JP"), variableNames: ["x", "y"])
        }
        
        let numMatch = try sut.wholeMatch(in: "(12.34)")
        var output = try XCTUnwrap(numMatch?.output)
        XCTAssertEqual(output, [.openParenthesis("("), .numeric(12.34, "12.34"), .closeParenthesis(")")])

        let varMatch = try sut.wholeMatch(in: "(x)")
        output = try XCTUnwrap(varMatch?.output)
        XCTAssertEqual(output, [.openParenthesis("("), .variable("x"), .closeParenthesis(")")])

        let num2Match = try sut.wholeMatch(in: "(12.34 * 3)")
        output = try XCTUnwrap(num2Match?.output)
        XCTAssertEqual(output, [.openParenthesis("("), .numeric(12.34, "12.34"), .binaryOperator("*"), .numeric(3, "3"), .closeParenthesis(")")])

        let var2Match = try sut.wholeMatch(in: "(x + y)")
        output = try XCTUnwrap(var2Match?.output)
        XCTAssertEqual(output, [.openParenthesis("("), .variable("x"), .binaryOperator("+"), .variable("y"), .closeParenthesis(")")])

        let numVarMatch = try sut.prefixMatch(in: "(y - 13.2 )")
        output = try XCTUnwrap(numVarMatch?.output)
        XCTAssertEqual(output, [.openParenthesis("("), .variable("y"), .binaryOperator("-"),  .numeric(13.2, "13.2"), .closeParenthesis(")")])

        let varNumMatch = try sut.prefixMatch(in: "(13.2 + x )")
        output = try XCTUnwrap(varNumMatch?.output)
        XCTAssertEqual(output, [.openParenthesis("("), .numeric(13.2, "13.2"), .binaryOperator("+"), .variable("x"), .closeParenthesis(")")])
    }

}
