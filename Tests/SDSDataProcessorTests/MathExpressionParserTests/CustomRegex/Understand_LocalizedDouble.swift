//
//  Understand_LocalizedDouble.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/01/10.
//

import XCTest
import RegexBuilder
@testable import SDSDataProcessor

final class Understand_LocalizedDouble: XCTestCase {

    func test_Trial_00() async throws {
        let value = Reference(Double.self)
        let sut = Regex {
            Optionally("+",
                       .reluctant)
            Capture(as: value, {
                FloatingPointFormatStyle.localizedDouble(locale: Locale.init(identifier: "ja-JP"))
            })
        }

        let match = try sut.wholeMatch(in: "15")
        var output = try XCTUnwrap(match?[value])
        XCTAssertEqual(output, 15.0, accuracy: 0.001)

        let matchPlus = try sut.wholeMatch(in: "+15")
        output = try XCTUnwrap(matchPlus?[value])
        XCTAssertEqual(output, 15.0, accuracy: 0.001)
        
        let matchMinus = try sut.wholeMatch(in: "-15")
        output = try XCTUnwrap(matchMinus?[value])
        XCTAssertEqual(output, -15.0, accuracy: 0.001)
    }
    
    func test_TryCheck_00() async throws {
        let value = Reference(Double.self)
        
        let base = Regex {
            Optionally("+",
                       .reluctant)
            FloatingPointFormatStyle.localizedDouble(locale: Locale.init(identifier: "ja-JP"))
        }
        
        let sut = Regex {
            TryCapture(base, as: value, transform: { substring -> Double? in
                //let groupSep = Locale.current.decimalSeparator ?? ","
                let string = substring
                let numString = string.replacingOccurrences(of: ",", with: "")
                //let subNumString = try substring.filter({ $0 != groupSep })
                //if let check = try? substring.filter({ $0 != groupSep }) { return 0 }
                return Double(numString)
            })
        }
        
        let noMatch = try sut.wholeMatch(in: "$15")
        XCTAssertNil(noMatch)
        
        let match = try sut.wholeMatch(in: "15")
        var output = try XCTUnwrap(match?[value])
        XCTAssertEqual(output, 15.0, accuracy: 0.001)

        let matchPlus = try sut.wholeMatch(in: "+15")
        output = try XCTUnwrap(matchPlus?[value])
        XCTAssertEqual(output, 15.0, accuracy: 0.001)

        let matchPlusDot = try sut.wholeMatch(in: "+123.45")
        output = try XCTUnwrap(matchPlusDot?[value])
        XCTAssertEqual(output, 123.45, accuracy: 0.001)

        let matchMinus = try sut.wholeMatch(in: "-15")
        output = try XCTUnwrap(matchMinus?[value])
        XCTAssertEqual(output, -15.0, accuracy: 0.001)
        
        let matchGroupSep = try sut.wholeMatch(in: "1,000")
        output = try XCTUnwrap(matchGroupSep?[value])
        XCTAssertEqual(output, 1000.0, accuracy: 0.001)
        XCTAssertNotNil(matchGroupSep)
    }
    
    func test_localizedDouble_Simple() async throws {
        let sut = Regex {
            .localizedDouble(locale: Locale.init(identifier: "ja-JP"))
        }
        
        let matchDigitOnly = try sut.wholeMatch(in: "12345")
        let output = try XCTUnwrap(matchDigitOnly?.output)
        XCTAssertEqual(output, 12345, accuracy: 0.001)
    }
    
    func test_localizedDouble_Dot() async throws {
        let sut = Regex {
            .localizedDouble(locale: Locale.init(identifier: "ja-JP"))
        }
        
        let matchDigitDotDigit = try sut.wholeMatch(in: "123.45")
        let output = try XCTUnwrap(matchDigitDotDigit?.output)
        XCTAssertEqual(output, 123.45, accuracy: 0.001)
        
        let matchDigitDotDigitDotDigital = try sut.wholeMatch(in: "123.45.67")
        XCTAssertNil(matchDigitDotDigitDotDigital)
    }
    
