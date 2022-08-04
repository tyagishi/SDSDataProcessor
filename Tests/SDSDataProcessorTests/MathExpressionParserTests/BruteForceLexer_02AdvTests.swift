@testable import SDSDataProcessor
import XCTest

final class BruteForceLexer_02AdvTests: XCTestCase {

    func test_PlusOne() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+1"))
        XCTAssertEqual(tokens.count, 1)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        XCTAssertEqual(try expression.calc(), 1)
    }

    
    func test_OnePlusOne() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("1+1"))
        XCTAssertEqual(tokens.count, 3)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        XCTAssertEqual(try expression.calc(), 2)
    }
}
