//
//  Card.swift
//  Concentration
//
//  Created by GANG_FANG on 2018/6/13.
//  Copyright © 2018 gfang. All rights reserved.
//

import Foundation

struct ConcentrationCard {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = ConcentrationCard.getUniqueIdentifier()
    }
}
