//
//  CalcMathExpression.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/21
//  © 2024  SmallDeskSoftware
//

import Foundation
import SDSStringExtension

public func calcMathExpression(_ string: String) throws -> Double {
    let filter = FilterLexer(chars: MathExpression.mathExpressionCharacterSet,
                             tokens: MathExpression.mathExpressionTokens)
    let filtered = try filter.filter(string)
    
    guard let evalString = filtered.string.retrieveUntil("=") else { throw MathExpressionParserError.invalidExpression }
    
    let lexer = BruteForceLexer()
    let parser = MathExpressionParser()
    let tokens = try lexer.lex(String(evalString))
    let expression = try parser.parse(tokens)
    let result = try expression.calc()
    return result
}
