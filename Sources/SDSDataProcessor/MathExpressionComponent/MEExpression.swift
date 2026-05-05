//
//  File.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/08/13.
//

import Foundation
#if canImport(RegexBuilder)
import RegexBuilder

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct MEExpression: CustomConsumingRegexComponent {
    public typealias RegexOutput = [METoken]
    let locale: Locale
    let variableNames: [String]

    public init(locale: Locale, variableNames: [String] = []) {
        self.locale = locale
        self.variableNames = variableNames
    }

    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        let spaceRegex = Regex({ OneOrMore(.whitespace) })
        let openRegex = Regex({ MEOpenParenthesis() })
        let closeRegex = Regex({ MECloseParenthesis() })
        let numericRegx = Regex({ MENumericTerm(locale: locale) })
        let varRegx = Regex({ MEVariableTerm(variableNames: variableNames) })
        let binOpeRegex = Regex({ MEBinaryOperator() })

        var foundTokens: [METoken] = []
        var startIndex = index
        while startIndex < bounds.upperBound {
            if let match = try spaceRegex.prefixMatch(in: input[startIndex..<bounds.upperBound]) {
                // consume white space
                startIndex = match.range.upperBound
            } else if let match = try openRegex.prefixMatch(in: input[startIndex..<bounds.upperBound]) {
                foundTokens.append(match.output)
                startIndex = match.range.upperBound
            } else if let match = try closeRegex.prefixMatch(in: input[startIndex..<bounds.upperBound]) {
                foundTokens.append(match.output)
                startIndex = match.range.upperBound
            } else if let match = try numericRegx.prefixMatch(in: input[startIndex..<bounds.upperBound]) {
                foundTokens.append(match.output)
                startIndex = match.range.upperBound
            } else if let match = try varRegx.prefixMatch(in: input[startIndex..<bounds.upperBound]) {
                foundTokens.append(match.output)
                startIndex = match.range.upperBound
            } else if let match = try binOpeRegex.prefixMatch(in: input[startIndex..<bounds.upperBound]) {
                foundTokens.append(match.output)
                startIndex = match.range.upperBound
            } else {
                break
            }
        }
        if foundTokens.isEmpty { return nil }
        return (startIndex, foundTokens)
    }
}
#endif
