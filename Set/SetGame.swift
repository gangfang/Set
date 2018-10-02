//
//  SetGame.swift
//  Set
//
//  Created by GANG_FANG on 2018/6/26.
//  Copyright © 2018 gfang. All rights reserved.
//

import Foundation

class SetGame {
    var deck = SetCardDeck()
    var cardsOnTable = [SetCard]()
    var selectedCards = [SetCard]()
    var discardPile = [SetCard]()
    var currentlyAMatch = false
    let initialNumberOfCardsOnTable = 12
    
    init() {
        drawFromDeck(initialNumberOfCardsOnTable)
    }
    
    
    func touchACard(at cardNumber: Int) {
        if isSelected(card: cardsOnTable[cardNumber]) {
            if selectedCards.count == 3 {
                deselectAllSelectedCards()
            } else {
                deselectACard(at: cardNumber)
            }
        } else {
            selectACard(at: cardNumber)
        }
    }
    
    
    private func isSelected(card: SetCard) -> Bool {
        return selectedCards.contains(card)
    }
    
    
    private func deselectAllSelectedCards() {
        selectedCards.removeAll()
    }
    
    
    private func deselectACard(at cardNumber: Int) {
        selectedCards.remove(at: selectedCards.index(of: cardsOnTable[cardNumber])!)
    }
    
    // TODO: may need further refactoring after intial refactoring
    private func selectACard(at cardNumber: Int) {
        if selectedCards.count == 3 {
            if currentlyAMatch {
                replaceOrRemoveMatchedCards()
                addSelectedCardsToDiscardPile()
            }
            deselectAllSelectedCards()
        }
        
        selectedCards.append(cardsOnTable[cardNumber])
        
        currentlyAMatch = SetGame.isAMatch(selectedCards)
    }
    
    
    private func replaceOrRemoveMatchedCards() {
        if deck.cardsCount > 0 {
            let new = [deck.draw()!, deck.draw()!, deck.draw()!]
            cardsOnTable.replace(old: selectedCards, with: new)
        } else {
            cardsOnTable.remove(elements: selectedCards)
        }
    }
    
    
    private func addSelectedCardsToDiscardPile() {
        discardPile += selectedCards
    }
    
    
    static private func isAMatch(_ cards: [SetCard]) -> Bool {
        guard cards.count == 3 else { return false }
        let sums = [
            cards.reduce(0, {$0 + $1.number.rawValue}),
            cards.reduce(0, {$0 + $1.symbol.rawValue}),
            cards.reduce(0, {$0 + $1.shading.rawValue}),
            cards.reduce(0, {$0 + $1.color.rawValue})
        ]
        return sums.reduce(true, {$0 && $1 % 3 == 0})
    }
    
    
    func dealThreeMoreCards() {
        if currentlyAMatch {
            replaceOrRemoveMatchedCards()
            selectedCards.removeAll()
            currentlyAMatch = false
        } else {
            addThreeCardsToGame()
        }
    }
    
    
    private func addThreeCardsToGame() {
        guard deck.cardsCount != 0 else { return }
        
        for _ in 0...2 {
            cardsOnTable.append(deck.draw()!)
        }
    }
    
    
    func reshuffleCards() {
        guard selectedCards.count == 0 else { return }
        
        deck.putBack(cardsOnTable)
        deck.shuffle()
        
        let numberOfCardsOnTable = cardsOnTable.count
        cardsOnTable = []
        drawFromDeck(numberOfCardsOnTable)
    }
    
    
    private func drawFromDeck(_ numberOfCards: Int) {
        for _ in 0..<numberOfCards {
            if let aCardFromDeck = deck.draw() {
                cardsOnTable.append(aCardFromDeck)
            }
        }
    }
}









extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}




extension Array where Element: Equatable {
    mutating func replace(old: [Element], with new: [Element]) {
        guard old.count == new.count else { return }
        for index in new.indices {
            if let indexOfCardToBeReplaced = self.index(of: old[index]) {
                self[indexOfCardToBeReplaced] = new[index]
            }
        }
    }
    
    
    mutating func remove(elements: [Element]) {
        self = self.filter { !elements.contains($0) }
    }
    
    
    mutating func shuffle() {
        var temp = self
        self = []
        while temp.count > 0 {
            self.append(temp.remove(at: temp.count.arc4random))
        }
    }
}
