//
//  FilterLexer.swift
//
//  Created by : Tomoaki Yagishita on 2024/11/21
//  © 2024  SmallDeskSoftware
//

import Foundation

public class FilterLexer {
    let chars: CharacterSet?
    let tokens: [String]?
    let caseSensitive: Bool
    let stringCompareOption: String.CompareOptions

    public init(chars: CharacterSet? = nil, tokens: [String]? = nil, caseSensitive: Bool = false) {
        self.chars = chars
        self.tokens = tokens
        self.caseSensitive = caseSensitive
        self.stringCompareOption = caseSensitive ? .caseInsensitive : .literal
    }

    public func filter(_ string: String) throws -> (string: String, disposed: String) {
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = CharacterSet()
        
        var retString: String = ""
        var disposeString: String = ""

        while !scanner.isAtEnd {
            // always try to scan tokens first
            if let token = scanToken(scanner) {
                retString.append(token)
                continue
            }
            if let character = scanCharacter(scanner) {
                retString.append(character)
                continue
            }
            //
            disposeString.append(scanner.string[scanner.currentIndex])
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        }
        return (retString, disposeString)
    }
    
    func scanToken(_ scanner: Scanner) -> String? {
        guard let tokens = tokens else { return nil }
        let startPosition = scanner.currentIndex
        for token in tokens {
            let length = token.count
            guard let endIndex = scanner.string.index(startPosition, offsetBy: length, limitedBy: scanner.string.endIndex) else { continue }
            if scanner.string[startPosition..<endIndex].compare(token, options: stringCompareOption) == .orderedSame {
                scanner.currentIndex = endIndex
                return token
            }
        }
        return nil
    }
    
    func scanCharacter(_ scanner: Scanner) -> String? {
        guard let chars = chars else { return nil }
        let scanned = scanner.scanCharacters(from: chars)
        return scanned
    }
}
