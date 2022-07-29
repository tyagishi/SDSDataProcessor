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
        scanner.charactersToBeSkipped = CharacterSet()

        var lastToken: Token? = nil
        while !scanner.isAtEnd {
            guard let token = scanToken(scanner, lastToken: lastToken) else { throw Error.InvalidToken }
            foundTokens.append(token)
            lastToken = token
        }
        return foundTokens
    }
    

    
    func scanToken(_ scanner: Scanner, lastToken: Token?) -> Token? {
        consumeWhitespace(scanner)
        
        for token in Token.allCases {
            // skip Numeric scanner after numeric
            if let lastToken = lastToken, case .Numeric(_) = lastToken, case .Numeric(_) = token { continue }
            if case .Numeric(_) = token,
               let numericToken = scanNumeric(scanner) {
                return numericToken
            } else {
                if let foundToken = scanToken(scanner, token: token) {
                    return foundToken
                }
            }
        }
        return nil
    }

    func scanNumeric(_ scanner: Scanner) -> Token? {
        let startPosition = scanner.currentIndex

        // Numeric starts with "+"/"-" ?
        if let leadChar = scanner.scanCharacter(),
           CharacterSet.plusMinus.contains( Unicode.Scalar( leadChar.unicodeScalars.map({$0.value}).reduce(0, +) )!),
           let scanString = scanner.scanCharacters(from: CharacterSet.strictNumericCharacters),
           let newToken = Token.Numeric(1.0).instanciateWithValue(String(leadChar).appending(scanString)) {
            return newToken
        } else {
            scanner.currentIndex = startPosition
            if let scanString = scanner.scanCharacters(from: CharacterSet.strictNumericCharacters),
               let newToken = Token.Numeric(1.0).instanciateWithValue(scanString) {
                return newToken
            }
        }
        // reset start position
        scanner.currentIndex = startPosition
        return nil

    }
    
    
    
    func scanToken(_ scanner: Scanner, token: Token) -> Token? {
        let startPosition = scanner.currentIndex
        if let scanString = scanner.scanCharacters(from: token.scanCharacterSet),
           let newToken = token.instanciateWithValue(scanString) {
            return newToken
        }
        // reset start position
        scanner.currentIndex = startPosition
        return nil
    }

    func consumeWhitespace(_ scanner: Scanner) {
        var newStartPos = scanner.currentIndex
        while(true) {
            if let firstChar = scanner.scanCharacter(),
               firstChar.isWhitespace {
                newStartPos = scanner.string.index(after: newStartPos)
            } else {
                break
            }
        }
        scanner.currentIndex = newStartPos
    }
}
