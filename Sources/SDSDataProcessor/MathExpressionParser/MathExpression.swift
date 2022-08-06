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

    public func calc() throws -> Double {
//        if case .brancket(let expr) = self {
//            return try expr.calc()
//        }
//        guard case .node(let myLeft, let myNode, let myRight) = self else { throw Error.InvalidAST }
//
        if self.left == nil, self.right == nil {
            if self.token.isNumeric {
                return self.token.doubleValue!
            } else if let expression = self.token.expression {
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
}
