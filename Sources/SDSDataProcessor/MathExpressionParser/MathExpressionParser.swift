//
//  MathExpressionParser.swift
//
//  Created by : Tomoaki Yagishita on 2021/09/22
//  © 2021  SmallDeskSoftware
//

import Foundation


public enum MathExpressionParserError: Error {
    case InvalidToken
    case InvalidExpression
    case InvalidAST
}

public class MathExpressionParser {
    typealias Error = MathExpressionParserError

    public init() {}
    
    public func parse(_ tokens:[Token]) throws -> MathExpression {
        guard tokens.count > 0 else { throw Error.InvalidExpression  }
        var workingStack:[MathExpression] = []
        var bracketStack:[[MathExpression]] = []
        
        for token in tokens {
            if token.isOpenBracket {
                if workingStack.count > 0 { bracketStack.append(workingStack) }
                workingStack = []
            } else if token.isCloseBracket {
                guard workingStack.count == 1 else { throw Error.InvalidExpression }
                let lastExpression = workingStack[0]
                let bracketedToken = MathExpression(value: .Bracketed(lastExpression))
                workingStack = bracketStack.popLast() ?? []
                workingStack.append(bracketedToken)
            } else {
                let tokenNode = MathExpression(value: token)
                workingStack.append(tokenNode)
            }
            //}
            if workingStack.count == 3 {
                let left = workingStack[0]
                let opeNode = workingStack[1]
                guard opeNode.value.isOperator else { throw Error.InvalidExpression }
                let right = workingStack[2]

                let newExpression = try mergeExpression(topNode: left, opeNode: opeNode, addNode: right)
                workingStack.removeAll()
                workingStack.append(newExpression)
            }
        }
        guard workingStack.count == 1 else { throw Error.InvalidExpression }
        return workingStack[0]
    }
    
    // +-演算子は、新しいオペレータをツリーのトップにする
    //   +             ->       +
    //  1 2  <- + 3           +   3
    //                       1 2
    //
    //   +             ->      +
    //  1 2  <- * 3          1   *
    //                          2 3
    // 以下の考察から、＊／ 演算子は、一番右の数値ノードを 数値,演算子,新規数値 のノードで置き換えれば良いハズ
    //   +              ->     +
    //  1 +                   1 +
    //   2 3   <- * 4          2 *
    //                          3 4
    //
    //   +              ->     +
    //  1 *                   1 *
    //   2 3   <- * 4          2 *
    //                          3 4
    //
    //   +              ->      +
    //  + 3                   +   *
    // 1 2   <- * 4          1 2 3 4
    //
    //   *              ->      *
    //  * 3  <- *4            *   *
    // 1 2                   1 2 3 4

    func mergeExpression(topNode: MathExpression, opeNode: MathExpression, addNode: MathExpression) throws -> MathExpression {
        let opeToken = opeNode.value
        guard opeToken.isOperator else { throw Error.InvalidToken }
        
        if opeToken.isPlusMinus {
            // create new expression as top node
            let newExpression = MathExpression(value: opeToken, left: topNode, right: addNode)
            return newExpression
        } else {
            // replace most right child with new expression
            let replaceNode = topNode.mostRightNode()
            guard let replaceNodeParent = replaceNode.parent else {
                // should be single node math expression (i.e. numeric)
                let newExpression = MathExpression(value: opeToken, left: replaceNode, right: addNode)
                return newExpression
            }
            let newExpression = MathExpression(value: opeToken, left: replaceNode, right: addNode)
            replaceNodeParent.setRight(newExpression)
            return topNode
        }
        throw Error.InvalidAST
    }
}
