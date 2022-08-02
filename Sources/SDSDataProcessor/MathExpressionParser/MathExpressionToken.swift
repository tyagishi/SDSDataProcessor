//
//  MathExpressionToken.swift
//
//  Created by : Tomoaki Yagishita on 2021/10/28
//  © 2021  SmallDeskSoftware
//

import Foundation

public enum Token: CustomDebugStringConvertible, CaseIterable, Equatable {
    static public var allCases: [Token] = [.Numeric(0.0), .Operator("+"), .OpenBracket, .CloseBracket]
    
    static let groupingSeparator = Locale.current.groupingSeparator ?? ""
    case Numeric(Double)
    case Operator(String)
    case OpenBracket
    case CloseBracket
    case Bracketed(MathExpression)

    func instanciateWithValue(_ string: String) -> Token? {
        switch self {
        case .Numeric(_):
            if let dValue = Double(string.filter({ !(Token.groupingSeparator.contains($0)) })) {
                return .Numeric(dValue)
            }
            return nil
        case .Operator(_):
            return .Operator(string)
        case .OpenBracket:
            return .OpenBracket
        case .CloseBracket:
            return .CloseBracket
        case .Bracketed(_):
            fatalError()
        }
    }
    
    var scanCharacterSet: CharacterSet {
        switch self {
        case .Numeric(_):
            return CharacterSet.numericCharacters
        case .Operator(_):
            return CharacterSet.operatorCharacters
        case .OpenBracket:
            return CharacterSet.openBracketsCharacters
        case .CloseBracket:
            return CharacterSet.closeBracketsCharacters
        case .Bracketed(_):
            return CharacterSet() // empty
        }
    }
    
    var doubleValue: Double? {
        switch self {
        case .Numeric(let double):
            return double
        default:
            return nil
        }
    }
    
    var opeString: Character? {
        switch self {
        case .Operator(let string):
            guard string.count == 1 else { return nil }
            return string.first!
        default:
            return nil
        }
    }
    
    var operatorPriority: Int {
        switch self {
        case .Operator(let str):
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
        case .Numeric(_):
            return true
        default:
            return false
        }
    }
    
    var isOpenBracket: Bool {
        if case .OpenBracket = self {
            return true
        }
        return false
    }
    
    var isCloseBracket: Bool {
        if case .CloseBracket = self {
            return true
        }
        return false
    }
    
    var isBracketed: Bool {
        if case .Bracketed(_) = self {
            return true
        }
        return false
    }
    
    var expression: MathExpression? {
        switch self {
        case .Bracketed(let expression):
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
        case .Numeric(let value):
            return "Numeric: \(value)"
        case .Operator(let symbol):
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
        case .OpenBracket:
            return "Open"
        case .CloseBracket:
            return "Close"
        case .Bracketed(let expression):
            return "Bracketed \(expression)"
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

