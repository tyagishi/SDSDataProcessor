//
//  Test.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/04/18.
//

import Testing
import RegexBuilder

struct UnderstandRegex {

    @Test func surrounding() async throws {
        let sut = Regex {
            "ABC"
        }
        let parenthesised = Regex {
            ChoiceOf {
                Regex {
                    ZeroOrMore(.whitespace)
                    "("
                    ZeroOrMore(.whitespace)
                    sut
                    ZeroOrMore(.whitespace)
                    ")"
                    ZeroOrMore(.whitespace)
                }
                sut
            }
        }
        
        
        var simpleMatch = try parenthesised.wholeMatch(in: "ABC")
        #expect(simpleMatch?.output == "ABC")

        simpleMatch = try parenthesised.wholeMatch(in: "(ABC")
        #expect(simpleMatch == nil)

        simpleMatch = try parenthesised.wholeMatch(in: "ABC)")
        #expect(simpleMatch == nil)

        simpleMatch = try parenthesised.wholeMatch(in: "( ABC)")
        #expect(simpleMatch?.output == "( ABC)")
    }
    
//    @Test func recursive() async throws {
//        let abcRegex = Regex {
//            ChoiceOf {
//                "A"
//                "B"
//                "C"
//            }
//        }
//        let surrounded = Regex {
//            ChoiceOf {
//                Regex {
//                    "("
//                    abcRegex
//                    ")"
//                }
//                abcRegex
//            }
//        }
//        
//        let nested = Regex {
//            ChoiceOf {
//                surrounded
//                Regex {
//                    ZeroOrMore(.whitespace)
//                    "("
//                    ZeroOrMore(.whitespace)
//                    surrounded
//                    ZeroOrMore(.whitespace)
//                    ")"
//                    ZeroOrMore(.whitespace)
//                }
//            }
//        }
//        
//        var simpleMatch = try nested.wholeMatch(in: "A")
//        #expect(simpleMatch?.output == "A")
//
//        simpleMatch = try nested.wholeMatch(in: "(A)")
//        #expect(simpleMatch == "(A)")
//
////        simpleMatch = try parenthesised.wholeMatch(in: "ABC)")
////        #expect(simpleMatch == nil)
////
////        simpleMatch = try parenthesised.wholeMatch(in: "( ABC)")
////        #expect(simpleMatch?.output == "( ABC)")
////
////        let x = 3
//    }

}
