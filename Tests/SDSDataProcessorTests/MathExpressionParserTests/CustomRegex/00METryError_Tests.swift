//
//  00METryError_Tests.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/08/12.
//

import XCTest
import RegexBuilder
@testable import SDSDataProcessor

final class _0METryError_Tests: XCTestCase {

    func test_ME() async throws {
        let sut = Regex<MathExpressionToken> {
            MENumericTerm(locale: .init(identifier: "ja-JP"))
        }
        
        let simpleMatch = try sut.wholeMatch(in: "12.34")
        var output = try XCTUnwrap(simpleMatch?.output)
        XCTAssertEqual(output, MathExpressionToken.numeric(12.34, "12.34"))

        let simpleMatch2 = try sut.wholeMatch(in: "-12.34")
        output = try XCTUnwrap(simpleMatch2?.output)
        XCTAssertEqual(output, MathExpressionToken.numeric(-12.34, "-12.34"))

        let plusMatch = try sut.wholeMatch(in: "+12.34")
        output = try XCTUnwrap(plusMatch?.output)
        XCTAssertEqual(output, MathExpressionToken.numeric(12.34, "+12.34"))

        let groupMatch = try sut.wholeMatch(in: "+1,234.5")
        output = try XCTUnwrap(groupMatch?.output)
        XCTAssertEqual(output, MathExpressionToken.numeric(1234.5, "+1,234.5"))
    }

}
