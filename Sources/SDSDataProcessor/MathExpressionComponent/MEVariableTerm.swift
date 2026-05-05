//
//  MEVariableTerm.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/08/12.
//

import Foundation
import RegexBuilder

@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct MEVariableTerm: CustomConsumingRegexComponent {
    public typealias RegexOutput = METoken
    let variableNames: [String]

    public func consuming(_ input: String, startingAt index: String.Index, in bounds: Range<String.Index>) throws -> (upperBound: String.Index, output: RegexOutput)? {
        for variableName in variableNames where input[index..<bounds.upperBound].hasPrefix(variableName) {
            let endIndex = input.index(index, offsetBy: variableName.count)
            return (endIndex, .variable(variableName))
        }
        return nil
    }
}
