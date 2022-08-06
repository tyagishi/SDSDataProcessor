//
//  MathExpressionToken.swift
//
//  Created by : Tomoaki Yagishita on 2021/10/28
//  © 2021  SmallDeskSoftware
//

import Foundation

public enum Token: CustomDebugStringConvertible, CaseIterable, Equatable {
    static public var allCases: [Token] = [.numeric(0.0), .binaryOperator("+"), .openBracket, .closeBracket, .functionName("")]
    
    static let groupingSeparator = Locale.current.groupingSeparator ?? ""

    // lexer/parser common
    case numeric(Double)
    case binaryOperator(String)

    // only for lexer
    case openBracket
    case functionName(String)
    case closeBracket
    
    // only for parser
    case bracketed(MathExpression)
    case function(String, MathExpression)

    func instanciateWithValue(_ string: String) -> Token? {
        switch self {
        case .numeric(_):
            if let dValue = Double(string.filter({ !(Token.groupingSeparator.contains($0)) })) {
                return .numeric(dValue)
            }
            return nil
        case .binaryOperator(_):
            return .binaryOperator(string)
        case .openBracket:
            return .openBracket
        case .closeBracket:
            return .closeBracket
        case .functionName(_):
            return .functionName(string)
        case .bracketed(_):
            fatalError()
        case .function(_,_):
            fatalError()
        }
    }
    
    var scanCharacterSet: CharacterSet {
        switch self {
        case .numeric(_):
            return CharacterSet.numericCharacters
        case .binaryOperator(_):
            return CharacterSet.operatorCharacters
        case .openBracket:
            return CharacterSet.openBracketsCharacters
        case .closeBracket:
            return CharacterSet.closeBracketsCharacters
        case .functionName(_):
            return CharacterSet.letters
        case .bracketed(_), .function(_,_):
            return CharacterSet() // empty
        }
    }
    
    var doubleValue: Double? {
        switch self {
        case .numeric(let double):
            return double
        default:
            return nil
        }
    }
    
    var opeString: Character? {
        switch self {
        case .binaryOperator(let string):
            guard string.count == 1 else { return nil }
            return string.first!
        default:
            return nil
        }
    }
    
    var operatorPriority: Int {
        switch self {
        case .binaryOperator(let str):
            switch str {
            case "+", "-":
                return 0
            case "*", "/":
                return 50
            case "^":
                return 100
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    var isNumeric: Bool {
        switch self {
        case .numeric(_):
            return true
        default:
            return false
        }
    }
    
    var isOpenBracket: Bool {
        if case .openBracket = self {
            return true
        }
        return false
    }
    
    var isCloseBracket: Bool {
        if case .closeBracket = self {
            return true
        }
        return false
    }
    
    var isBracketed: Bool {
        if case .bracketed(_) = self {
            return true
        }
        return false
    }
    
    var isFunction: Bool {
        if case .functionName(_) = self {
            return true
        }
        return false
    }
    
    var expression: MathExpression? {
        switch self {
        case .bracketed(let expression):
            return expression
        default:
            return nil
        }
    }
    
    var isPlusMinus: Bool {
        guard let opeString = self.opeString else { return false }
        return opeString == "+" || opeString == "-"
    }
    
    var isOperator: Bool {
        return !isNumeric
    }
    
    public var debugDescription: String {
        switch self {
        case .numeric(let value):
            return "Numeric: \(value)"
        case .binaryOperator(let symbol):
            switch symbol {
            case "+":
                return "+"
            case "-":
                return "-"
            case "*":
                return "*"
            case "/":
                return "/"
            case "^":
                return "^"
            default:
                break
            }
            fatalError("unknown operator")
        case .openBracket:
            return "Open"
        case .closeBracket:
            return "Close"
        case .bracketed(let expression):
            return "Bracketed \(expression)"
        case .functionName(let funcName):
            return "Function_\(funcName)"
        case .function(let funcName, let expression):
            return "Function_\(funcName) \(expression)"
        }
    }
}


extension CharacterSet {
    static var plusMinus: CharacterSet {
        var ope = CharacterSet()
        ope.insert(charactersIn: "+-")
        return ope
    }
    static var leadingNumericCharacters: CharacterSet {
        var numeric = CharacterSet.decimalDigits
        numeric.insert(charactersIn: "+-.,")
        return numeric
    }
    static var strictNumericCharacters: CharacterSet {
        var numeric = CharacterSet.decimalDigits
        numeric.insert(charactersIn: ".,")
        return numeric
    }

    static var numericCharacters: CharacterSet {
        var numeric = CharacterSet.decimalDigits
        numeric.insert(charactersIn: "+-.,")
        return numeric
    }
    static var operatorCharacters: CharacterSet {
        var ope = CharacterSet()
        ope.insert(charactersIn: "+-*/^")
        return ope
    }
    static var openBracketsCharacters: CharacterSet {
        var ope = CharacterSet()
        ope.insert(charactersIn: "([")
        return ope
    }
    static var closeBracketsCharacters: CharacterSet {
        var ope = CharacterSet()
        ope.insert(charactersIn: ")]")
        return ope
    }
}

