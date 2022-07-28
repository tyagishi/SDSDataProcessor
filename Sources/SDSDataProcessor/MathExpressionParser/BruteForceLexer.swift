//
//  BruteForceLexer.swift
//
//  Created by : Tomoaki Yagishita on 2021/09/24
//  © 2021  SmallDeskSoftware
//

import Foundation

public class BruteForceLexer {
    typealias Error = MathExpressionParserError
    let numericCharacterSet = CharacterSet.numericCharacters
    let groupingSeparator = Locale.current.groupingSeparator ?? ""
    
    public init() {}
    
    public func lex(_ string: String) throws -> [Token] {
        var foundTokens: [Token] = []
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = CharacterSet.whitespaces
        
        while !scanner.isAtEnd {
            guard let token = scanToken(scanner) else { throw Error.InvalidToken }
            foundTokens.append(token)
        }
        return foundTokens
    }
    
    func scanToken(_ scanner: Scanner) -> Token? {
        for token in Token.allCases {
            if let foundToken = scanToken(scanner, token: token) {
                return foundToken
            }
        }
        return nil
    }
    
    func scanToken(_ scanner: Scanner, token: Token) -> Token? {
        let startPosition = scanner.currentIndex
        if let scanString = scanner.scanCharacters(from: token.scanCharacterSet) {
            if let newToken = token.instanciateWithValue(scanString) {
                return newToken
            }
        }
        // reset start position
        scanner.currentIndex = startPosition
        return nil
    }
}
