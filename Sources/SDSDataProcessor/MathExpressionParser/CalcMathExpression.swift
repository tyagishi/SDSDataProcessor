//
//  CalcMathExpression.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/21
//  © 2024  SmallDeskSoftware
//

import Foundation

func calcMathExpression(_ string: String) throws -> Double {
    let filter = FilterLexer(chars: MathExpression.mathExpressionCharacterSet,
                             scanTokens: MathExpression.mathExpressionTokens)
    let filtered = try filter.filter(string)
    
    let lexer = BruteForceLexer()
    let parser = MathExpressionParser()
    let tokens = try lexer.lex(filtered.string)
    let expression = try parser.parse(tokens)
    let result = try expression.calc()
    return result
}
