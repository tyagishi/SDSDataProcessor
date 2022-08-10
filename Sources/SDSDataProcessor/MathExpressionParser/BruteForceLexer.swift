//
//  BruteForceLexer.swift
//
//  Created by : Tomoaki Yagishita on 2021/09/24
//  © 2021  SmallDeskSoftware
//

import Foundation

extension Token {
    static func possibleTokens(pastTokens:[Token]) -> [Token] {
        guard let lastToken = pastTokens.last else { return Token.allCases }
        switch lastToken {
        case .numeric(_), .closeBracket:
            return [.binaryOperator("+"), .openBracket, .closeBracket]
        case .functionName(_):
            return [.numeric(1.0), .openBracket]
        default:
            return Token.allCases
        }
    }
}

public class BruteForceLexer {
    typealias Error = MathExpressionParserError
    let numericCharacterSet = CharacterSet.numericCharacters
    let groupingSeparator = Locale.current.groupingSeparator ?? ""
    
    public init() {}
    
    public func lex(_ string: String) throws -> [Token] {
        var foundTokens: [Token] = []
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = CharacterSet()

        consumeWhitespace(scanner)
        while !scanner.isAtEnd {
            guard let token = scanToken(scanner, pastTokens: foundTokens) else { throw Error.invalidToken }
            foundTokens.append(token)
            consumeWhitespace(scanner)
        }
        return foundTokens
    }

    func scanToken(_ scanner: Scanner, pastTokens: [Token]) -> Token? {
        for token in Token.possibleTokens(pastTokens: pastTokens) {
            if case .numeric(_) = token,
               let numericToken = scanNumeric(scanner) {
                return numericToken
            } else if token.isFunction {
                if let foundToken = scanFunction(scanner) {
                    return foundToken
                }
            } else if token.isCloseBracket {
                if let foundToken = scanCloseBracket(scanner) {
                    return foundToken
                }
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
           let newToken = Token.numeric(1.0).instanciateWithValue(String(leadChar).appending(scanString)) {
            return newToken
        } else {
            scanner.currentIndex = startPosition
            if let scanString = scanner.scanCharacters(from: CharacterSet.strictNumericCharacters),
               let newToken = Token.numeric(1.0).instanciateWithValue(scanString) {
                return newToken
            }
        }
        // reset start position
        scanner.currentIndex = startPosition
        return nil
    }
    
    func scanFunction(_ scanner: Scanner) -> Token? {
        let startPosition = scanner.currentIndex
        if let scanString = scanner.scanCharacters(from: CharacterSet.letters) {
            // next is (?
            if scanner.scanCharacter() == "(" {
                return Token.functionName(scanString)
            }
        }
        // reset start position
        scanner.currentIndex = startPosition
        return nil
    }
    
    func scanCloseBracket(_ scanner: Scanner) -> Token? {
        let startPosition = scanner.currentIndex
        if scanner.scanCharacter() == ")" {
            return Token.closeBracket
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
