@testable import SDSDataProcessor
import XCTest

final class BruteForceLexer_01Tests: XCTestCase {

    func test_One() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("1"))
        XCTAssertEqual(tokens.count, 1)
        let first = try XCTUnwrap(tokens.first)
        XCTAssertEqual(first, .numeric(1.0))
    }

    func test_PlusOne() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+1"))
        XCTAssertEqual(tokens.count, 1)
        let first = try XCTUnwrap(tokens.first)
        XCTAssertEqual(first, .numeric(1.0))
    }

    func test_MinusOne() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("-1"))
        XCTAssertEqual(tokens.count, 1)
        let first = try XCTUnwrap(tokens.first)
        XCTAssertEqual(first, .numeric(-1.0))
    }

    func test_OnePlusOne() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("1 + 1"))
        XCTAssertEqual(tokens.count, 3)
        XCTAssertEqual(tokens, [.numeric(1.0), .binaryOperator("+"), .numeric(1.0)])
    }
    
    func test_PlusOnePlusPlusOne() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+1 + +1"))
        XCTAssertEqual(tokens.count, 3)
        XCTAssertEqual(tokens, [.numeric(1.0), .binaryOperator("+"), .numeric(1.0)])
    }
    
    func test_PlusOneZeroPlusPlusOneZero() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+1.0 + +1.0"))
        XCTAssertEqual(tokens.count, 3)
        XCTAssertEqual(tokens, [.numeric(1.0), .binaryOperator("+"), .numeric(1.0)])
    }

    func test_PlusTwoZeroPlusMinusOneZero() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+2.0 + -1.0"))
        XCTAssertEqual(tokens.count, 3)
        XCTAssertEqual(tokens, [.numeric(2.0), .binaryOperator("+"), .numeric(-1.0)])
    }

    func test_PlusTwoZeroMinusMinusOneZero() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+2.0 - -1.0"))
        XCTAssertEqual(tokens.count, 3)
        XCTAssertEqual(tokens, [.numeric(2.0), .binaryOperator("-"), .numeric(-1.0)])
    }

    func test_PlusTwoZeroTimesMinusThreeZero() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+2.0 * -3.0"))
        XCTAssertEqual(tokens.count, 3)
        XCTAssertEqual(tokens, [.numeric(2.0), .binaryOperator("*"), .numeric(-3.0)])
    }

    func test_PlusSixZeroDivideMinusThreeZero() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+6.0 / -3.0"))
        XCTAssertEqual(tokens.count, 3)
        XCTAssertEqual(tokens, [.numeric(6.0), .binaryOperator("/"), .numeric(-3.0)])
    }

    func test_PlusPlusOne_ShouldFailInParser() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("+ +1"))
        XCTAssertEqual(tokens.count, 2)
        XCTAssertEqual(tokens, [.binaryOperator("+"), .numeric(1.0)])
    }

    func test_OnePlus_ShouldFailInParser() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("1.0 +"))
        XCTAssertEqual(tokens.count, 2)
        XCTAssertEqual(tokens, [.numeric(1.0), .binaryOperator("+")])
    }

    func test_15plus23_ShouldBeOK_38() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("15 + 23"))
        XCTAssertEqual(tokens.count, 3)
        XCTAssertEqual(tokens, [.numeric(15.0), .binaryOperator("+"), .numeric(23.0)])
    }
    
    func test_1dot5plus2dot3_ShouldBeOK_3dot8() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("1.5 + 2.3"))
        XCTAssertEqual(tokens.count, 3)
        XCTAssertEqual(tokens, [.numeric(1.5), .binaryOperator("+"), .numeric(2.3)])
    }

    func test_1500plus2300_ShouldBeOK_3800() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("1,500 + 2,300"))
        XCTAssertEqual(tokens.count, 3)
        XCTAssertEqual(tokens, [.numeric(1500), .binaryOperator("+"), .numeric(2300)])
    }
    
    func test_lexer_brackets_5terms() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("2.0 * 2.1 + 2.2"))
        XCTAssertEqual(tokens.count, 5)
        XCTAssertEqual(tokens, [.numeric(2.0), .binaryOperator("*"), .numeric(2.1), .binaryOperator("+"), .numeric(2.2)])
    }

    func test_lexer_brackets_7terms() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("( 2.0 * 2.1 + 2.2 )"))
        XCTAssertEqual(tokens.count, 7)
        XCTAssertEqual(tokens, [.openBracket, .numeric(2.0), .binaryOperator("*"), .numeric(2.1), .binaryOperator("+"), .numeric(2.2), .closeBracket])
    }


    func test_lexer_nestedBrackets_3terms() throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("( ( 2.0 * 2.1 ) + 2.2 )"))
        XCTAssertEqual(tokens.count, 9)
        XCTAssertEqual(tokens, [.openBracket, .openBracket, .numeric(2.0), .binaryOperator("*"), .numeric(2.1), .closeBracket,
                                .binaryOperator("+"), .numeric(2.2), .closeBracket])
    }

}
