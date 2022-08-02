@testable import SDSDataProcessor
import XCTest

final class BruteForceLexer_PowerTests: XCTestCase {

    func test_power_simple01() async throws {
        let sut = BruteForceLexer()
        let tokens = try XCTUnwrap(sut.lex("2^3"))
        XCTAssertEqual(tokens.count, 3)
    }
}
