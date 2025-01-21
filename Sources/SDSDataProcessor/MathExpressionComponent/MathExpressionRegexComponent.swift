//
//  MathExpressionRegexComponent.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/01/09.
//

import Foundation

#if canImport(RegexBuilder)

import RegexBuilder

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension Regex {
    public func matches(_ input: String, in bounds: Range<String.Index>,
                        needNext: (Regex<Output>.Match) -> Bool = { _ in true }) throws -> [Regex<Output>.Match] {
        var result: [Regex<Output>.Match] = []
        var currentIndex = bounds.lowerBound
        while let match = try self.firstMatch(in: input[currentIndex..<bounds.upperBound]) {
            result.append(match)
            currentIndex = match.range.upperBound
            guard currentIndex < bounds.upperBound else { break }
            guard currentIndex < input.endIndex else { break }
            guard needNext(match) else { break }
        }
        
        return result
    }
}

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct MathExpressionTerm: CustomConsumingRegexComponent {
    public typealias RegexOutput = MathExpressionToken
    let locale: Locale
    let variableNames: [String]
    
    public init(locale: Locale, variableNames: [String] = []) {
        self.locale = locale
        self.variableNames = variableNames
    }
    
    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        let tokenValue = Reference(MathExpressionToken.self)
        let numeritTermRegex = Regex {
            Optionally("+",
                       .reluctant)
            FloatingPointFormatStyle.localizedDouble(locale: Locale.init(identifier: "ja-JP"))
        }
        let varName = Reference(MathExpressionToken.self)
        
        let variableTermRegex = Regex {
            MathExpressionVariableTerm(variableNames: variableNames)
        }

        let regex = Regex<(Substring, MathExpressionToken?, MathExpressionToken?)> {//}, MathExpressionToken?)> {
            ChoiceOf {
                TryCapture(numeritTermRegex, as: tokenValue, transform: { substring -> MathExpressionToken? in
                    let groupSep = locale.groupingSeparator ?? ""
                    let string = substring
                    let numString = string.replacingOccurrences(of: groupSep, with: "")
                    guard let value = Double(numString) else { return nil }
                    return MathExpressionToken.numeric(value, String(substring))
                })
                TryCapture(variableTermRegex, as: varName, transform: { substring -> MathExpressionToken? in
                    return MathExpressionToken.variable(substring)
                })
            }
        }
        if let match = try regex.prefixMatch(in: input[index..<bounds.upperBound]) {
            if let numToken = match.1 {
                return (match.range.upperBound, numToken)
            } else if let varToken = match.2 {
                return (match.range.upperBound, varToken)
            }
        }
        return nil
    }
}

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct MathExpressionNumericTerm: CustomConsumingRegexComponent {
    public typealias RegexOutput = MathExpressionToken
    let locale: Locale
    
    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        let dblValue = Reference(Double.self)
        
        let numeritTermRegex = Regex {
            Optionally("+",
                       .reluctant)
            FloatingPointFormatStyle.localizedDouble(locale: Locale.init(identifier: "ja-JP"))
        }
        
        let regex = Regex<(Substring, Double)> {
            TryCapture(numeritTermRegex, as: dblValue, transform: { substring -> Double? in
                let groupSep = locale.groupingSeparator ?? ""
                let string = substring
                let numString = string.replacingOccurrences(of: groupSep, with: "")
                return Double(numString)
            })
        }

        if let match = try regex.prefixMatch(in: input[index..<bounds.upperBound]) {
            return (match.range.upperBound, MathExpressionToken.numeric(match.1, String(match.0)))
        }
        return nil
    }
}

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct MathExpressionVariableTerm: CustomConsumingRegexComponent {
    public typealias RegexOutput = String
    let variableNames: [String]

    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        for variableName in variableNames where input[index..<bounds.upperBound].hasPrefix(variableName) {
            let endIndex = input.index(index, offsetBy: variableName.count)
            return (endIndex, variableName)
        }
        return nil
    }
}

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct MathExpressionOperator: CustomConsumingRegexComponent {
    public typealias RegexOutput = MathExpressionToken
    
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
           let opeTerm = MathExpressionToken.binaryOperatorToken(String(match.output)) {
            return (match.range.upperBound, opeTerm)
        }
        return nil
    }
}

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct MathExpressionPolynomial: CustomConsumingRegexComponent {
    public typealias RegexOutput = [MathExpressionToken]
    let locale: Locale
    let variableNames: [String]
    
    public init(locale: Locale = Locale.current, variableNames: [String]) {
        self.locale = locale
        self.variableNames = variableNames
    }

    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        let term = Reference(MathExpressionToken.self)
        let ope = Reference(MathExpressionToken.self)
        
        let termRegex = Regex {
            ZeroOrMore {
                .whitespace
            }
            Capture(as: term, {
                MathExpressionTerm(locale: locale, variableNames: variableNames)
            })
            ZeroOrMore {
                .whitespace
            }
        }
        
        let opeTermRegex = Regex {
            Capture(as: ope, {
                MathExpressionOperator()
            })
            ZeroOrMore {
                .whitespace
            }
            Capture(as: term, {
                MathExpressionTerm(locale: locale, variableNames: variableNames)
            })
            ZeroOrMore {
                .whitespace
            }
        }
        
        var matchIndex = index
        // term, operator, term(, operator, term), ...
        guard let termMatch = try termRegex.prefixMatch(in: input[matchIndex..<bounds.upperBound]) else { return nil }
        var result: [MathExpressionToken] = [ termMatch[term] ]

        matchIndex = termMatch.range.upperBound
        while let opeTermMatch = try opeTermRegex.prefixMatch(in: input[matchIndex..<bounds.upperBound]) {
            result.append(opeTermMatch[ope])
            result.append(opeTermMatch[term])
            matchIndex = opeTermMatch.range.upperBound
        }

        return (matchIndex, result)
    }
}

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct SignableLocalizedDouble: CustomConsumingRegexComponent {
    public typealias RegexOutput = Double
    let locale: Locale
    
    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        let value = Reference(Double.self)
        
        let base = Regex {
            Optionally("+",
                       .reluctant)
            FloatingPointFormatStyle.localizedDouble(locale: Locale.init(identifier: "ja-JP"))
        }
        
        let regex = Regex {
            TryCapture(base, as: value, transform: { substring -> Double? in
                let groupSep = locale.groupingSeparator ?? ""
                let string = substring
                let numString = string.replacingOccurrences(of: groupSep, with: "")
                return Double(numString)
            })
        }
        if let match = try regex.prefixMatch(in: input[index..<bounds.upperBound]) {
            let captureValue = match[value]
            return (match.range.upperBound, captureValue)
        }
        return nil
    }
}

#endif
