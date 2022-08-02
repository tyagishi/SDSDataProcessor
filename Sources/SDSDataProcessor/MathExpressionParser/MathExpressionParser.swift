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
    case UnknownOperator
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
    
    // +-演算子は、一番右のノードを新しいオペレータで置き換える
    //   +             ->       +
    //  1 2  <- + 3           1   +
    //                           2 3
    // */^ 演算子を新規ノード演算子として追加する時も 一番右の演算子(以下の場合 +)の優先度(既存演算子優先度)が低ければ 同じ
    //   +             ->      +
    //  1 2  <- * 3          1   *
    //                          2 3
    // では、既存演算子の優先度が高い時どうするか？以下のように、該当演算子を左子供に持ち、新規演算子をトップノードとしてもつような Expression を作成する
    //   *               ->       +
    //  1 2   <- + 3            *   3
    //                         1 2


    func mergeExpression(topNode: MathExpression, opeNode: MathExpression, addNode: MathExpression) throws -> MathExpression {
        let opeToken = opeNode.value
        guard opeToken.isOperator else { throw Error.InvalidToken }
        
        var addAsRightChild = true // default merge
        
        var mergeNode = topNode.mostRightNode()
        if let compareOperatorNode = mergeNode.parent,
           opeNode.token.operatorPriority <= compareOperatorNode.token.operatorPriority {
            addAsRightChild = false
        }

        if addAsRightChild {
            // merge existing mostRightNode as Right Child
            let mergeNodeParent = mergeNode.parent
            let newExpression = MathExpression(value: opeToken, left: mergeNode, right: addNode)
            mergeNodeParent?.setRight(newExpression)
            return newExpression.rootNode
        } else {
            mergeNode = mergeNode.parent!
            let mergeNodeParent = mergeNode.parent
            let newExpression = MathExpression(value: opeToken, left: mergeNode, right: addNode)
            mergeNodeParent?.setRight(newExpression)
            return newExpression.rootNode
        }
        throw Error.InvalidAST
    }
    
    //　以下、検討メモ
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
}
