//
//  Understand_CustomConsumingRegexComponent.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/01/09.
//

import XCTest
import RegexBuilder
@testable import SDSDataProcessor

final class Understand_CustomConsumingRegexComponent: XCTestCase {
    
    func test_firstMatch() async throws {
        let string = "Hello World, Hello again"
        let sut: Regex<String.RegexOutput> = Regex {
            "Hello"
        }
        
        let match: Regex<String.RegexOutput>.Match? = try? sut.firstMatch(in: string)
        XCTAssertNotNil(match)
        XCTAssertEqual(string[match!.range], "Hello")
        
        XCTAssertEqual(match!.range.lowerBound, string.startIndex)
        let endOfHello = string.index(string.startIndex, offsetBy: 5)
        XCTAssertEqual(match!.range.upperBound, endOfHello)
        let check12 = match!.startIndex
        let check123 = match!.output
        
        XCTAssertEqual(match!.range.lowerBound, match!.output.startIndex)
        XCTAssertEqual(match!.range.upperBound, match!.output.endIndex)

        let checkMatch = try? sut.matches(string, in: string.fullRange)
        //let checkMatch = string.matches(of: sut)
        XCTAssertEqual(checkMatch?.count, 2)
        
        var anotherString = string
        anotherString.replaceSubrange(match!.range, with: "こんにちわ")
        
        XCTAssertEqual(anotherString, "こんにちわ World, Hello again")
        
        
    }
    
    func test_prefixMatch() async throws {
        let string = "Hello World, Hello again"
        let helloRegex = Regex {
            "Hello"
        }
        
        let helloMatch = try? helloRegex.prefixMatch(in: string)
        XCTAssertEqual(string[helloMatch!.range], "Hello")

        let worldRegex = Regex {
            "World"
        }
        
        let worldMatch = try? worldRegex.prefixMatch(in: string)
        XCTAssertNil(worldMatch)
        
        let offset = string.index(string.startIndex, offsetBy: 6)
        let worldSubMatch = try? worldRegex.prefixMatch(in: string[offset...])
        XCTAssertNotNil(worldSubMatch)
    }
    
    func test_wholeMatch() async throws {
        let string = "Hello World"

        let helloRegex = Regex {
            "Hello"
        }
        let helloMatch = try? helloRegex.wholeMatch(in: string)
        XCTAssertNil(helloMatch)

        let helloWorldRegex = Regex {
            "Hello World"
        }
        let helloWorldMatch = try? helloWorldRegex.wholeMatch(in: string)
        XCTAssertNotNil(helloWorldMatch)
    }

    
    func test_contains() async throws {
//        let string = "Hello World, Hello again"
        let refHello = Reference(Substring.self)
        let sut = Regex {
            Capture(as: refHello) {
                "Hello"
            }
        }
        
        let result = sut.contains(captureNamed: "Hello")
        XCTAssertFalse(result)
    }

//    func testBasic_01() async throws {
//        let string = "HelloWorld"
//        
//        let sut = MathExpressionRegexComponent()
//
//        let result = try? sut.consuming(string, startingAt: string.startIndex, in: string.fullRange)
//        
//        XCTAssertNil(result)
//    }
//    
//    func test_asRegex_01() async throws {
//        let string = "+++"
//        
//        let check = Regex {
//            PlusRegexComponent()
//        }
//        
//        let match = try check.wholeMatch(in: string)
//        let check1 = match?.output
//        XCTAssertEqual(match?.count, 3)
//        print(match)
//    }
//    
//    func test_localizedDouble_01() async throws {
//        let num1 = "123.456789"
//        let num2 = "1.0e-3"
//        
//        let sut = Regex {
//            One(.localizedDouble(locale: Locale(languageCode: .japanese, languageRegion: .japan)))
//        }
//        
//        let match1 = try sut.wholeMatch(in: num1)
//        print("\(match1)")
//        let match2 = try sut.wholeMatch(in: num2)
//        print("\(match2)")
//
//    }
}
