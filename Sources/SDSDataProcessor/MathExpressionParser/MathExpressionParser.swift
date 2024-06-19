//
//  MathExpressionParser.swift
//
//  Created by : Tomoaki Yagishita on 2021/09/22
//  © 2021  SmallDeskSoftware
//

import Foundation

public enum MathExpressionParserError: Error {
    case invalidToken
    case invalidExpression
    case invalidAST
    case unknownOperator
    case unbalancedBrackets
    case unknownFunction
}

public class MathExpressionParser {
    typealias Error = MathExpressionParserError

    public init() {}
    
    // parser logic
    // 5 + 8
    // 1) push 5 into working stack
    // 2) push + into working stack
    // 3) push 8 into working stack
    // 4) working stack has 3 element, then create Expression for 5 + 8, replace 3 element in working stack with newly created expression
    // 5) repeat above until all tokens are processed
    //
    // bracket case note: function is treated as bracket with functin name
    // sin(5+8)
    // 1) push sin into working stack
    // 2) find openBracket, push current working stack into bracket stack working: [], bracket: ["sin"]
    // 3) push 5,+,8 then working stack will have "5+8"  <- called currentExpresion
    // 4) find closeBracket, check last element in bracket whether it is function or not, in this case it is function
    // 5) pop expression and drop last element in expression because it is function
    // 6) create new expression from function and currentExpression
    // 7) push created expression into working stack
    
    // swiftlint:disable cyclomatic_complexity
    public func parse(_ tokens: [Token]) throws -> MathExpression {
        guard !tokens.isEmpty else { throw Error.invalidExpression  }
        var workingStack: [MathExpression] = []
        var bracketStack: [[MathExpression]] = []
        var necessaryCloseBrackets = 0
        
        for token in tokens {
            if token.isOpenBracket {
                if !workingStack.isEmpty { bracketStack.append(workingStack) }
                workingStack = []
                necessaryCloseBrackets += 1
            } else if token.isFunction,
                      let functionName = token.functionName {
                // consume open bracket
                workingStack.append(MathExpression(value: .functionName(functionName)))
                if !workingStack.isEmpty { bracketStack.append(workingStack) }
                workingStack = []
                necessaryCloseBrackets += 1
            } else if token.isCloseBracket {
                guard workingStack.count == 1 else { throw Error.invalidAST }
                let currentExpression = workingStack[0]
                // check function or just brancketed?
                var stackedExpression = bracketStack.popLast() ?? [] // maybe first element is openBracket
                if let last = stackedExpression.last,
                   let functionName = last.token.functionName {
                    stackedExpression.removeLast() // remove function token
                    workingStack = stackedExpression
                    let functionToken = MathExpression(value: .function(functionName, currentExpression))
                    workingStack.append(functionToken)
                } else {
                    workingStack = stackedExpression
                    let bracketedToken = MathExpression(value: .bracketed(currentExpression))
                    workingStack.append(bracketedToken)
                }
                necessaryCloseBrackets -= 1
            } else {
                let tokenNode = MathExpression(value: token)
                workingStack.append(tokenNode)
            }
            //}
            if workingStack.count == 3 {
                let left = workingStack[0]
                let opeNode = workingStack[1]
                guard opeNode.value.isOperator else { throw Error.invalidAST }
                let right = workingStack[2]

                let newExpression = try mergeExpression(topNode: left, opeNode: opeNode, addNode: right)
                workingStack.removeAll()
                workingStack.append(newExpression)
            }
        }
        guard necessaryCloseBrackets == 0 else { throw Error.invalidAST }
        guard bracketStack.isEmpty else { throw Error.unbalancedBrackets }
        guard workingStack.count == 1 else { throw Error.invalidAST }
        return workingStack[0]
    }
    // swiftlint:enable cyclomatic_complexity

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
        guard opeToken.isOperator else { throw Error.invalidToken }
        
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
        } 
        mergeNode = mergeNode.parent!
        let mergeNodeParent = mergeNode.parent
        let newExpression = MathExpression(value: opeToken, left: mergeNode, right: addNode)
        mergeNodeParent?.setRight(newExpression)
        return newExpression.rootNode
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
