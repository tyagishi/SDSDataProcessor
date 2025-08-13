//
//  MassExpressionNumericTerm_Tests.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/01/16.
//

import XCTest
import RegexBuilder

@testable import SDSDataProcessor

final class MENumericTerm_Tests: XCTestCase {

    func test_MENumericTerm() async throws {
        let sut = Regex<METoken> {
            MENumericTerm(locale: .init(identifier: "ja-JP"))
        }
        
        let simpleMatch = try sut.wholeMatch(in: "12.34")
        var output = try XCTUnwrap(simpleMatch?.output)
        XCTAssertEqual(output, METoken.numeric(12.34, "12.34"))
        
//        var evalResult = try 

        let simpleMatch2 = try sut.wholeMatch(in: "-12.34")
        output = try XCTUnwrap(simpleMatch2?.output)
        XCTAssertEqual(output, METoken.numeric(-12.34, "-12.34"))

        let plusMatch = try sut.wholeMatch(in: "+12.34")
        output = try XCTUnwrap(plusMatch?.output)
        XCTAssertEqual(output, METoken.numeric(12.34, "+12.34"))

        let groupMatch = try sut.wholeMatch(in: "+1,234.5")
        output = try XCTUnwrap(groupMatch?.output)
        XCTAssertEqual(output, METoken.numeric(1234.5, "+1,234.5"))
    }
}
