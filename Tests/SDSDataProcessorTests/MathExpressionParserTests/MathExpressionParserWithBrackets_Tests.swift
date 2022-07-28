@testable import MathExpressionParser
import XCTest

final class MathExpressionParserWithBrackets_Tests: XCTestCase {

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
        let tokens = [Token.OpenBracket, Token.Numeric(1.0), Token.Operator("+"), Token.Numeric(2.0), Token.CloseBracket, Token.Operator("+"), Token.Numeric(3.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("+"))
        
        let left = expression.left // brancket node
        let child = left.child
        
        let leftToken = try XCTUnwrap(child.token)
        XCTAssertEqual(leftToken, .Operator("+"))

        let leftLeft = child.left
        let leftLeftToken = try XCTUnwrap(leftLeft.token)
        XCTAssertEqual(leftLeftToken, .Numeric(1.0))

        let leftRight = child.right
        let leftRightToken = try XCTUnwrap(leftRight.token)
        XCTAssertEqual(leftRightToken, .Numeric(2.0))

        let right = expression.right
        let rightToken = try XCTUnwrap(right.token)
        XCTAssertEqual(rightToken, .Numeric(3))

        XCTAssertEqual(try expression.calc(), 6.0)
    }
    
    func test_parse_branketsRightSide_noEffectResult() throws {
        let tokens = [Token.Numeric(1.0), Token.Operator("+"), Token.OpenBracket, Token.Numeric(2.0), Token.Operator("+"), Token.Numeric(3.0), Token.CloseBracket]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("+"))
        
        let left = expression.left // brancket node
        let leftToken = try XCTUnwrap(left.token)
        XCTAssertEqual(leftToken, .Numeric(1.0))

        let right = expression.right
        let child = right.child
        
        let rightToken = try XCTUnwrap(child.token)
        XCTAssertEqual(rightToken, .Operator("+"))

        let rightLeft = child.left
        let rightLeftToken = try XCTUnwrap(rightLeft.token)
        XCTAssertEqual(rightLeftToken, .Numeric(2.0))

        let rightRight = child.right
        let rightRightToken = try XCTUnwrap(rightRight.token)
        XCTAssertEqual(rightRightToken, .Numeric(3.0))

        
        XCTAssertEqual(try expression.calc(), 6.0)
    }

    func test_parse_brankets_effectResult() throws {
        let tokens = [Token.OpenBracket, Token.Numeric(1.0), Token.Operator("+"), Token.Numeric(2.0), Token.CloseBracket, Token.Operator("*"), Token.Numeric(3.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("*"))
        
        let left = expression.left // brancket node
        let child = left.child
        
        let leftToken = try XCTUnwrap(child.token)
        XCTAssertEqual(leftToken, .Operator("+"))

        let leftLeft = child.left
        let leftLeftToken = try XCTUnwrap(leftLeft.token)
        XCTAssertEqual(leftLeftToken, .Numeric(1.0))

        let leftRight = child.right
        let leftRightToken = try XCTUnwrap(leftRight.token)
        XCTAssertEqual(leftRightToken, .Numeric(2.0))

        let right = expression.right
        let rightToken = try XCTUnwrap(right.token)
        XCTAssertEqual(rightToken, .Numeric(3))
        
        XCTAssertEqual(try expression.calc(), 9.0)
    }

}
