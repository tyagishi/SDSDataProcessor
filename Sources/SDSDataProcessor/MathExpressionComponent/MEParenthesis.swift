//
//  MEParenthesis.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/08/12.
//

import Foundation
#if canImport(RegexBuilder)
import RegexBuilder

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct MEOpenParenthesis: CustomConsumingRegexComponent {
    public typealias RegexOutput = METoken
    
    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        let regex = Regex {
            ChoiceOf {
                "("
                "["
                "{"
            }
        }
        if let match = try regex.prefixMatch(in: input[index..<bounds.upperBound]) {
            return (match.range.upperBound, .openParenthesis(String(match.output)))
        }
        return nil
    }
}

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct MECloseParenthesis: CustomConsumingRegexComponent {
    public typealias RegexOutput = METoken
    
    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        let regex = Regex {
            ChoiceOf {
                ")"
                "]"
                "}"
            }
        }
        if let match = try regex.prefixMatch(in: input[index..<bounds.upperBound]) {
            return (match.range.upperBound, .closeParenthesis(String(match.output)))
        }
        return nil
    }
}

#endif
