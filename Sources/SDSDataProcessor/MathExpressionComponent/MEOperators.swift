//
//  File.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/08/12.
//

import Foundation
#if canImport(RegexBuilder)
import RegexBuilder

extension METoken {
    static func binaryOperatorToken(_ rawValue: String) -> METoken? {
        switch rawValue {
        case "+", "-", "*", "/", "^":
            return .binaryOperator(rawValue)
        default:
            return nil
        }
    }
}

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct MEBinaryOperator: CustomConsumingRegexComponent {
    public typealias RegexOutput = METoken
    
    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        let regex = Regex {
            ZeroOrMore(.whitespace)
            ChoiceOf {
                "+"
                "-"
                "*"
                "/"
                "^"
            }
        }
        if let match = try regex.prefixMatch(in: input[index..<bounds.upperBound]),
           let opeTerm = METoken.binaryOperatorToken(String(match.output)) {
            return (match.range.upperBound, opeTerm)
        }
        return nil
    }
}

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct MEUnaryOperator: CustomConsumingRegexComponent {
    public typealias RegexOutput = METoken
    
    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        let regex = Regex {
            ChoiceOf {
                "+"
                "-"
                "*"
                "/"
                "^"
            }
        }
        if let match = try regex.prefixMatch(in: input[index..<bounds.upperBound]),
           let opeTerm = METoken.binaryOperatorToken(String(match.output)) {
            return (match.range.upperBound, opeTerm)
        }
        return nil
    }
}
#endif
