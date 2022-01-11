//
//  Card.swift
//  ConcentrationProduction
//
//  Created by Oleg E on 1/10/22.
//  Copyright © 2022 Oleg E. All rights reserved.
//

import Foundation

struct Card : Hashable {
    var hashValue: Int {
        return identifier
    }
    
    static func ==(lhs:Card,rhs:Card) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
