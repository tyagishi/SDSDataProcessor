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
public struct MathExpressionNumericTerm: CustomConsumingRegexComponent {
    public typealias RegexOutput = Double
    let locale: Locale
    
    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        let regex = Regex {
            SignableLocalizedDouble(locale: locale)
        }
        if let match = try regex.prefixMatch(in: input[index..<bounds.upperBound]) {
            return (match.range.upperBound, match.output) //  as! (upperBound: String.Index, output: SignableLocalizedDouble.RegexOutput)
        }
        return nil
    }
}

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct MathExpressionOperator: CustomConsumingRegexComponent {
    public typealias RegexOutput = Substring
    
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
        if let match = try regex.prefixMatch(in: input[index..<bounds.upperBound]) {
            return (match.range.upperBound, match.output) //  as! (upperBound: String.Index, output: SignableLocalizedDouble.RegexOutput)
        }
        return nil
    }
}



public struct MathExpressionRegexComponent: CustomConsumingRegexComponent {
    public typealias RegexOutput = MathExpression
    
    public init() { }
    
    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        nil
    }
}

public struct MathExpressionTermComponent: CustomConsumingRegexComponent {
    public typealias RegexOutput = MathExpressionToken
    
    public init() { }
    
    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        nil
    }
}

public struct MathExpressionOperatorComponent: CustomConsumingRegexComponent {
    public typealias RegexOutput = MathExpressionToken
    
    public init() { }
    
    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        nil
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
            let captureValue = match[value] //, //, { //as? SignableLocalizedDouble.RegexOutput {
            return (match.range.upperBound, captureValue) //  as! (upperBound: String.Index, output: SignableLocalizedDouble.RegexOutput)
        }
        return nil
    }
}

#endif
