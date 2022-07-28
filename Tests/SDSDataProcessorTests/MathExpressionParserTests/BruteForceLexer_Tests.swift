@testable import MathExpressionParser
import XCTest

final class BruteForceLexer_Tests: XCTestCase {

    func test_OnePlusOne() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("1 + 1"))
        XCTAssertEqual(tokens.count, 3)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        XCTAssertEqual(try expression.calc(), 2)
    }
    
    func test_PlusOnePlusPlusOne() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+1 + +1"))
        XCTAssertEqual(tokens.count, 3)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        XCTAssertEqual(try expression.calc(), 2)
    }
    
    func test_PlusOneZeroPlusPlusOneZero() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+1.0 + +1.0"))
        XCTAssertEqual(tokens.count, 3)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        XCTAssertEqual(try expression.calc(), 2)
    }

    func test_PlusTwoZeroPlusMinusOneZero() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+2.0 + -1.0"))
        XCTAssertEqual(tokens.count, 3)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        XCTAssertEqual(try expression.calc(), 1)
    }

    func test_PlusTwoZeroMinusMinusOneZero() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+2.0 - -1.0"))
        XCTAssertEqual(tokens.count, 3)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        XCTAssertEqual(try expression.calc(), 3)
    }

    func test_PlusTwoZeroTimesMinusThreeZero() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+2.0 * -3.0"))
        XCTAssertEqual(tokens.count, 3)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        XCTAssertEqual(try expression.calc(), -6)
    }

    func test_PlusSixZeroDivideMinusThreeZero() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+6.0 / -3.0"))
        XCTAssertEqual(tokens.count, 3)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        XCTAssertEqual(try expression.calc(), -2)
    }

    func test_PlusOne() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+1"))
        XCTAssertEqual(tokens.count, 1)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        XCTAssertEqual(try expression.calc(), 1)
    }

    func test_PlusPlusOne_ShouldFailInParser() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+ +1"))
        XCTAssertEqual(tokens.count, 2)
    }

    func test_OnePlus_ShouldFailInParser() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("1.0 +"))
        XCTAssertEqual(tokens.count, 2)
    }

    func test_15plus23_ShouldBeOK_38() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("15 + 23"))
        XCTAssertEqual(tokens.count, 3)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 38, accuracy: 0.001)
    }
    
    func test_1dot5plus2dot3_ShouldBeOK_3dot8() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("1.5 + 2.3"))
        XCTAssertEqual(tokens.count, 3)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 3.8, accuracy: 0.001)
    }

    func test_1500plus2300_ShouldBeOK_3800() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("1,500 + 2,300"))
        XCTAssertEqual(tokens.count, 3)
        let sutParser = MathExpressionParser()
        let expression = try XCTUnwrap(sutParser.parse(tokens))
        let result = try XCTUnwrap(expression.calc())
        XCTAssertEqual(result, 3800, accuracy: 0.001)
    }
    
    func test_lexer_multipleTerms_5terms() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("2.0 * 2.1 + 2.2"))
        XCTAssertEqual(tokens.count, 5)
        XCTAssertEqual(try XCTUnwrap(tokens[0].doubleValue), 2.0, accuracy: 0.0001)
        XCTAssertEqual(tokens[1].opeString, "*")
        XCTAssertEqual(try XCTUnwrap(tokens[2].doubleValue), 2.1, accuracy: 0.0001)
        XCTAssertEqual(tokens[3].opeString, "+")
        XCTAssertEqual(try XCTUnwrap(tokens[4].doubleValue), 2.2, accuracy: 0.0001)
    }

    func test_lexer_brackets_3terms() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("( 2.0 * 2.1 + 2.2 )"))
        XCTAssertEqual(tokens.count, 7)
        XCTAssertEqual(tokens[0], .OpenBracket)
        XCTAssertEqual(try XCTUnwrap(tokens[1].doubleValue), 2.0, accuracy: 0.0001)
        XCTAssertEqual(tokens[2].opeString, "*")
        XCTAssertEqual(try XCTUnwrap(tokens[3].doubleValue), 2.1, accuracy: 0.0001)
        XCTAssertEqual(tokens[4].opeString, "+")
        XCTAssertEqual(try XCTUnwrap(tokens[5].doubleValue), 2.2, accuracy: 0.0001)
        XCTAssertEqual(tokens[6], .CloseBracket)
    }


    func test_lexer_nestedBrackets_3terms() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("( ( 2.0 * 2.1 ) + 2.2 )"))
        XCTAssertEqual(tokens.count, 9)
        XCTAssertEqual(tokens[0], .OpenBracket)
        XCTAssertEqual(tokens[1], .OpenBracket)
        XCTAssertEqual(try XCTUnwrap(tokens[2].doubleValue), 2.0, accuracy: 0.0001)
        XCTAssertEqual(tokens[3].opeString, "*")
        XCTAssertEqual(try XCTUnwrap(tokens[4].doubleValue), 2.1, accuracy: 0.0001)
        XCTAssertEqual(tokens[5], .CloseBracket)
        XCTAssertEqual(tokens[6].opeString, "+")
        XCTAssertEqual(try XCTUnwrap(tokens[7].doubleValue), 2.2, accuracy: 0.0001)
        XCTAssertEqual(tokens[8], .CloseBracket)
    }

}
