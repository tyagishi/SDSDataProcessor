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
    public static var allCases: [METoken] = [.numeric(0.0, "0"), .binaryOperator("+")]
    
    static let groupingSeparator = Locale.current.groupingSeparator ?? ""
    
    // lexer/parser common
    case numeric(Double, String)
    case variable(String)
    case binaryOperator(String)
    //case unaryOperator(String) // not implemented yet
    
    // only for lexer (basically only "()" can be accepted
    case openParenthesis(String)
    case closeParenthesis(String)
    
//    case openBracket
//    case functionName(String)
//    case closeBracket
    
    // followings are generated only from parser
//    case bracketed(MathExpression)
//    case function(String, MathExpression)
    
    public var debugDescription: String {
        switch self {
        case .numeric(let value, let string):
            return String(value) + " " + string
        case .variable(let string):
            return "variable: " + string
        case .binaryOperator(let value):
            return value
        case .openParenthesis(let parenthesis):
            return parenthesis
        case .closeParenthesis(let parenthesis):
            return parenthesis
//        case .functionName(let name):
//            return "function \(name)"
//        // followings are only for parser
//        case .bracketed:
//            return "Bracketed"
//        case .function(let name,_):
//            return "function \(name)"
        }
    }
}
