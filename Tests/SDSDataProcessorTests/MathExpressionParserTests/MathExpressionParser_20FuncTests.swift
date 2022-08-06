@testable import SDSDataProcessor
import XCTest

final class MathExpressionParser_20FuncTests: XCTestCase {

    func test_func_sin01() async throws {
        let tokens = [Token.functionName("sin"), Token.openBracket, Token.numeric(45.0), Token.closeBracket]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken.functionName, "sin")
        let argument = try XCTUnwrap(topToken.functionArgument)
        
        XCTAssertEqual(argument.token, .numeric(45))
//        XCTAssertEqual(try expression.calc(), 8.0)
    }
    
    func test_func_sinAndbinaryOperator() async throws {
        let tokens = [Token.functionName("sin"), Token.openBracket, Token.numeric(45.0), Token.closeBracket, .binaryOperator("+"), .numeric(1.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .binaryOperator("+"))

        let leftNode = try XCTUnwrap(expression.left)
        let leftExpression = try XCTUnwrap(leftNode.token.expression)

        
        let rightNode = try XCTUnwrap(expression.right)
        XCTAssertEqual(rightNode.token, .numeric(1.0))

        XCTAssertEqual(try expression.calc(), 8.0)
    }
}
