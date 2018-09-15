//
//  File.swift
//  Set
//
//  Created by GANG_FANG on 2018/6/29.
//  Copyright © 2018 gfang. All rights reserved.
//

import Foundation

struct SetCardDeck {
    
    private(set) var cards = [SetCard]()
    var cardsCount: Int { return cards.count }
    
    init() {
        for number in SetCard.Variant.all {
            for symbol in SetCard.Variant.all {
                for shading in SetCard.Variant.all {
                    for color in SetCard.Variant.all {
                        cards.append(SetCard(number: number,
                                            symbol: symbol,
                                            shading: shading,
                                            color: color))
                    }
                }
            }
        }
    }
    
    
    // TODO: think three use sites of this func, should forced unwrapping be used?
    // Or optional binding should be used instead?
    mutating func drawFromDeck() -> SetCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
}
