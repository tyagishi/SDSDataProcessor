@testable import SDSDataProcessor
import XCTest

final class MathExpressionParser_05BracketsBasic: XCTestCase {

    func test_parse_openBranket_only() throws {
        let tokens = [Token.OpenBracket]
        let sut = MathExpressionParser()
        
        XCTAssertThrowsError(try sut.parse(tokens)) { exception in
            print("OK")
        }
    }
    func test_parse_openBranketAndNumeric_only() throws {
        let tokens = [Token.OpenBracket, Token.Numeric(1.0)]
        let sut = MathExpressionParser()
        
        XCTAssertThrowsError(try sut.parse(tokens)) { exception in

        }
    }
    func test_parse_oneBranketedNumeric() throws {
        let tokens = [Token.OpenBracket, Token.Numeric(1.0), Token.CloseBracket]
        let sut = MathExpressionParser()
        
        let expression = try XCTUnwrap(sut.parse(tokens))
        XCTAssertEqual(try expression.calc(), 1.0)

    }
}
