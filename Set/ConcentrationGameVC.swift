//
//  ViewController.swift
//  Concentration
//
//  Created by GANG_FANG on 2018/6/12.
//  Copyright © 2018 gfang. All rights reserved.
//

import UIKit

class ConcentrationGameVC: UIViewController {
    
    private var game: ConcentrationGame!
    private var emojiChoices: [String]!
    private var themes = ["face": ["😀", "😃", "😄", "😁", "😆", "😅", "😂"],
                          "animal": ["🐶", "🐱", "🦊", "🐻", "🐹", "🐰", "🐭"],
                          "fruit": ["🍎", "🍐", "🍋", "🍉", "🍊", "🍌", "🍏"]]
    private var emoji = [Int:String]()
    var numberOfPairsOfCards: Int {
        return (cardButtons.count+1) / 2
    }
    
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    @IBAction func startNewGame(_ sender: UIButton) {
        pickATheme()
        initializeGameModel()
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        initializeGameModel()
        pickATheme()
        
    }
    
    private func initializeGameModel() {
        game = ConcentrationGame(numberOfPairsOfCards: numberOfPairsOfCards)
    }
    
    private func pickATheme() {
        let themeNames = Array(themes.keys)
        emojiChoices = themes[themeNames[themes.count.arc4random]]!
    }
    
    
    private func updateViewFromModel() {
        flipCountLabel.text = "Flips: \(game.flipCount)"
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    private func emoji(for card: ConcentrationCard) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        
        return emoji[card.identifier] ?? "?"
    }
}
