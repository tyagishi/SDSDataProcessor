//
//  FilterLexer_Tests.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/21
//  © 2024  SmallDeskSoftware
//

import XCTest
@testable import SDSDataProcessor

final class FilterLexer_Tests: XCTestCase {
    
    func test_init() async throws {
        let sut = FilterLexer(chars: nil, scanTokens: ["Hello", "World"], caseSensitive: false)
        XCTAssertNotNil(sut)
    }
    
    func test_filter_withTokens() async throws {
        let sut = FilterLexer(chars: nil, scanTokens: ["Hello", "World"], caseSensitive: false)

        let result = try sut.filter("Hello Japan, Hello Germany, Hello World")
        XCTAssertEqual(result.string, "HelloHelloHelloWorld")
        XCTAssertEqual(result.disposed, " Japan,  Germany,  ")
    }

    func test_filter_withChars() async throws {
        let sut = FilterLexer(chars: CharacterSet.letters, scanTokens: nil, caseSensitive: false)

        let result = try sut.filter("Hello Japan, Hello Germany, Hello World")
        XCTAssertEqual(result.string, "HelloJapanHelloGermanyHelloWorld")
        XCTAssertEqual(result.disposed, " ,  ,  ")
    }

    func test_filter_mathExpression() async throws {
        let sut = FilterLexer(chars: MathExpression.mathExpressionCharacterSet,
                              scanTokens: MathExpression.mathExpressionTokens)

        let result = try sut.filter("1Kg + 2Kg =")
        XCTAssertEqual(result.string, "1+2=")
        XCTAssertEqual(result.disposed, "Kg  Kg ")
    }
}
