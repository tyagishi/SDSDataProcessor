@testable import SDSDataProcessor
import XCTest

final class MathExpressionParser_20FuncTests: XCTestCase {

    func test_func_sin45() async throws {
        let tokens = [Token.functionName("sin("), Token.numeric(45.0), Token.closeBracket]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken.functionName, "sin(")
        let argument = try XCTUnwrap(topToken.functionArgument)
        
        XCTAssertEqual(argument.token, .numeric(45))
        XCTAssertEqual(try expression.calc(), 1.0 / sqrt(2.0), accuracy: 0.001)
    }
    
    func test_func_cos45() async throws {
        let tokens = [Token.functionName("cos("), Token.numeric(45.0), Token.closeBracket]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken.functionName, "cos(")
        let argument = try XCTUnwrap(topToken.functionArgument)
        
        XCTAssertEqual(argument.token, .numeric(45))
        XCTAssertEqual(try expression.calc(), cos(45.0 / 180 * Double.pi), accuracy: 0.001)
    }
    func test_func_asin1() async throws {
        let tokens = [Token.functionName("asin("), Token.numeric(1.0), Token.closeBracket]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken.functionName, "asin(")
        let argument = try XCTUnwrap(topToken.functionArgument)
        
        XCTAssertEqual(argument.token, .numeric(1.0))
        XCTAssertEqual(try expression.calc(), 90.0, accuracy: 0.001)
    }
    
    func test_func_sinCalcWithArgumentCalc() async throws {
        let tokens = [Token.functionName("sin("), Token.numeric(25.0), Token.binaryOperator("+"), Token.numeric(20), Token.closeBracket]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken.functionName, "sin(")
        let argument = try XCTUnwrap(topToken.functionArgument)
        
        XCTAssertEqual(argument.token, .binaryOperator("+"))
        let left = try XCTUnwrap(argument.left)
        XCTAssertEqual(left.token, .numeric(25))
        let right = try XCTUnwrap(argument.right)
        XCTAssertEqual(right.token, .numeric(20))
        
        XCTAssertEqual(try expression.calc(), 1.0 / sqrt(2.0), accuracy: 0.001)
    }
    
    func test_func_sinAndbinaryOperator() async throws {
        let tokens = [Token.functionName("sin("), Token.numeric(45.0), Token.closeBracket, .binaryOperator("+"), .numeric(1.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))

        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .binaryOperator("+"))

        let leftNode = try XCTUnwrap(expression.left)
        XCTAssertEqual(leftNode.token.functionName, "sin(")
        let argument = try XCTUnwrap(leftNode.token.functionArgument)
        
        XCTAssertEqual(argument.token, .numeric(45))
        
        let rightNode = try XCTUnwrap(expression.right)
        XCTAssertEqual(rightNode.token, .numeric(1.0))

        XCTAssertEqual(try expression.calc(), 1.0 / sqrt(2.0) + 1.0, accuracy: 0.001)
    }
}
