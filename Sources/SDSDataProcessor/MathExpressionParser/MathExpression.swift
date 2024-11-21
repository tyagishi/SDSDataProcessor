//
//  MathExpression.swift
//
//  Created by : Tomoaki Yagishita on 2021/10/12
//  © 2021  SmallDeskSoftware
//

import Foundation
import SDSDataStructure

public typealias MathExpression = BinaryTreeNode<Token>

extension MathExpression {
    public static let mathExpressionTokens = ["sin", "cos", "tan", "asin", "acos", "atan"]
    public static var mathExpressionCharacterSet: CharacterSet {
        var charSet = CharacterSet.decimalDigits
        charSet.insert(charactersIn: "+-*/^=")
        if let groupingSeparator = Locale.current.groupingSeparator {
            charSet.insert(charactersIn: groupingSeparator)
        }
        if let decimalSeparator = Locale.current.decimalSeparator {
            charSet.insert(charactersIn: decimalSeparator)
        }
        return charSet
    }
}

extension MathExpression {
    public var token: Token {
        self.value
    }
    
    public func mostRightNode() -> MathExpression {
        guard let right = self.right else { return self }
        return right.mostRightNode()
    }
    public func mostRightOperatorNode() -> MathExpression? {
        let mostRightNode = mostRightNode() 
        guard let parentOperatorNode = mostRightNode.parent else { return nil }
        return parentOperatorNode
    }
}

extension MathExpression {
    typealias Error = MathExpressionParserError

    // swiftlint:disable cyclomatic_complexity
    public func calc() throws -> Double {
        if self.left == nil, self.right == nil {
            if self.token.isNumeric {
                return self.token.doubleValue!
            } 
            if case Token.function(let name, let argument) = self.token {
                let value = try argument.calc()
                switch name.lowercased() {
                case "sin":
                    return sin(value / 180.0 * Double.pi)
                case "cos":
                    return cos(value / 180.0 * Double.pi)
                case "tan":
                    return tan(value / 180.0 * Double.pi)
                case "sqrt":
                    return sqrt(value)
                case "asin":
                    return asin(value) / Double.pi * 180
                case "acos":
                    return acos(value) / Double.pi * 180
                case "atan":
                    return atan(value) / Double.pi * 180
                default:
                    throw Error.unknownFunction
                }
            }
            if let expression = self.token.expression {
                return try expression.calc()
            }
            throw Error.invalidAST
        }
        if let left = self.left, let right = self.right,
           let opeString = self.token.opeString {
            let leftValue = try left.calc()
            let rightValue = try right.calc()
            
            switch opeString {
            case "+":
                return leftValue + rightValue
            case "-":
                return leftValue - rightValue
            case "*":
                return leftValue * rightValue
            case "/":
                return leftValue / rightValue
            case "^":
                return pow(leftValue, rightValue)
            default:
                throw Error.unknownOperator
            }
        } else {
            throw Error.invalidAST
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