    func test_localizedDouble_Comma() async throws {
        let sut = Regex {
            .localizedDouble(locale: Locale.init(identifier: "ja-JP"))
        }
        
        let matchDigitCommaDigit = try sut.wholeMatch(in: "1,123")
        let output = try XCTUnwrap(matchDigitCommaDigit?.output)
        XCTAssertEqual(output, 1123, accuracy: 0.001)
        
        let matchDigitCommaDigitInvalidCommnaDigit = try sut.wholeMatch(in: "1,234,56")
        XCTAssertNil(matchDigitCommaDigitInvalidCommnaDigit)
    }
    
    func test_localizedDouble_CommaDot() async throws {
        let sut = Regex {
            .localizedDouble(locale: Locale.init(identifier: "ja-JP"))
        }
        
        let matchDigitCommaDigitDotDigit = try sut.wholeMatch(in: "1,123.45")
        let output = try XCTUnwrap(matchDigitCommaDigitDotDigit?.output)
        XCTAssertEqual(output, 1123.45, accuracy: 0.001)
        
        let matchDigitDotDigitalComma = try sut.wholeMatch(in: "1.123,45")
        XCTAssertNil(matchDigitDotDigitalComma)
        
    }
    
    func test_localizedDouble_scientific() async throws {
        let sut = Regex {
            .localizedDouble(locale: Locale.init(identifier: "ja-JP"))
        }

        let matchDigitEDigit = try sut.wholeMatch(in: "1.5e3")
        var output = try XCTUnwrap(matchDigitEDigit?.output)
        XCTAssertEqual(output, 1500, accuracy: 0.001)

        let matchDigitEDigitMinus = try sut.wholeMatch(in: "1.5e-3")
        output = try XCTUnwrap(matchDigitEDigitMinus?.output)
        XCTAssertEqual(output, 0.0015, accuracy: 0.0001)

        let matchMinusDigitEDigit = try sut.wholeMatch(in: "-1.5e3")
        output = try XCTUnwrap(matchMinusDigitEDigit?.output)
        XCTAssertEqual(output, -1500, accuracy: 0.001)

        let matchMinusDigitEDigitMinus = try sut.wholeMatch(in: "-1.5e-3")
        output = try XCTUnwrap(matchMinusDigitEDigitMinus?.output)
        XCTAssertEqual(output, -0.0015, accuracy: 0.0001)

        let matchPlusDigitEDigit = try sut.wholeMatch(in: "+1.5e3")
        XCTAssertNil(matchPlusDigitEDigit)
        //output = try XCTUnwrap(matchPlusDigitEDigit?.output)
        //XCTAssertEqual(output, 1500, accuracy: 0.001)

        let matchPlusDigitEDigitMinus = try sut.wholeMatch(in: "+1.5e-3")
        XCTAssertNil(matchPlusDigitEDigitMinus)
        //output = try XCTUnwrap(matchPlusDigitEDigitMinus?.output)
        //XCTAssertEqual(output, 0.0015, accuracy: 0.0001)

    }
    
    func test_localizedDouble_plusMinus() async throws {
        let sut = Regex {
            .localizedDouble(locale: Locale.init(identifier: "ja-JP"))
        }
        
        let matchPlusDigitDot = try sut.wholeMatch(in: "+12345.")
        XCTAssertNil(matchPlusDigitDot)
        //var output = try XCTUnwrap(matchPlusDigitDot?.output)
        //XCTAssertEqual(output, 12345, accuracy: 0.001)
        
        let matchPlusDigitDotDigit = try sut.wholeMatch(in: "+123.45")
        XCTAssertNil(matchPlusDigitDotDigit)
        //var output = try XCTUnwrap(matchPlusDigitDotDigit?.output)
        //XCTAssertEqual(output, 123.45, accuracy: 0.001)
        
        let matchPlusDotDigit = try sut.wholeMatch(in: "+.12345")
        XCTAssertNil(matchPlusDotDigit)
        //output = try XCTUnwrap(matchPlusDotDigit?.output)
        //XCTAssertEqual(output, 0.12345, accuracy: 0.001)

        let matchMinusDigitDot = try sut.wholeMatch(in: "-12345.")
        var output = try XCTUnwrap(matchMinusDigitDot?.output)
        XCTAssertEqual(output, -12345, accuracy: 0.001)
        let matchMinusDigitDotDigit = try sut.wholeMatch(in: "-123.45")
        output = try XCTUnwrap(matchMinusDigitDotDigit?.output)
        XCTAssertEqual(output, -123.45, accuracy: 0.001)
        let matchMinusDotDigit = try sut.wholeMatch(in: "-.12345")
        output = try XCTUnwrap(matchMinusDotDigit?.output)
        XCTAssertEqual(output, -0.12345, accuracy: 0.001)
    }
    
