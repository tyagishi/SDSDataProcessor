//
//  File.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/08/13.
//

import Foundation
import SDSDataStructure
import SDSSwiftExtension

public enum MEParserError: Error {
    case empty
    case unknownStructure
    case unpairedParenthesis
    case emptyParenthesis
    case invalidExpression
//    case invalidToken
//    case invalidAST
//    case unknownOperator
//    case unbalancedBrackets
//    case unknownFunction
    case unsupported
}

public typealias MEPolynomialAST = BinaryTreeNode<METoken>

public func parseExpression<T>(_ expression: T, range: Range<T.Index>? = nil) throws -> MEPolynomialAST where T: RandomAccessCollection, T.Element == METoken, T.Index == Int {
    guard !expression.isEmpty else { throw MEParserError.empty }

    let processRange = range ?? (0..<expression.count)
    var rootASTNode: MEPolynomialAST
    var tokenToBeProcessed: Int = processRange.lowerBound

    // first token needs special treatment
    if expression[tokenToBeProcessed].isOpenParenthesis {
        guard let closeParentheisIndex = expression[tokenToBeProcessed...].firstIndex(where: { $0.isCloseParenthesis }) else { throw MEParserError.unpairedParenthesis }
        guard tokenToBeProcessed < (closeParentheisIndex - 1) else { throw MEParserError.emptyParenthesis }
        //rootASTNode.right = MEPol
        let rightValue = try parseExpression(expression[(tokenToBeProcessed+1)..<closeParentheisIndex], range: (tokenToBeProcessed+1)..<closeParentheisIndex)
        rootASTNode = MEPolynomialAST(value: .unaryOperator("(", ")"), left: nil, right: rightValue)
        tokenToBeProcessed = closeParentheisIndex + 1
    } else {
        rootASTNode = MEPolynomialAST(value: expression[tokenToBeProcessed])
        tokenToBeProcessed += 1
    }
    
    while tokenToBeProcessed < processRange.upperBound {
        if expression[tokenToBeProcessed].isBinaryOperator,
           let nextToken = expression[safe: tokenToBeProcessed + 1] {
            if nextToken.isNumeric || nextToken.isVariable {
                // 1 "+ 2" or 1 "+ x"
                let leftNode = rootASTNode
                let rightNode = MEPolynomialAST(value: nextToken)
                rootASTNode = MEPolynomialAST(value: expression[tokenToBeProcessed], left: leftNode, right: rightNode)
                tokenToBeProcessed += 2
            }
        } else if expression[tokenToBeProcessed].isOpenParenthesis {
            // find close parenthesis
//            guard let closeParentheisIndex = expression[tokenToBeProcessed...].firstIndex(where: { $0.isCloseParenthesis }) else { throw MEParserError.unpairedParenthesis }
//            guard tokenToBeProcessed < (closeParentheisIndex - 1) else { throw MEParserError.emptyParenthesis }
//            let subAST = try parseExpression(expression[tokenToBeProcessed+1..<closeParentheisIndex])
            throw MEParserError.unknownStructure

            // parse sub tokens
        } else {
            throw MEParserError.unknownStructure
        }
    }
    
    guard tokenToBeProcessed == processRange.upperBound else { throw MEParserError.invalidExpression }
    
    return rootASTNode
    
//    let lhs = MEPolynomialAST(value: expression[0])
//    let rhs = MEPolynomialAST(value: expression[1])
//    guard expression[2].isBinaryOperator else { throw MEParserError.unsupported }
//    let ope = MEPolynomialAST(value: expression[2], left: lhs, right: rhs)
//    return ope
}
    
