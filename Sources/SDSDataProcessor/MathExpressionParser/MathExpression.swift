//
//  MathExpression.swift
//
//  Created by : Tomoaki Yagishita on 2021/10/12
//  © 2021  SmallDeskSoftware
//

import Foundation

public indirect enum BinaryTree<T> {
    case node(_ left: BinaryTree<T>,_ token: T,_ right: BinaryTree<T>)
    case brancket(_ node: BinaryTree<T>)
    case empty
}

extension BinaryTree: Equatable {
    public static func == (lhs: BinaryTree<T>, rhs: BinaryTree<T>) -> Bool {
        if case BinaryTree.empty = lhs,
           case BinaryTree.empty = rhs { return true }
        return false
    }
}

public typealias MathExpression = BinaryTree<Token>

extension MathExpression {
    public var isSimpleNumeric:Bool {
        if case .node(_, let token,_) = self {
            return token.isNumeric
        }
        return true
    }
}

// for convenience
extension MathExpression {
    var left: MathExpression {
        if case .node(let myLeft,_,_) = self {
            return myLeft
        }
        return .empty
    }
    var token: Token? {
        if case .node(_,let myNode,_) = self {
            return myNode
        }
        return nil
    }
    var right: MathExpression {
        if case .node(_,_,let myRight) = self {
            return myRight
        }
        return .empty
    }
    var child: MathExpression {
        if case .brancket(let child) = self {
            return child
        }
        return .empty
    }
}

extension MathExpression {
    typealias Error = MathExpressionParserError
    
    func addTermWithLowPriorityOperator(ope: Token, rightExpr: MathExpression) throws -> MathExpression {
        let topExpression = MathExpression.node(self, ope, rightExpr)
        return topExpression
    }
    
    func addTermWithHighPriorityOperator(ope: Token, rightExpr: MathExpression) throws -> MathExpression {
        guard case .node(let myLeft, let myOpe, let myRight) = self else { throw Error.InvalidAST }
        if self.isSimpleNumeric {
            let newTop = MathExpression.node(self, ope, rightExpr)
            return newTop
        }

        guard let myRightToken = myRight.token else { throw Error.InvalidAST }
        let newRightLeftChild = MathExpression.node(.empty, myRightToken, .empty)
        let newRight = MathExpression.node(newRightLeftChild, ope, rightExpr)
        let newTop = MathExpression.node(myLeft, myOpe, newRight)
        return newTop
    }
    
    var priority: Int {
        if case .node(_,let myNode,_) = self {
            return myNode.priority
        } else if case .brancket(_) = self {
            return 99// highest
        }
        return 0 // .empty
    }
    
    public func calc() throws -> Double {
        if case .brancket(let expr) = self {
            return try expr.calc()
        }
        guard case .node(let myLeft, let myNode, let myRight) = self else { throw Error.InvalidAST }
            
        if myLeft == .empty {
            guard myRight == .empty else { throw Error.InvalidAST }
            guard myNode.isNumeric else { throw Error.InvalidAST }
            if let dValue = myNode.doubleValue { return dValue }
            throw Error.InvalidToken
        }
        
        let leftValue = try myLeft.calc()
        let rightValue = try myRight.calc()
        
        guard let opeString = myNode.opeString else { throw Error.InvalidAST }
        switch opeString {
        case "+":
            return leftValue + rightValue
        case "-":
            return leftValue - rightValue
        case "*":
            return leftValue * rightValue
        case "/":
            return leftValue / rightValue
        default:
            throw Error.InvalidAST
        }
    }
}
