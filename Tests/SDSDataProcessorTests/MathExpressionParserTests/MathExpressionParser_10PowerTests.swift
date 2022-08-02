@testable import SDSDataProcessor
import XCTest

final class MathExpressionParser_PowerTests: XCTestCase {

    func test_power_simple01() async throws {
        let tokens = [Token.Numeric(2.0), Token.Operator("^"), Token.Numeric(3.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("^"))

        let leftNode = try XCTUnwrap(expression.left)
        let leftToken = leftNode.token
        XCTAssertEqual(leftToken, .Numeric(2.0))
        XCTAssertEqual(leftNode.isLeaf, true)
        
        let rightNode = try XCTUnwrap(expression.right)
        let rightToken = rightNode.token
        XCTAssertEqual(rightToken, .Numeric(3.0))
        XCTAssertEqual(rightNode.isLeaf, true)

        XCTAssertEqual(try expression.calc(), 8.0)
    }
    func test_power_simple02() async throws {
        let tokens = [Token.Numeric(2.0), Token.Operator("^"), Token.Numeric(3.0), Token.Operator("+"), Token.Numeric(4.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("+"))

        let leftNode = try XCTUnwrap(expression.left)
        XCTAssertEqual(leftNode.token, .Operator("^"))
        let leftLeftNode = try XCTUnwrap(leftNode.left)
        XCTAssertEqual(leftLeftNode.token, .Numeric(2.0))
        
        let leftRightNode = try XCTUnwrap(leftNode.right)
        XCTAssertEqual(leftRightNode.token, .Numeric(3.0))

        let rightNode = try XCTUnwrap(expression.right)
        XCTAssertEqual(rightNode.token, .Numeric(4.0))

        XCTAssertEqual(try expression.calc(), 12.0)
    }
}
