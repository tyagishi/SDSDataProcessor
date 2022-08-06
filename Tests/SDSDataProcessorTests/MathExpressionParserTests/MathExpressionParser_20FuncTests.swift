@testable import SDSDataProcessor
import XCTest

final class MathExpressionParser_20FuncTests: XCTestCase {

    func test_func_sin01() async throws {
        let tokens = [Token.function("sin"), Token.openBracket, Token.numeric(45.0), Token.closeBracket]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .function("sin"))

        let leftNode = try XCTUnwrap(expression.left)
        let leftToken = leftNode.token
        XCTAssertEqual(leftToken, .numeric(2.0))
        XCTAssertEqual(leftNode.isLeaf, true)
        
        let rightNode = try XCTUnwrap(expression.right)
        let rightToken = rightNode.token
        XCTAssertEqual(rightToken, .numeric(3.0))
        XCTAssertEqual(rightNode.isLeaf, true)

        XCTAssertEqual(try expression.calc(), 8.0)
    }
    
    func test_func_sinAndOperator() async throws {
        let tokens = [Token.function("sin"), Token.openBracket, Token.numeric(45.0), Token.closeBracket, .operator("+"), .numeric(1.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .operator("+"))

        let leftNode = try XCTUnwrap(expression.left)
        let leftExpression = try XCTUnwrap(leftNode.token.expression)

        
        let rightNode = try XCTUnwrap(expression.right)
        XCTAssertEqual(rightNode.token, .numeric(1.0))

        XCTAssertEqual(try expression.calc(), 8.0)
    }
}
