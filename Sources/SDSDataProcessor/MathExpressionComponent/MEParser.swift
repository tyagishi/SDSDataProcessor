//
//  File.swift
//  SDSDataProcessor
//
//  Created by Tomoaki Yagishita on 2025/08/13.
//

import Foundation
import SDSDataStructure

public typealias MEPolynomial = BinaryTreeNode<METoken>

public func parseExpression(_ expression: [METoken]) throws -> MEPolynomial {
    MEPolynomial(value: METoken.numeric(0, "0"))
}
