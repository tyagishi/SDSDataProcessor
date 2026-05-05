//
//  MEVariableTerm_Tests.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/08/12.
//

import XCTest
@testable import SDSDataProcessor

final class MEVariableTerm_Tests: XCTestCase {

    func test_MEVariableTerm() async throws {
        let sut = Regex {
            MEVariableTerm(variableNames: ["x", "y"])
        }
        
        let simpleMatch = try sut.wholeMatch(in: "x")
        var output = try XCTUnwrap(simpleMatch?.output)
        XCTAssertEqual(output, .variable("x"))

        let anotherMatch = try sut.wholeMatch(in: "y")
        output = try XCTUnwrap(anotherMatch?.output)
        XCTAssertEqual(output, .variable("y"))

        let unkownMatch = try sut.wholeMatch(in: "z")
        XCTAssertNil(unkownMatch)
    }

}