    func test_localizedDouble_plusMinus_enUS() async throws {
        let sut = Regex {
            .localizedDouble(locale: Locale.init(identifier: "en-US"))
        }
        
        let matchPlusDigitDot = try sut.wholeMatch(in: "+12345.")
        XCTAssertNil(matchPlusDigitDot)
        //var output = try XCTUnwrap(matchPlusDigitDot?.output)
        //XCTAssertEqual(output, 12345, accuracy: 0.001)
        
        let matchPlusDigitDotDigit = try sut.wholeMatch(in: "+123.45")
        XCTAssertNil(matchPlusDigitDotDigit)
        //var output = try XCTUnwrap(matchPlusDigitDotDigit?.output)
        //XCTAssertEqual(output, 123.45, accuracy: 0.001)
        
        let matchPlusDotDigit = try sut.wholeMatch(in: "+.12345")
        XCTAssertNil(matchPlusDotDigit)
        //output = try XCTUnwrap(matchPlusDotDigit?.output)
        //XCTAssertEqual(output, 0.12345, accuracy: 0.001)

        let matchMinusDigitDot = try sut.wholeMatch(in: "-12345.")
        var output = try XCTUnwrap(matchMinusDigitDot?.output)
        XCTAssertEqual(output, -12345, accuracy: 0.001)
        let matchMinusDigitDotDigit = try sut.wholeMatch(in: "-123.45")
        output = try XCTUnwrap(matchMinusDigitDotDigit?.output)
        XCTAssertEqual(output, -123.45, accuracy: 0.001)
        let matchMinusDotDigit = try sut.wholeMatch(in: "-.12345")
        output = try XCTUnwrap(matchMinusDotDigit?.output)
        XCTAssertEqual(output, -0.12345, accuracy: 0.001)
    }

    func test_localiedDecimal_Simple() async throws {
        let sut = Regex {
            .localizedDecimal(locale: Locale.init(identifier: "ja-JP"))
        }

        // without Dot/GroupSep/Sign
        let matchDigitOnly = try sut.wholeMatch(in: "12345")
        XCTAssertNotNil(matchDigitOnly)

        // with Dot without GroupSep/Sign
        let matchDigitDot = try sut.wholeMatch(in: "12345.")
        XCTAssertNotNil(matchDigitDot)
        let matchDigitDotDigit = try sut.wholeMatch(in: "123.45")
        XCTAssertNotNil(matchDigitDotDigit)
        let matchDotDigit = try sut.wholeMatch(in: ".12345")
        XCTAssertNotNil(matchDotDigit)

        // with sign
        let matchPlus = try sut.wholeMatch(in: "+12345")
        XCTAssertNil(matchPlus) // NOTE: parser can not accept + sign ....
        let matchMinus = try sut.wholeMatch(in: "-12345")
        XCTAssertNotNil(matchMinus)

        // with GroupSep
        let matchGroupSep = try sut.wholeMatch(in: "1,000")
        XCTAssertNotNil(matchGroupSep)
        let matchTwoGroupSep = try sut.wholeMatch(in: "1,000,000")
        XCTAssertNotNil(matchTwoGroupSep)
        let matchInvalidGroupSep = try sut.wholeMatch(in: "1,00,0000")
        XCTAssertNil(matchInvalidGroupSep) // NOTE: parser reject invalid group sep.
    }
    
