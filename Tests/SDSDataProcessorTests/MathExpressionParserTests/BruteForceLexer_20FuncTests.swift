@testable import SDSDataProcessor
import XCTest

final class BruteForceLexer_20FuncTests: XCTestCase {

    func test_power_simple01() async throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("sin(45)"))
        XCTAssertEqual(tokens.count, 4)
    }
}
