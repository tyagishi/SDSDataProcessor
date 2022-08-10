@testable import SDSDataProcessor
import XCTest

final class MathExpressionParser_99BugTests: XCTestCase {

    func test_BugAt20220729() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("1 + 2 * 3 * 4"))
        XCTAssertEqual(tokens.count, 7)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 25, accuracy: 0.001)
    }
    func test_BugAt20220730() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("(1+2)+3"))
        XCTAssertEqual(tokens.count, 7)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 6, accuracy: 0.001)
    }
    func test_BugAt20220731() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("(1+2)+3 "))
        XCTAssertEqual(tokens.count, 7)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 6, accuracy: 0.001)
    }
    func test_BugAt20220731_2() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex(" (1+2)+3 "))
        XCTAssertEqual(tokens.count, 7)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 6, accuracy: 0.001)
    }
    func test_BugAt20220802() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("(1+"))
        XCTAssertEqual(tokens.count, 3)
        let sutParser = MathExpressionParser()
        XCTAssertThrowsError(try sutParser.parse(tokens)) { exception in
            //print("shouldThrow")
        }
    }
    func test_BugAt20220810() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("1+sin(45)"))
        XCTAssertEqual(tokens.count, 5)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 1.70710678, accuracy: 0.001) // 1 + sin(45)
    }
}
