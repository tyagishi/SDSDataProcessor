//
//  MassExpressionNumericTerm_Tests.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/01/16.
//

import XCTest
@testable import SDSDataProcessor

final class MassExpressionNumericTerm_Tests: XCTestCase {

    func test_MassExpressionNumericTerm_simple() async throws {
        let sut = Regex {
            MathExpressionNumericTerm(locale: .init(identifier: "ja-JP"))
        }
        
        let simpleMatch = try sut.wholeMatch(in: "12.34")
        var output = try XCTUnwrap(simpleMatch?.numericValues)
        XCTAssertEqual(output.0, 12.34, accuracy: 0.0001)
        XCTAssertEqual(output.1, "12.34")

        let plusMatch = try sut.wholeMatch(in: "+12.34")
        output = try XCTUnwrap(plusMatch?.numericValues)
        XCTAssertEqual(output.0, 12.34, accuracy: 0.0001)
        XCTAssertEqual(output.1, "+12.34")

        let groupMatch = try sut.wholeMatch(in: "+1,234.5")
        output = try XCTUnwrap(groupMatch?.numericValues)
        XCTAssertEqual(output.0, 1234.5, accuracy: 0.0001)
        XCTAssertEqual(output.1, "+1,234.5")
    }
}
