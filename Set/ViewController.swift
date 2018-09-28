//
//  ViewController.swift
//  Set
//
//  Created by GANG_FANG on 2018/6/25.
//  Copyright © 2018 gfang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var setGame = SetGame()
    
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var dealThreeMoreCardsButton: UIButton! {
        didSet {
            dealThreeMoreCardsButton.layer.borderWidth = 3.0
            dealThreeMoreCardsButton.layer.borderColor = UIColor(rgb: 0x8DFA00).cgColor
            dealThreeMoreCardsButton.layer.cornerRadius = 8.0
            dealThreeMoreCardsButton.setTitleColor(UIColor(rgb: 0x8DFA00), for: .normal)
        }
    }
    @IBOutlet weak var newGameButton: UIButton! {
        didSet {
            newGameButton.layer.borderWidth = 3.0
            newGameButton.layer.borderColor = UIColor(rgb: 0x8DFA00).cgColor
            newGameButton.layer.cornerRadius = 8.0
            newGameButton.setTitleColor(UIColor(rgb: 0x8DFA00), for: .normal)
        }
    }
    @IBOutlet weak var deckCountLabel: UILabel!
    
    
    @IBAction func rotateToReshuffleCards(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            reshuffleCards()
        default:
            break
        }
    }
    @IBAction func swipeToDealThreeMoreCards(_ sender: UISwipeGestureRecognizer) {
        switch sender.state {
        case .ended:
            dealThreeMoreCards()
        default:
            break
        }
    }
    @IBAction func pressDealThreeMoreCardsButton(_ sender: UIButton) {
        dealThreeMoreCards()
    }
    @IBAction func pressNewGameButton(_ sender: UIButton) {
        setGame = SetGame()
        updateViewFromModel()
    }
    
    
    private func reshuffleCards() {
        setGame.reshuffleCards()
        updateViewFromModel()
    }
    
    
    private func dealThreeMoreCards() {
        setGame.dealThreeMoreCards()
        updateViewFromModel()
    }
    
    
    private func updateViewFromModel() {
        updateCardsFromModel()
        updateSelectedCardsFromModel()
        configureDealThreeMoreCardsButtonClickability()
        updateDeckCountLabel()
    }
    
    
    private func updateCardsFromModel() {
        boardView.cardViews = setGame.cardsOnTable.map { setCard in
            let cardView = CardView()   // should I use var?
            cardView.symbolInt = setCard.symbol.rawValue
            cardView.fillingInt = setCard.shading.rawValue
            cardView.colorInt = setCard.color.rawValue
            cardView.number = setCard.number.rawValue
            
            let tap = UITapGestureRecognizer(target: self,
                                             action: #selector(selectOrDeselectCard(byHandlingGestureRecognizedBy:)))
            cardView.addGestureRecognizer(tap)
            return cardView
        }
    }
    
    
    @objc func selectOrDeselectCard(byHandlingGestureRecognizedBy recognizer: UITapGestureRecognizer) {
        if let card = recognizer.view as? CardView, let cardNumber = boardView.cardViews.index(of: card) {
            setGame.touchACard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    
    private func updateSelectedCardsFromModel() {
        for selectedCard in setGame.selectedCards {
            if let matchedCardIndex = setGame.cardsOnTable.index(of: selectedCard) {
                let cardView = boardView.cardViews[matchedCardIndex]
                cardView.isSelected = true
                if setGame.currentlyAMatch {
                    cardView.isMatched = true
                }
            }
        }
    }
    
    
    private func configureDealThreeMoreCardsButtonClickability() {
        if setGame.deck.cardsCount == 0 {
            dealThreeMoreCardsButton.isEnabled = false
        } else {
            dealThreeMoreCardsButton.isEnabled = true
        }
    }

    
    private func updateDeckCountLabel() {
        deckCountLabel.text = "Deck: \(setGame.deck.cardsCount)"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        
        boardView.backgroundColor = .clear
        boardView.isOpaque = false
    }
}





extension UIColor {
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
