@testable import SDSDataProcessor
import XCTest

final class MathExpressionParser_06BracketsTests: XCTestCase {

    func test_parse_brankets_one() throws {
        let tokens = [Token.openBracket, Token.numeric(1.0), Token.closeBracket]
        let sut = MathExpressionParser()
        
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let rootNode = try XCTUnwrap(expression.token)
        let bracketedExpr = try XCTUnwrap(rootNode.expression)
        let bracketedRootToken = try XCTUnwrap(bracketedExpr.token)
        XCTAssertEqual(bracketedRootToken, .numeric(1.0))
        XCTAssertEqual(try expression.calc(), 1.0)
    }

    func test_parse_brankets() throws {
        let tokens = [Token.openBracket, Token.numeric(1.0), Token.binaryOperator("+"), Token.numeric(1.0), Token.closeBracket]
        let sut = MathExpressionParser()

        let expression = try XCTUnwrap(sut.parse(tokens))
        XCTAssertEqual(try expression.calc(), 2.0)
    }

    func test_parse_branketsLeftSide_noEffectResult() throws {
        // ((1,+,2),+,3)
        let tokens = [Token.openBracket, Token.numeric(1.0), Token.binaryOperator("+"), Token.numeric(2.0), Token.closeBracket, Token.binaryOperator("+"), Token.numeric(3.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .binaryOperator("+"))

        let leftNode = try XCTUnwrap(expression.left)
        let leftToken = leftNode.token
        XCTAssertTrue(leftToken.isBracketed)
        let bracketed = try XCTUnwrap(leftToken.expression)
        XCTAssertEqual(bracketed.token, .binaryOperator("+"))
        
        let bracketedLeft = try XCTUnwrap(bracketed.left)
        XCTAssertEqual(bracketedLeft.token, .numeric(1.0))
        
        let bracketedRight = try XCTUnwrap(bracketed.right)
        XCTAssertEqual(bracketedRight.token, .numeric(2.0))

        let rightToken = try XCTUnwrap(expression.right?.token)
        XCTAssertEqual(rightToken, .numeric(3.0))

        XCTAssertEqual(try expression.calc(), 6.0)
    }

    func test_parse_branketsRightSide_noEffectResult() throws {
        // (1,+,(2,+,3))
        let tokens = [Token.numeric(1.0), Token.binaryOperator("+"), Token.openBracket, Token.numeric(2.0), Token.binaryOperator("+"), Token.numeric(3.0), Token.closeBracket]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .binaryOperator("+"))
        
        let leftToken = try XCTUnwrap(expression.left?.token)
        XCTAssertEqual(leftToken, .numeric(1.0))

        let rightNode = try XCTUnwrap(expression.right)
        XCTAssertTrue(rightNode.token.isBracketed)
        
        let bracketed = try XCTUnwrap(rightNode.token.expression)
        XCTAssertEqual(bracketed.token, .binaryOperator("+"))
        
        let bracketedLeft = try XCTUnwrap(bracketed.left)
        XCTAssertEqual(bracketedLeft.token, .numeric(2.0))
        
        let bracketedRight = try XCTUnwrap(bracketed.right)
        XCTAssertEqual(bracketedRight.token, .numeric(3.0))

        XCTAssertEqual(try expression.calc(), 6.0)
    }

    func test_parse_brankets_effectResult() throws {
        // ((1,+,2),*,3)
        let tokens = [Token.openBracket, Token.numeric(1.0), Token.binaryOperator("+"), Token.numeric(2.0), Token.closeBracket, Token.binaryOperator("*"), Token.numeric(3.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .binaryOperator("*"))
        
        let leftNode = try XCTUnwrap(expression.left)
        XCTAssertTrue(leftNode.token.isBracketed)
        
        let bracketed = try XCTUnwrap(leftNode.token.expression)
        XCTAssertEqual(bracketed.token, .binaryOperator("+"))

        let bracketedLeft = try XCTUnwrap(bracketed.left)
        XCTAssertEqual(bracketedLeft.token, .numeric(1.0))

        let bracketedRight = try XCTUnwrap(bracketed.right)
        XCTAssertEqual(bracketedRight.token, .numeric(2.0))
        
        let rightNode = try XCTUnwrap(expression.right)
        XCTAssertEqual(rightNode.token, .numeric(3.0))

        XCTAssertEqual(try expression.calc(), 9.0)
    }

}
