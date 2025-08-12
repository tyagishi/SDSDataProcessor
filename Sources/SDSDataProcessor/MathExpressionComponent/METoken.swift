//
//  MathExpressionToken.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/01/09.
//

import Foundation
import SDSDataStructure
import SDSMacros

@IsCheckEnum
@AssociatedValueEnum
public enum METoken: CustomDebugStringConvertible, CaseIterable, Equatable {
    public static var allCases: [METoken] = [.numeric(0.0, "0"), .binaryOperator("+"), .openBracket, .closeBracket, .functionName("")]
    
    static let groupingSeparator = Locale.current.groupingSeparator ?? ""
    
    // lexer/parser common
    case numeric(Double, String)
    case variable(String)
    case binaryOperator(String)
    
    // only for lexer (basically only "()" can be accepted
    case openParenthesis(String)
    case closeParenthesis(String)
    
    case openBracket
    case functionName(String)
    case closeBracket
    
    // only for parser
    case bracketed(MathExpression)
    case function(String, MathExpression)
    
    public var debugDescription: String {
        switch self {
        case .numeric(let value, let string):
            return String(value) + " " + string
        case .variable(let string):
            return "variable: " + string
        case .binaryOperator(let value):
            return value
        case .openBracket, .openParenthesis:
            return "("
        case .functionName(let name):
            return "function \(name)"
        case .closeBracket, .closeParenthesis:
            return")"
        // followings are only for parser
        case .bracketed:
            return "Bracketed"
        case .function(let name,_):
            return "function \(name)"
        }
    }
}