//    var workingStack: [MathExpression] = []
//    var bracketStack: [[MathExpression]] = []
//    var necessaryCloseBrackets = 0
//    
//    for token in tokens {
//        if token.isOpenBracket {
//            if !workingStack.isEmpty { bracketStack.append(workingStack) }
//            workingStack = []
//            necessaryCloseBrackets += 1
//        } else if token.isFunction,
//                  let functionName = token.functionName {
//            // consume open bracket
//            workingStack.append(MathExpression(value: .functionName(functionName)))
//            if !workingStack.isEmpty { bracketStack.append(workingStack) }
//            workingStack = []
//            necessaryCloseBrackets += 1
//        } else if token.isCloseBracket {
//            guard workingStack.count == 1 else { throw Error.invalidAST }
//            let currentExpression = workingStack[0]
//            // check function or just brancketed?
//            var stackedExpression = bracketStack.popLast() ?? [] // maybe first element is openBracket
//            if let last = stackedExpression.last,
//               let functionName = last.token.functionName {
//                stackedExpression.removeLast() // remove function token
//                workingStack = stackedExpression
//                let functionToken = MathExpression(value: .function(functionName, currentExpression))
//                workingStack.append(functionToken)
//            } else {
//                workingStack = stackedExpression
//                let bracketedToken = MathExpression(value: .bracketed(currentExpression))
//                workingStack.append(bracketedToken)
//            }
//            necessaryCloseBrackets -= 1
//        } else {
//            let tokenNode = MathExpression(value: token)
//            workingStack.append(tokenNode)
//        }
//        //}
//        if workingStack.count == 3 {
//            let left = workingStack[0]
//            let opeNode = workingStack[1]
//            guard opeNode.value.isOperator else { throw Error.invalidAST }
//            let right = workingStack[2]
//            
//            let newExpression = try mergeExpression(topNode: left, opeNode: opeNode, addNode: right)
//            workingStack.removeAll()
//            workingStack.append(newExpression)
//        }
//    }
//    guard necessaryCloseBrackets == 0 else { throw Error.invalidAST }
//    guard bracketStack.isEmpty else { throw Error.unbalancedBrackets }
//    guard workingStack.count == 1 else { throw Error.invalidAST }
//    return workingStack[0]
//}
//// swiftlint:enable cyclomatic_complexity
//
//// +-演算子は、一番右のノードを新しいオペレータで置き換える
////   +             ->       +
////  1 2  <- + 3           1   +
////                           2 3
//// */^ 演算子を新規ノード演算子として追加する時も 一番右の演算子(以下の場合 +)の優先度(既存演算子優先度)が低ければ 同じ
////   +             ->      +
////  1 2  <- * 3          1   *
////                          2 3
//// では、既存演算子の優先度が高い時どうするか？以下のように、該当演算子を左子供に持ち、新規演算子をトップノードとしてもつような Expression を作成する
////   *               ->       +
////  1 2   <- + 3            *   3
////                         1 2
//
//func mergeExpression(topNode: MathExpression, opeNode: MathExpression, addNode: MathExpression) throws -> MathExpression {
//    let opeToken = opeNode.value
//    guard opeToken.isOperator else { throw Error.invalidToken }
//    
//    var addAsRightChild = true // default merge
//    
//    var mergeNode = topNode.mostRightNode()
//    if let compareOperatorNode = mergeNode.parent,
//       opeNode.token.operatorPriority <= compareOperatorNode.token.operatorPriority {
//        addAsRightChild = false
//    }
//
//    if addAsRightChild {
//        // merge existing mostRightNode as Right Child
//        let mergeNodeParent = mergeNode.parent
//        let newExpression = MathExpression(value: opeToken, left: mergeNode, right: addNode)
//        mergeNodeParent?.setRight(newExpression)
//        return newExpression.rootNode
//    }
//    mergeNode = mergeNode.parent!
//    let mergeNodeParent = mergeNode.parent
//    let newExpression = MathExpression(value: opeToken, left: mergeNode, right: addNode)
//    mergeNodeParent?.setRight(newExpression)
//    return newExpression.rootNode
//}
//

extension MEPolynomialAST {
    typealias Error = MEParserError

    public func evaluate(_ variableValues: [String: Double] = [:]) throws -> Double {

        if self.left == nil, self.right == nil {
            guard let value = self.value.doubleValue(variableValues) else { throw Error.unsupported }
            return value
        }

        if let left = self.left,
           let leftValue = try? left.evaluate(variableValues),
           let right = self.right,
           let rightValue = try? right.evaluate(variableValues) {
            switch self.value.binaryOperatorValues {
            case "+":
                return leftValue + rightValue
            case "-":
                return leftValue - rightValue
            default:
                throw Error.unsupported
            }
        }

        //    if let left = self.left, let right = self.right,
        //       let opeString = self.token.opeString {
        //        let leftValue = try left.calc()
        //        let rightValue = try right.calc()
        //
        //        switch opeString {
        //        case "+":
        //            return leftValue + rightValue
        //        case "-":
        //            return leftValue - rightValue
        //        case "*":
        //            return leftValue * rightValue
        //        case "/":
        //            return leftValue / rightValue
        //        case "^":
        //            return pow(leftValue, rightValue)
        //        default:
        //            throw Error.unknownOperator
        //        }
        //    } else {
        //        throw Error.invalidAST
        //    }
        return 0.0
    }
}
