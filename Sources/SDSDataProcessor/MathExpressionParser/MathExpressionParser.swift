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
                workingStack = bracketStack.popLast() ?? []
                let brancktedExpression = MathExpression.brancket(lastExpression)
                workingStack.append(brancktedExpression)
            } else {
                let tokenExpr = MathExpression.node(.empty, token, .empty)
                workingStack.append(tokenExpr)
            }
            if workingStack.count == 3 {
                let left = workingStack[0]
                let ope = workingStack[1]
                guard let opeToken = ope.token else { throw Error.InvalidExpression }
                let right = workingStack[2]

                var nextExpression: MathExpression
                if left.priority < opeToken.priority { // true means new operator has higher priority than already existing Expression
                    nextExpression = try left.addTermWithHighPriorityOperator(ope: opeToken, rightExpr: right)
                } else {
                    nextExpression = try left.addTermWithLowPriorityOperator(ope: opeToken, rightExpr: right)
                }
                workingStack.removeAll()
                workingStack.append(nextExpression)
            }
        }
        guard workingStack.count == 1 else { throw Error.InvalidExpression }
        return workingStack[0]
    }
}
