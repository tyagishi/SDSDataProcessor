@testable import SDSDataProcessor
import XCTest

final class BruteForceLexer_BugTests: XCTestCase {

    func test_BugAt20220729() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("1 + 2 * 3 * 4"))
        XCTAssertEqual(tokens.count, 7)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 25, accuracy: 0.001)
    }
}
