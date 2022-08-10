@testable import SDSDataProcessor
import XCTest

final class BruteForceLexer_20FuncTests: XCTestCase {

    func test_power_sinOnly() async throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("sin(45)"))
        XCTAssertEqual(tokens.count, 3)
    }
    func test_power_sinAndPlus() async throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("sin(45)+1"))
        XCTAssertEqual(tokens.count, 5)
    }
}
