//
//  MENumericTerm.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/08/12.
//

import Foundation
#if canImport(RegexBuilder)
import RegexBuilder

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct MENumericTerm: CustomConsumingRegexComponent {
    public typealias RegexOutput = METoken
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
            return (match.range.upperBound, METoken.numeric(match.1, String(match.0)))
        }
        return nil
    }
}
#endif
