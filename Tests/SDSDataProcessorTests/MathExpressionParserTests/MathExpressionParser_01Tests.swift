@testable import SDSDataProcessor
import XCTest

final class MathExpressionParser_Tests: XCTestCase {

    func test_parse_3Tokens_successToParse() throws {
        let tokens = [Token.Numeric(1.0), Token.Operator("+"), Token.Numeric(2.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("+"))

        let leftNode = try XCTUnwrap(expression.left)
        let leftToken = leftNode.token
        XCTAssertEqual(leftToken, .Numeric(1.0))
        XCTAssertEqual(leftNode.isLeaf, true)
        
        let rightNode = try XCTUnwrap(expression.right)
        let rightToken = rightNode.token
        XCTAssertEqual(rightToken, .Numeric(2.0))
        XCTAssertEqual(rightNode.isLeaf, true)

        XCTAssertEqual(try expression.calc(), 3.0)
    }

    func test_parse_5TokensWithPlusPlus_successToParse() throws {
        let tokens = [Token.Numeric(1.0), Token.Operator("+"), Token.Numeric(1.1), Token.Operator("+"), Token.Numeric(1.2)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("+"))

        let leftNode = try XCTUnwrap(expression.left)
        let leftToken = leftNode.token
        XCTAssertEqual(leftToken, .Operator("+"))
        
        let leftLeftNode = try XCTUnwrap(leftNode.left)
        let leftLeftToken = leftLeftNode.token
        XCTAssertEqual(leftLeftToken, .Numeric(1.0))
        
        let leftRightNode = try XCTUnwrap(leftNode.right)
        let leftRightToken = leftRightNode.token
        XCTAssertEqual(leftRightToken, .Numeric(1.1))

        let rightNode = try XCTUnwrap(expression.right)
        let rightToken = rightNode.token
        XCTAssertEqual(rightToken, .Numeric(1.2))
        
        XCTAssertEqual(try expression.calc(), 3.3)
    }

    
    func test_parse_3Tokens_Times_successToParse() throws {
        let tokens = [Token.Numeric(1.0), Token.Operator("*"), Token.Numeric(2.0)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("*"))

        let leftNode = try XCTUnwrap(expression.left)
        let leftToken = leftNode.token
        XCTAssertEqual(leftToken, .Numeric(1.0))
        XCTAssertEqual(leftNode.isLeaf, true)
        
        let rightNode = try XCTUnwrap(expression.right)
        let rightToken = rightNode.token
        XCTAssertEqual(rightToken, .Numeric(2.0))
        XCTAssertEqual(rightNode.isLeaf, true)

        XCTAssertEqual(try expression.calc(), 2.0)
    }
    
    func test_parse_5TokensWithTimesTimes_successToParse() throws {
        let tokens = [Token.Numeric(1.0), Token.Operator("*"), Token.Numeric(1.1), Token.Operator("*"), Token.Numeric(1.2)]
        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = expression.token
        XCTAssertEqual(topToken, .Operator("*"))

        let leftNode = try XCTUnwrap(expression.left)
        let leftToken = leftNode.token
        XCTAssertEqual(leftToken, .Numeric(1.0))
        
        let rightNode = try XCTUnwrap(expression.right)
        let rightToken = rightNode.token
        XCTAssertEqual(rightToken, .Operator("*"))

        let rightLeftNode = try XCTUnwrap(rightNode.left)
        let rightLeftToken = rightLeftNode.token
        XCTAssertEqual(rightLeftToken, .Numeric(1.1))
        
        let rightRightNode = try XCTUnwrap(rightNode.right)
        let rightRightToken = rightRightNode.token
        XCTAssertEqual(rightRightToken, .Numeric(1.2))
        
        XCTAssertEqual(try expression.calc(), 1.32)
    }
    
    func test_parse_5TokensPlusTimes_successToParse() throws {
        let tokens = [Token.Numeric(1.0), Token.Operator("+"), Token.Numeric(2.0), Token.Operator("*"), Token.Numeric(3.0)]

        let sut = MathExpressionParser()
        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("+"))

        let leftNode = try XCTUnwrap(expression.left)
        let leftToken = leftNode.token
        XCTAssertEqual(leftToken, .Numeric(1.0))
        XCTAssertEqual(leftToken.isNumeric, true)
        
        let rightNode = try XCTUnwrap(expression.right)
        let rightToken = rightNode.token
        XCTAssertEqual(rightToken, .Operator("*"))
        
        let rightLeftNode = try XCTUnwrap(rightNode.left)
        let rightLeftToken = rightLeftNode.token
        XCTAssertEqual(rightLeftToken, .Numeric(2.0))
        
        let rightRightNode = try XCTUnwrap(rightNode.right)
        let rightRightToken = rightRightNode.token
        XCTAssertEqual(rightRightToken, .Numeric(3.0))
                                
        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 7.0, accuracy: 0.001) // 1.0 + 2.0 * 3.0 = 7.0
    }

    func test_parse_5TokensTimesPlus_successToParse() throws {
        let tokens = [Token.Numeric(1.0), Token.Operator("*"), Token.Numeric(1.1), Token.Operator("+"), Token.Numeric(1.2)]
        let sut = MathExpressionParser()

        let expression = try XCTUnwrap(sut.parse(tokens))
        XCTAssertNotNil(expression)

        let leftNode = try XCTUnwrap(expression.left)
        let leftToken = leftNode.token
        XCTAssertEqual(leftToken, .Operator("*"))
        
        let leftLeftNode = try XCTUnwrap(leftNode.left)
        let leftLeftToken = leftLeftNode.token
        XCTAssertEqual(leftLeftToken, .Numeric(1.0))
        
        let leftRightNode = try XCTUnwrap(leftNode.right)
        let leftRightToken = leftRightNode.token
        XCTAssertEqual(leftRightToken, .Numeric(1.1))

        let rightNode = try XCTUnwrap(expression.right)
        let rightToken = rightNode.token
        XCTAssertEqual(rightToken, .Numeric(1.2))
        
        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 2.3, accuracy: 0.001) // 1.0 * 1.1 + 1.2 = 1.1 + 1.2 = 2.3
    }
    
    

    func test_parse_7TokensTimesPlusTimes_successToParse() throws {
        let tokens = [Token.Numeric(1.0), Token.Operator("*"), Token.Numeric(4), Token.Operator("+"), Token.Numeric(2), Token.Operator("*"), Token.Numeric(3)]
        let sut = MathExpressionParser()

        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("+"))
        
        let leftNode = try XCTUnwrap(expression.left)
        let leftToken = leftNode.token
        XCTAssertEqual(leftToken, .Operator("*"))
        
        let leftLeftNode = try XCTUnwrap(leftNode.left)
        let leftLeftToken = leftLeftNode.token
        XCTAssertEqual(leftLeftToken, .Numeric(1.0))
        
        let leftRightNode = try XCTUnwrap(leftNode.right)
        let leftRightToken = leftRightNode.token
        XCTAssertEqual(leftRightToken, .Numeric(4))

        let rightNode = try XCTUnwrap(expression.right)
        let rightToken = rightNode.token
        XCTAssertEqual(rightToken, .Operator("*"))

        let rightLeftNode = try XCTUnwrap(rightNode.left)
        let rightLeftToken = rightLeftNode.token
        XCTAssertEqual(rightLeftToken, .Numeric(2))
        
        let rightRightNode = try XCTUnwrap(rightNode.right)
        let rightRightToken = rightRightNode.token
        XCTAssertEqual(rightRightToken, .Numeric(3))

        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 10, accuracy: 0.001) /// 1 * 4 + 2 * 3 = 4 + 6 = 10
    }

    func test_parse_7TokensTimesTimesPlus_successToParse() throws {
        let tokens = [Token.Numeric(1.0), Token.Operator("*"), Token.Numeric(4), Token.Operator("*"), Token.Numeric(2), Token.Operator("+"), Token.Numeric(3)]
        let sut = MathExpressionParser()

        let expression = try XCTUnwrap(sut.parse(tokens))

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("+"))
        
        let leftNode = try XCTUnwrap(expression.left)
        let leftToken = leftNode.token
        XCTAssertEqual(leftToken, .Operator("*"))

        let leftLeftNode = try XCTUnwrap(leftNode.left)
        let leftLeftToken = leftLeftNode.token
        XCTAssertEqual(leftLeftToken, .Numeric(1.0))
                       
        let leftRightNode = try XCTUnwrap(leftNode.right)
        let leftRightToken = leftRightNode.token
        XCTAssertEqual(leftRightToken, .Operator("*"))
        
        let leftRightLeftNode = try XCTUnwrap(leftRightNode.left)
        let leftRightLeftToken = leftRightLeftNode.token
        XCTAssertEqual(leftRightLeftToken, .Numeric(4))

        let leftRightRightNode = try XCTUnwrap(leftRightNode.right)
        let leftRightRightToken = leftRightRightNode.token
        XCTAssertEqual(leftRightRightToken, .Numeric(2))
                       
        let rightNode = try XCTUnwrap(expression.right)
        let rightToken = rightNode.token
        XCTAssertEqual(rightToken, .Numeric(3))

        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 11, accuracy: 0.001) /// 1 * 4 * 2 + 3 = 8 + 3 = 11
    }

    func test_parse_1Tokens_successToParse() throws {
        let tokens = [Token.Numeric(1.0)]
        let sut = MathExpressionParser()

        let expression = try XCTUnwrap(sut.parse(tokens))
        XCTAssertNotNil(expression)

        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Numeric(1.0))

        XCTAssertEqual(try XCTUnwrap(expression.calc()), 1, accuracy: 0.001)
    }

    
    func test_parse_1Tokens_failedToParse() throws {
        let tokens = [Token.Operator("+")]
        let sut = MathExpressionParser()

        let expression = try XCTUnwrap(sut.parse(tokens))

        XCTAssertThrowsError(try expression.calc())
    }
    
    func test_parse_5Tokens_successToParse() throws {
        let tokens: [Token] = [.Numeric(1.0), .Operator("+"), .Numeric(2.0), .Operator("-"), .Numeric(3.0)]
        let sut = MathExpressionParser()

        let expression = try XCTUnwrap(sut.parse(tokens))
        
        let topToken = try XCTUnwrap(expression.token)
        XCTAssertEqual(topToken, .Operator("-"))

        let leftNode = try XCTUnwrap(expression.left)
        let leftToken = leftNode.token
        XCTAssertEqual(leftToken, .Operator("+"))
        
        let leftLeftNode = try XCTUnwrap(leftNode.left)
        let leftLeftToken = leftLeftNode.token
        XCTAssertEqual(leftLeftToken, .Numeric(1.0))
        
        let leftRightNode = try XCTUnwrap(leftNode.right)
        let leftRightToken = leftRightNode.token
        XCTAssertEqual(leftRightToken, .Numeric(2.0))

        let rightNode = try XCTUnwrap(expression.right)
        let rightToken = rightNode.token
        XCTAssertEqual(rightToken, .Numeric(3.0))

        XCTAssertEqual(try XCTUnwrap(expression.calc()), 0.0, accuracy: 0.0001) // 1 + 2 - 3 = 0
    }
}
