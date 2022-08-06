@testable import SDSDataProcessor
import XCTest

final class MathExpressionParser_10PowerTests: XCTestCase {

    func test_power_simple01() async throws {
        let tokens = [Token.numeric(2.0), Token.operator("^"), Token.numeric(3.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .operator("^"))

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
    func test_power_simple02() async throws {
        let tokens = [Token.numeric(2.0), Token.operator("^"), Token.numeric(3.0), Token.operator("+"), Token.numeric(4.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .operator("+"))

        let leftNode = try XCTUnwrap(expression.left)
        XCTAssertEqual(leftNode.token, .operator("^"))
        let leftLeftNode = try XCTUnwrap(leftNode.left)
        XCTAssertEqual(leftLeftNode.token, .numeric(2.0))
        
        let leftRightNode = try XCTUnwrap(leftNode.right)
        XCTAssertEqual(leftRightNode.token, .numeric(3.0))

        let rightNode = try XCTUnwrap(expression.right)
        XCTAssertEqual(rightNode.token, .numeric(4.0))

        XCTAssertEqual(try expression.calc(), 12.0)
    }
    
    func test_power_operatorOrder() async throws {
        let tokens = [Token.numeric(1.0), Token.operator("*"), Token.numeric(2.0), Token.operator("^"), Token.numeric(3.0), Token.operator("*"), Token.numeric(4.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .operator("*"))

        let leftNode = try XCTUnwrap(expression.left)
        XCTAssertEqual(leftNode.token, .numeric(1.0))
        
        let rightNode = try XCTUnwrap(expression.right)
        XCTAssertEqual(rightNode.token, .operator("*"))
        
        let rightLeftNode = try XCTUnwrap(rightNode.left)
        XCTAssertEqual(rightLeftNode.token, .operator("^"))
        
        let rightLeftLeftNode = try XCTUnwrap(rightLeftNode.left)
        XCTAssertEqual(rightLeftLeftNode.token, .numeric(2.0))
        let rightLeftRightNode = try XCTUnwrap(rightLeftNode.right)
        XCTAssertEqual(rightLeftRightNode.token, .numeric(3.0))

        let rightRightNode = try XCTUnwrap(rightNode.right)
        XCTAssertEqual(rightRightNode.token, .numeric(4.0))
                       
        XCTAssertEqual(try expression.calc(), 32.0)

    }

}
