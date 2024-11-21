//
//  CalcMathExpression.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/21
//  © 2024  SmallDeskSoftware
//

import Foundation

func calcMathExpression(_ string: String) throws -> Double {

    let lexer = BruteForceLexer()
    let parser = MathExpressionParser()
    let tokens = try lexer.lex(string)
    let expression = try parser.parse(tokens)
    let result = try expression.calc()
    return result
}
