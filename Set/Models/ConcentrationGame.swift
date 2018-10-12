//
//  Concentration.swift
//  Concentration
//
//  Created by GANG_FANG on 2018/6/12.
//  Copyright © 2018 gfang. All rights reserved.
//

import Foundation

class ConcentrationGame {
    
    private(set) var cards = [ConcentrationCard]()
    private(set) var flipCount = 0
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0,
               "Concentration.init(\(numberOfPairsOfCards)): You must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = ConcentrationCard()
            cards += [card, card]
        }
        cards.shuffle()
    }

    
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index),
                "Concentration.chooseCard(at: \(index)): Chosen index not in the card")
        flipCount += 1
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    

}



extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}



extension Array {
    mutating func shuffle() {
        for index in self.indices {
            let randomIndex = self.count.arc4random
            self.insert(self.remove(at: index), at: randomIndex)
        }
    }
}
