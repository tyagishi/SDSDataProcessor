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
public enum METoken: CaseIterable, Equatable {
    public static var allCases: [METoken] = [.numeric(0.0, "0"), .binaryOperator("+")]
    
    static let groupingSeparator = Locale.current.groupingSeparator ?? ""
    
    // lexer/parser common
    case numeric(Double, String)
    case variable(String)
    case binaryOperator(String)
    
    // only for lexer (basically only "()" can be accepted
    case openParenthesis(String)
    case closeParenthesis(String)

    // for parser
    case unaryOperator(String, String)
//    case functionName(String)
    
    // followings are generated only from parser
//    case bracketed(MathExpression)
//    case function(String, MathExpression)

    func doubleValue(_ map: [String: Double] = [:]) -> Double? {
        switch self {
        case .numeric(let double, _):
            return double
        case .variable(let varName):
            return map[varName]
        default:
            return nil
        }
    }
}

extension METoken: CustomDebugStringConvertible {
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
        case .unaryOperator(let start, let end):
            return "enclosed in " + start + end
            
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