    func test_SignableNumeric_Simple() async throws {
        let sut = Regex {
            SignableLocalizedDouble(locale: .init(identifier: "ja-JP"))
//        Optionally { "+" }
//        FloatingPointFormatStyle<Double>.localizedDouble(locale: Locale.init(identifier: "ja-JP"))
        }

        // without Dot/GroupSep/Sign
        let matchDigitOnly = try sut.wholeMatch(in: "12345")
        var output = try XCTUnwrap(matchDigitOnly?.output)
        XCTAssertEqual(output, 12345, accuracy: 0.001)

        // with Dot without GroupSep/Sign
        let matchDigitDot = try sut.wholeMatch(in: "12345.")
        XCTAssertNotNil(matchDigitDot)
        let matchDigitDotDigit = try sut.wholeMatch(in: "123.45")
        XCTAssertNotNil(matchDigitDotDigit)
        let matchDotDigit = try sut.wholeMatch(in: ".12345")
        XCTAssertNotNil(matchDotDigit)

        // with sign
        let matchPlus = try sut.wholeMatch(in: "+12345")
        output = try XCTUnwrap(matchPlus?.output)
        XCTAssertEqual(output, 12345, accuracy: 0.001)

        let matchMinus = try sut.wholeMatch(in: "-12345")
        output = try XCTUnwrap(matchMinus?.output)
        XCTAssertEqual(output, -12345, accuracy: 0.001)

        // invalid +- should be rejected
        let matchPlusMinus = try sut.wholeMatch(in: "+-12345")
        XCTAssertNil(matchPlusMinus)

        let matchMinusPlus = try sut.wholeMatch(in: "-+12345")
        XCTAssertNil(matchMinusPlus) // can not parse - following +

        // with GroupSep
        let matchGroupSep = try sut.wholeMatch(in: "1,000")
        output = try XCTUnwrap(matchGroupSep?.output)
        XCTAssertEqual(output, 1000, accuracy: 0.001)

        let matchTwoGroupSep = try sut.wholeMatch(in: "1,000,000")
        output = try XCTUnwrap(matchTwoGroupSep?.output)
        XCTAssertEqual(output, 1000000, accuracy: 0.001)

        let matchInvalidGroupSep = try sut.wholeMatch(in: "1,00,0000")
        XCTAssertNil(matchInvalidGroupSep) // NOTE: parser reject invalid group sep, since .localiedDouble also reject this
    }

    func test_localizedDouble_DotSign() async throws {
        let sut = Regex {
            SignableLocalizedDouble(locale: .init(identifier: "ja-JP"))
        }

        let matchPlusDigitDot = try sut.wholeMatch(in: "+12345.")
        var output = try XCTUnwrap(matchPlusDigitDot?.output)
        XCTAssertEqual(output, 12345, accuracy: 0.001)
        let matchPlusDigitDotDigit = try sut.wholeMatch(in: "+123.45")
        output = try XCTUnwrap(matchPlusDigitDotDigit?.output)
        XCTAssertEqual(output, 123.45, accuracy: 0.001)
        let matchPlusDotDigit = try sut.wholeMatch(in: "+.12345")
        output = try XCTUnwrap(matchPlusDotDigit?.output)
        XCTAssertEqual(output, 0.12345, accuracy: 0.001)

        let matchMinusDigitDot = try sut.wholeMatch(in: "-12345.")
        output = try XCTUnwrap(matchMinusDigitDot?.output)
        XCTAssertEqual(output, -12345, accuracy: 0.001)
        let matchMinusDigitDotDigit = try sut.wholeMatch(in: "-123.45")
        output = try XCTUnwrap(matchMinusDigitDotDigit?.output)
        XCTAssertEqual(output, -123.45, accuracy: 0.001)
        let matchMinusDotDigit = try sut.wholeMatch(in: "-.12345")
        output = try XCTUnwrap(matchMinusDotDigit?.output)
        XCTAssertEqual(output, -0.12345, accuracy: 0.001)
    }

}
