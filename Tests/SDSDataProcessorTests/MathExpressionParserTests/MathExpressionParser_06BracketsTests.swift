@testable import SDSDataProcessor
import XCTest

final class MathExpressionParser_06BracketsTests: XCTestCase {

    func test_parse_brankets_one() throws {
        let tokens = [Token.OpenBracket, Token.Numeric(1.0), Token.CloseBracket]
        let sut = MathExpressionParser()
        
        let expression = try XCTUnwrap(sut.parse(tokens))
        XCTAssertEqual(try expression.calc(), 1.0)
    }

    func test_parse_brankets() throws {
        let tokens = [Token.OpenBracket, Token.Numeric(1.0), Token.Operator("+"), Token.Numeric(1.0), Token.CloseBracket]
        let sut = MathExpressionParser()

        let expression = try XCTUnwrap(sut.parse(tokens))
        XCTAssertEqual(try expression.calc(), 2.0)
    }

    func test_parse_branketsLeftSide_noEffectResult() throws {
        // ((1,+,2),+,3)
        let tokens = [Token.OpenBracket, Token.Numeric(1.0), Token.Operator("+"), Token.Numeric(2.0), Token.CloseBracket, Token.Operator("+"), Token.Numeric(3.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("+"))

        let leftNode = try XCTUnwrap(expression.left)
        let leftToken = leftNode.token
        XCTAssertTrue(leftToken.isBracketed)
        let bracketed = try XCTUnwrap(leftToken.expression)
        XCTAssertEqual(bracketed.token, .Operator("+"))
        
        let bracketedLeft = try XCTUnwrap(bracketed.left)
        XCTAssertEqual(bracketedLeft.token, .Numeric(1.0))
        
        let bracketedRight = try XCTUnwrap(bracketed.right)
        XCTAssertEqual(bracketedRight.token, .Numeric(2.0))

        let rightToken = try XCTUnwrap(expression.right?.token)
        XCTAssertEqual(rightToken, .Numeric(3.0))

        XCTAssertEqual(try expression.calc(), 6.0)
    }

    func test_parse_branketsRightSide_noEffectResult() throws {
        // (1,+,(2,+,3))
        let tokens = [Token.Numeric(1.0), Token.Operator("+"), Token.OpenBracket, Token.Numeric(2.0), Token.Operator("+"), Token.Numeric(3.0), Token.CloseBracket]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("+"))
        
        let leftToken = try XCTUnwrap(expression.left?.token)
        XCTAssertEqual(leftToken, .Numeric(1.0))

        let rightNode = try XCTUnwrap(expression.right)
        XCTAssertTrue(rightNode.token.isBracketed)
        
        let bracketed = try XCTUnwrap(rightNode.token.expression)
        XCTAssertEqual(bracketed.token, .Operator("+"))
        
        let bracketedLeft = try XCTUnwrap(bracketed.left)
        XCTAssertEqual(bracketedLeft.token, .Numeric(2.0))
        
        let bracketedRight = try XCTUnwrap(bracketed.right)
        XCTAssertEqual(bracketedRight.token, .Numeric(3.0))

        XCTAssertEqual(try expression.calc(), 6.0)
    }

    func test_parse_brankets_effectResult() throws {
        // ((1,+,2),*,3)
        let tokens = [Token.OpenBracket, Token.Numeric(1.0), Token.Operator("+"), Token.Numeric(2.0), Token.CloseBracket, Token.Operator("*"), Token.Numeric(3.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("*"))
        
        let leftNode = try XCTUnwrap(expression.left)
        XCTAssertTrue(leftNode.token.isBracketed)
        
        let bracketed = try XCTUnwrap(leftNode.token.expression)
        XCTAssertEqual(bracketed.token, .Operator("+"))

        let bracketedLeft = try XCTUnwrap(bracketed.left)
        XCTAssertEqual(bracketedLeft.token, .Numeric(1.0))

        let bracketedRight = try XCTUnwrap(bracketed.right)
        XCTAssertEqual(bracketedRight.token, .Numeric(2.0))
        
        let rightNode = try XCTUnwrap(expression.right)
        XCTAssertEqual(rightNode.token, .Numeric(3.0))

        XCTAssertEqual(try expression.calc(), 9.0)
    }

}
